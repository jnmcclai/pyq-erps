########################################################################
#                                                                      #
#             Lab Manager Tcl API Example Wrapper Script               #
#                                                                      #
# Gale Technologies                                                    #
# (c) copyright 2009                                                   #
#                                                                      #
########################################################################

# LabManager Tcl API Wrapper
package provide LabManager 1.0

# XMLRPC is part of the tclSOAP package
package require XMLRPC


# Used for defineing typedefs
package require rpcvar
namespace import rpcvar::typedef


typedef {
    bytype string
    match string
    attributes string
} substitution

typedef {
    substitute substitution
    selector string
} topo_device_options

typedef {
    name string
    x int
    y int
    interfaces int()
    interface_names string()
    options topo_device_options
} topo_device

typedef {
    port1 string()
    port2 string()
} zlink

typedef {
    shared string
    retime string
    force string
    manual string
    protocol_rate string
    tx_substitute substitution
    rx_substitute substitution
    zlinks zlink()
} topo_connection_options

typedef {
    device1 string
    interface1 int
    interface1_name string
    device2 string
    interface2 int
    interface2_name string
    direction string
    options topo_connection_options
} topo_connection

typedef {
    x int
    y int
    label string
    connection topo_connection
} topo_tap

typedef {
    x int
    y int
    label string
} topo_monitor

typedef {
    zlinks zlink()
} topo_monitor_connection_options

typedef {
    label string
    device string
    interface int
    interface_name string
    source string
    options topo_monitor_connection_options
} topo_monitor_connection

typedef {
    text string
    x int
    y int
} topo_label

typedef {
    devices topo_device()
    connections topo_connection()
    taps topo_tap()
    monitors topo_monitor()
    monitor_connections topo_monitor_connection()
    labels topo_label()
} topo_content

typedef {
    groups string()
    users string()
} accessrights

