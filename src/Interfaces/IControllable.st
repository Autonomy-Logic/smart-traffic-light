(* IControllable Interface
   Common interface for all controllable traffic devices.
   Provides standard enable/disable and status query methods. *)

INTERFACE IControllable
  METHOD Enable : BOOL
  END_METHOD

  METHOD Disable : BOOL
  END_METHOD

  METHOD IsEnabled : BOOL
  END_METHOD

  METHOD GetStatus : INT
  END_METHOD
END_INTERFACE
