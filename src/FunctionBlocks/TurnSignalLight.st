(* TurnSignalLight Function Block
   Extends TrafficLight with a dedicated turn signal arrow.
   The turn arrow activates during the RED-to-GREEN transition. *)

FUNCTION_BLOCK TurnSignalLight EXTENDS TrafficLight
  VAR_INPUT
    turnEnabled   : BOOL := TRUE;
    turnDuration  : TIME := T#10s;
  END_VAR

  VAR_OUTPUT
    turnArrowOn   : BOOL := FALSE;
    turnDirection : INT := 0;   (* 0=none, 1=left, 2=right *)
  END_VAR

  VAR
    turnTimer    : TON;
    turnActive   : BOOL := FALSE;
    prevState    : TrafficState := TrafficState.RED;
  END_VAR

  METHOD PUBLIC SetLeftTurn : BOOL
    turnDirection := 1;
    SetLeftTurn := TRUE;
  END_METHOD

  METHOD PUBLIC SetRightTurn : BOOL
    turnDirection := 2;
    SetRightTurn := TRUE;
  END_METHOD

  METHOD PUBLIC IsTurnActive : BOOL
    IsTurnActive := turnArrowOn;
  END_METHOD

  (* Run parent TrafficLight state machine first *)
  SUPER^();

  (* Detect RED-to-GREEN transition to activate turn signal *)
  IF prevState = TrafficState.RED AND currentState = TrafficState.GREEN THEN
    IF turnEnabled AND turnDirection > 0 THEN
      turnActive := TRUE;
    END_IF;
  END_IF;

  (* Run turn signal timer *)
  turnTimer(IN := turnActive, PT := turnDuration);
  IF turnTimer.Q THEN
    turnActive := FALSE;
    turnTimer(IN := FALSE, PT := turnDuration);
  END_IF;

  (* Turn off arrow when not in GREEN phase *)
  IF currentState <> TrafficState.GREEN THEN
    turnActive := FALSE;
  END_IF;

  turnArrowOn := turnActive;
  prevState := currentState;
END_FUNCTION_BLOCK