# List of the server's exported procedures with their parameters and
#   parameter types.
# This is the only place that needs to be modified when adding new commands.
set rpcProcedures [list \
  {login name string password string} \
  {getServerTime session string} \
  {getActiveUserInfo session string user_name_list any()} \
  {scheduleReservation session string topology string duration int \
                       start int type string deadline int} \
  {confirmTentative session string rsvn_id int ans int} \
  {getDevicePorts session string device string} \
  {getDeviceAttributes session string device string} \
  {getDevicePortAttributes session string device string interface int} \
  {getDevicePortAttributesByName session string device string \
                                 interface string}\
  {getReservationConnections session string rsvn_id int} \
  {changeDuration session string rsvn_id int change int} \
  {getInterfacesInUseOneList session string interfaces any() \
                             start int duration int} \
  {addDevice session string rsvn_id int device string interface int} \
  {addConnection session string rsvn_id int iface1 array iface2 array \
                 direction string shared int manual int aggregate_id int \
                 tx_subst int rx_subst int force int retime int \
                 protocol_rate string} \
  {removeConnection session string rsvn_id int iface1 array \
                    iface2 array} \
  {removeDevice session string rsvn_id int device string interface int} \
  {traceRoute session string rsvn_id int connection_id string} \
  {disableConnection session string rsvn_id int connection_id string} \
  {enableConnection session string rsvn_id int connection_id string} \
  {getDeviceInfo session string device string} \
  {getAllDevices session string} \
  {getReservations session string starttime int endtime int} \
  {enablePower session string reservation_id int device string \
               interface int} \
  {checkPowerStatus session string reservation_id int device string \
                    interface int} \
  {checkPowerPortListStatus session string reservation_id int tuple string()} \
  {disablePower session string reservation_id int device string \
                interface int} \
  {getUserNotices session string} \
  {getResourceReservations session string device string interface int \
                           starttime int endtime int} \
  {getReservationContent session string rsvn_id int} \
  {addReservationContent session string rsvn_id int 
                         content topo_content} \
  {removeReservationContent session string rsvn_id int \
                            content topo_content} \
  {changeReservationContent session string rsvn_id int \
                            added_content topo_content \
                            removed_content topo_content} \
  {getActiveDevices session string device_id_list any()} \
  {getSystemResources session string} \
  {getQueryableDeviceAttributes session string} \
  {changePriority session string reservation_id int priority int} \
  {queryDevicesByAttributes session string attr struct} \
  {getReservationDevices session string rsvn_id int} \
  {cancelReservations session string rsvn_id_list int()} \
  {getAllScripts session string} \
  {saveScript session string alias string uri string expose string \
              params string type string data string running int \
              remote_server string usage int} \
  {findNearbyDevices session string source string target \
                     string ifacetype string compatible string() \
                     cost int} \
  {getDeviceNote session string device string} \
  {setDeviceNote session string device string note string} \
  {getInterfaceNote session string device string interface int} \
  {setInterfaceNote session string device string interface int \
                    note string} \
  {getReservationNote session string rsvn_id int} \
  {setReservationNote session string rsvn_id int note string} \
  {getChassisListInfo session string} \
  {getChassisInfo session string chassis string} \
  {getSlotInfo session string chassis string slot string} \
  {topologyCreate session string path string content topo_content} \
  {topologyAddItems session string path string content topo_content} \
  {topologyRemoveItems session string path string \
                       content topo_content} \
  {topologyGet session string path string} \
  {topologyCopy session string oldpath string newpath string} \
  {topologyDelete session string path string} \
  {topologyRename session string oldpath string newpath string} \
  {topologyMove session string oldpath string newpath string} \
  {folderCreate session string path string} \
  {folderDelete session string path string} \
  {folderGet session string path string} \
  {createDevice session string device string type string folder string \
                icon string ip string port int protocol string \
                exclusive string} \
  {deleteDevice session string device string} \
  {createInterface session string device string rate string index int \
                   name string shared string} \
  {deleteInterface session string device string interface int} \
  {changeInterfaceIndex session string device string interface int \
                        new_index int} \
  {changeInterfaceName session string device string interface int \
                       new_name string} \
  {changeInterfaceShared session string device string interface int \
                         value string} \
  {addInterfaceRate session string device string interface int \
                    new_rate string} \
  {deleteInterfaceRate session string device string interface int \
                       existing_rate string} \
  {getReservationSubstitutions session string rsvn_id int} \
  {publish session string} \
  {changeDeviceName session string old_name string new_name string} \
  {changeDeviceType session string device string new_type string} \
  {changeDeviceIcon session string device string \
                    new_icon_name string} \
  {changeDeviceExclusive session string device string \
                         exclusive string} \
  {addDeviceAttribute session string device string name string \
                      value string} \
  {deleteDeviceAttribute session string device string name string} \
  {addInterfaceAttribute session string device string interface int \
                         name string value string} \
  {deleteInterfaceAttribute session string device string interface int \
                            name string} \
  {addDeviceIp session string device string ip string port int \
               protocol string} \
  {deleteDeviceIp session string device string ip string port int} \
  {addToDomain session string domain string device string} \
  {deleteFromDomain session string domain string device string} \
  {mapInterfaceToPort session string device string interface int \
                      chassis string slot string port int} \
  {unmapInterface session string device string interface int} \
  {createDeviceType session string name string icon string} \
  {createDeviceFolder session string name string path string} \
  {deleteDeviceFolder session string path string} \
  {addPermission session string device string user string \
                 group string} \
  {deletePermission session string device string user string \
                    group string} \
  {moveDevice session string device string new_path string} \
  {moveDeviceFolder session string old_path string new_path string} \
  {renameDeviceFolder session string old_path string new_name string} \
  {getReservationAlarms session string rsvn_id int} \
  {getChassisAlarms session string chassis string refresh int} \
  {getChassisPortDiagnostics session string device string \
	                         interface int} \
  {getLastReservation session string device string} \
  {getAllInterfacesInUse session string} \
  {itemExists session string path string} \
  {getDevices session string path string relative string recursive int} \
  {getRsvnAccessRights session string rsvn int} \
  {changeRsvnAccessRights session string rsvn int rights accessrights} \
  {getTopologies session string path string relative string recursive int} \
  {getTopologyDevices session string path string} \
  {setTestCaseOutput session string rsvn_id int test_case_pid int \
                     test_case_details string append int final int \
                     output string} \
  {getGroupMembers session string} \
  {getAllGroups session string} \
  {getGroups session string} \
  {getUserGroups session string username string} \
  {getUsers session string usernames string()} \
  {getRsvnAccessRights session string rsvn int} \
  {changeRsvnAccessRights session string rsvn int rights accessrights} \
  {getReservationStatus session string rsvn int} \
  {getConnStatusUpdate session string rsvn int} \
  {getSessionUpdates session string} \
  {getAllDevices session string} \
  {getSystemResources session string} \
  {getLastReservation session string device string} \
  {getSavedTopologyNames session string} \
  {getSavedTopologiesUsingDevice session string device string} \
  {getSavedTopologiesUsingDeviceInterface session string device string \
                                          interface int} \
  {getDeviceName session string device int} \
  {getTopologyDictionary session string topology string} \
  {getDeviceByChassisSlotPort session string chassis string slot int port int} \
  {getActiveConnections session string device name interface int} \
  {getChassisListInfo session string} \
  {createChassis session string name string manufacturer string class string \
                 type string ip string port int username string \
                 password string} \
  {changeChassisName session string chassis string new_name string} \
  {changeChassisIp session string chassis string ip string port int} \
  {changeChassisUser session string chassis string user string pw string} \
  {addSlot session string chassis name slottype string position string} \
  {addPorts session string chassis name position string count int} \
  {deleteSlot session string chassis string position string} \
  {deleteChassis session string name string} \
  {addFeature session string chassis string position string ftype string \
              fname string} \
  {removeFeature session string chassis string position string ftype string \
              fname string} \
  {isAutoTestIntegrationLicensed session string} \
  {logout session string}
]

