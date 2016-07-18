#!/usr/bin/python
#coding: utf-8

__author__    = "jnmcclai"
__copyright__ = "Copyright 2016, Adtran, Inc."
__version__   = "2.7.8"

import Tkinter
import time

class Gale():
    """
    Gale Technologies Calient fiber switch.
    Perform Calient fiber switches in the form of disabling, enabling, deleting, creating links
    Utilizes existing API and TCL wrapper script LabManager.tcl
    Requires TCL
    """
    def __init__(self, server, port, username, password, reservation_id):
        """
        Class initialization

        *Parameters*:
            - server: <string> ; Calient IP address
            - port: <string> ; Calient port
            - username: <string> ; Lab Manager username
            - password: <string> ; Lab Manager password
            - reservation_id: <string> ; Lab Manager resrvation ID (e.g. 60867)

        Assumes debug = 0 in TCL wrapper script

        """
        self.server = server
        self.port = port
        self.username = username
        self.password = password
        self.reservation_id = reservation_id
        self.session_id = ''
        self.reservation_connections = ''

        #create class scoped tcl session
        self.session_tcl = Tkinter.Tcl()


    def source_lab_manager(self, filename="LabManager.tcl"):
        """
        Use the TCL Lab Manager API wrapper script

        *Parameters*:
             filename: <string> ; Gale Calient TCL API wrapper script file name
        """
        try:
            self.session_tcl.eval("source LabManager.tcl")
        except:
            raise AssertionError("TCL source not complete - verify file")

    def login(self):
        """
        Login to the Calient using Lab Manager API
        """
        try:
            output = self.session_tcl.eval("LabManager login {0} {1} {2}".format(self.server, self.username, self.password))
            if "500: Internal Server Error" in output:
                raise AssertionError("Login not successful - check server IP and credentials")
            self.session_id = output
        except:
            raise AssertionError("Login not successful - check server IP and credentials")

    def get_reservation_connections(self):
        """
        Returns list of connections for a given session id
        """
        output = self.session_tcl.eval("LabManager getReservationConnections {0}".format(self.reservation_id))
        if "500: Internal Server Error" in output or "not found" in output:
            raise AssertionError("getReservationConnections not successful - check reservation id")        
        self.reservation_connections = output
        return self.reservation_connections

    def connection_disable(self, connection_id):
        """
        Disables a Calient Technologies Lab Manager connection

        *Parameters*:
             connection_id: <string> ; Gale Calient connection identifier - see Device Connection Properties
             in Lab Manager (e.g. d0d5c089-4bd6-45eb-88fb-5bd656855d27).
        """
        output = self.session_tcl.eval("LabManager disableConnection {0} {1}".format(self.reservation_id, connection_id))
        if "500: Internal Server Error" in output or "not found" in output:
            raise AssertionError("disableConnection not successful - check reservation connection id")

    def connection_enable(self, connection_id):
        """
        Enables a Calient Technologies Lab Manager connection

        *Parameters*:
             connection_id: <string> ; Gale Calient connection identifier - see Device Connection Properties
             in Lab Manager (e.g. d0d5c089-4bd6-45eb-88fb-5bd656855d27).        
        """
        output = self.session_tcl.eval("LabManager enableConnection {0} {1}".format(self.reservation_id, connection_id))
        if "500: Internal Server Error" in output or "not found" in output:
            raise AssertionError("enableConnection not successful - check reservation connection id")        

    def connection_remove(self, endpoint_a, endpoint_b):
        """
        Removes a Calient Technologies Lab Manager connection

        *Parameters*:
            - endpoint_a: <string> ; One of the Gale Calient link connection endpoint name (e.g. Cisco7604 13)
            - endpoint_b: <string> ; The other Gale Calient link connection endpoint name  (e.g. dslam 1)

        Note: if connection in a pendint state then will not work - would be good to poll the status and notify user
        """
        output = self.session_tcl.eval("LabManager removeConnection {0} {{{1}}} {{{2}}}".format(self.reservation_id, endpoint_a, endpoint_b))
        #if "500: Internal Server Error" in output or "not found" in output:
        #    raise AssertionError("removeConnection not successful - check endpoints")

    def connection_add(self, endpoint_a, endpoint_b, paramDict):
        """
        Adds a Calient Technologies Lab Manager connection

        *Parameters*:
            - endpoint_a: <string> ; One of the Gale Calient link connection endpoint name (e.g. Cisco7604 13)
            - endpoint_b: <string> ; The other Gale Calient link connection endpoint name  (e.g. dslam 1)
            - paramDict: <dict> ; Dictionary containing Gale Calient add connection parameters.
            | *Key* | *Value* | *Comment* |
            | direction | <string> | direction of connection [bidir] |
            | shared | <int> | connection shared [0|1] |
            | manual | <int> | connection type manual [0|1] |
            | aggregate_id | <int> | aggregate_id [0|1] |
            | tx_subst | <int> | tx_subst |
            | rx_subst | <int> | tx_subst |
            | force | <int> | force |
            | retime | <int> | connection taps | retime [0|1]
            | protocol_rate | <string> | connection protocol rate [Optical-Generic] |

        Note: if ports are already connected (even just bound by the device) will not work - good to poll this as well and 
        disconnect as needed
        """
        if type(paramDict) is not dict:
            raise AssertionError('paramDict is not dictionary')

        if paramDict.has_key('direction') and paramDict['direction'] is not None:
            direction = paramDict['direction']
        else:
            direction = "bidr"

        if paramDict.has_key('shared') and paramDict['shared'] is not None:
            shared = paramDict['shared']
        else:
            shared = 0

        if paramDict.has_key('manual') and paramDict['manual'] is not None:
            manual = paramDict['manual']
        else:
            manual = 0

        if paramDict.has_key('aggregate_id') and paramDict['aggregate_id'] is not None:
            aggregate_id = paramDict['aggregate_id']
        else:
            aggregate_id = 1      
            
        if paramDict.has_key('tx_subst') and paramDict['tx_subst'] is not None:
            tx_subst = paramDict['tx_subst']
        else:
            tx_subst = 0

        if paramDict.has_key('rx_subst') and paramDict['rx_subst'] is not None:
            rx_subst = paramDict['rx_subst']
        else:
            rx_subst = 0

        if paramDict.has_key('force') and paramDict['force'] is not None:
            force = paramDict['force']
        else:
            force = 0  

        if paramDict.has_key('retime') and paramDict['retime'] is not None:
            retime = paramDict['retime']
        else:
            retime = 0    
            
        if paramDict.has_key('protocol_rate') and paramDict['protocol_rate'] is not None:
            protocol_rate = paramDict['protocol_rate']
        else:
            protocol_rate = "Optical-Generic"                                                  

        output = self.session_tcl.eval("LabManager addConnection {0} {{{1}}} {{{2}}} {3} {4} {5} {6} {7} {8} {9} {10} {11}".format(self.reservation_id, endpoint_a, endpoint_b, direction, shared, manual, aggregate_id, tx_subst, rx_subst, force, retime, protocol_rate))
        if "500: Internal Server Error" in output or "not found" in output:
            raise AssertionError("addConnection not successful - check parameters")        

if __name__ == "__main__":
    
    #initialize some variables
    server = "1.1.1.1"
    port = "8080"
    username = "<username>"
    password = "<password>"
    rsvn_id = "12345"
    endpoint_a = "E43_ERPS_N5 1"
    endpoint_b = "E43_ERPS_N6 2"
    connection_id = "f95c4d84-91df-43ed-9efe-1c765bee3a54"
    paramDict = dict()

    #create an instance of class
    instance = Gale(server, port, username, password, rsvn_id)
    #source the TCL script
    instance.source_lab_manager()
    #login
    instance.login()
    #grab the reservation connections
    rsvns = instance.get_reservation_connections()
    #print the reservation connections
    print rsvns
    #disable a connection
    instance.connection_disable(connection_id)
    #enable a connection
    instance.connection_enable(connection_id)
    #remove a connection
    instance.connection_remove(endpoint_a, endpoint_b)
    #add a connection
    instance.connection_add(endpoint_a, endpoint_b, paramDict)