set sessionId ""

# Set to 1 in order to print the xml request/response
set debug 0

proc LabManager {cmdName args} {
      global rpcProcedures
      global sessionId
      global debug
      global errorInfo

      # If this is the login command then we need to do some extra setup
      if {$cmdName == "login"} {
            # positions of the command line parameters:
            #      (server username password)
            set SERVER_OFFSET   0
            set USERNAME_OFFSET 1
            set PASSWORD_OFFSET 2

            # Get the server name
            if {[llength $args] >= [expr {$SERVER_OFFSET + 1}]} {
                   set serverName [lindex $args $SERVER_OFFSET]
                   set serverUrl "http://$serverName:8080/scriptserver/"
            } else {
                   # They didn't pass a server name to us.
                   return "ERROR No server name found"
            }

            # Create the RPC bindings
            createRpcBindings $serverUrl $rpcProcedures

            # Remove the server name parameter from the args list
            set args [lrange $args 1 end]
      }

      # If this is not the login command then insert the session id
      if {$cmdName != "login"} {
            set args [linsert $args 0 $sessionId]
      }

      # Make the actual RPC call. Catch the exception if it throws one.
      set hadError 0
#      puts "$cmdName $args"
      if {[catch {eval $cmdName $args} result]} {
            # There was an error
            # Get the first line of the error text.
            # The remaining lines of error info was the stack trace.
            set msg [lindex [split $errorInfo "\n"] 0]

            # Add the "ERROR" prefix
            set result [list 1 $msg]

            # Remember we had an error for later on
            set hadError 1
      }

      # The "result" returned by the server is a Tcl list. The first item
      # on the list is a integer status code. A status code of "0" means
      # the command passed. A status code of any other number implies an
      # error.
      # If the command passed (status code of 0) then the second item on
      # the list is the information returned by the server. If there was an
      # error then the second item on the list contains the error message.

#      puts $result

      # Print the XML if the debug flag was on
      if {$debug == 1} {
            puts "REQUEST"
            puts [XMLRPC::dump -request $cmdName]
            puts "RESPONSE"
            puts [XMLRPC::dump -reply $cmdName]
      }

      # If this was the login command then we need to remember
      #     the session id that got returned to us.
      if {$cmdName == "login" && $hadError == 0} {
            set sessionId [lindex $result 1]
      }

      # If this was the logout command then delete the session id
      if {$cmdName == "logout"} {
            set sessionId ""
      }

      # Get the error status of the command
      set status [lindex $result 0]
      if {$status} {
          puts "$status"
          error [lindex $result 0] [lindex $result 1]
      }

      # Return the command result back to the user script.
      return [lindex $result 1]
}

proc createRpcBindings {serverUrl procList} {
      for {set i 0} {$i < [llength $procList]} {incr i} {
            set rpcProc [lindex $procList $i]
            set cmdName [lindex $rpcProc 0]
            set params [lrange $rpcProc 1 end]
            XMLRPC::create $cmdName -proxy $serverUrl -params $params
      }
}
