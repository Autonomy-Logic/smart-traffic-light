(* TrafficLight Function Block
   State machine for a standard 3-phase traffic signal.
   Cycles: RED -> GREEN -> YELLOW -> RED
   Supports night mode with flashing yellow. *)

FUNCTION_BLOCK TrafficLight
  VAR_INPUT
    enable    : BOOL := TRUE;
    timing    : PhaseTiming;
    nightMode : BOOL := FALSE;
  END_VAR

  VAR_OUTPUT
    currentState : TrafficState := TrafficState.RED;
    redLight     : BOOL := TRUE;
    yellowLight  : BOOL := FALSE;
    greenLight   : BOOL := FALSE;
  END_VAR

  VAR
    phaseTimer      : TON;
    flashTimer      : TON;
    currentDuration : TIME;
    flashOn         : BOOL := FALSE;
  END_VAR

  METHOD PUBLIC GetState : TrafficState
    GetState := currentState;
  END_METHOD

  METHOD PUBLIC IsGreen : BOOL
    IsGreen := (currentState = TrafficState.GREEN);
  END_METHOD

  METHOD PUBLIC IsRed : BOOL
    IsRed := (currentState = TrafficState.RED);
  END_METHOD

  METHOD PUBLIC IsNightMode : BOOL
    IsNightMode := nightMode;
  END_METHOD

  IF nightMode THEN
    (* Night mode: flash yellow at 1Hz *)
    flashTimer(IN := TRUE, PT := T#500ms);
    IF flashTimer.Q THEN
      flashOn := NOT flashOn;
      flashTimer(IN := FALSE, PT := T#500ms);
      flashTimer(IN := TRUE, PT := T#500ms);
    END_IF;

    redLight    := FALSE;
    yellowLight := flashOn;
    greenLight  := FALSE;
    currentState := TrafficState.YELLOW;
  ELSE
    (* Normal operation *)
    flashOn := FALSE;

    (* Determine the duration for the current phase *)
    CASE currentState OF
      TrafficState.RED:
        currentDuration := timing.redDuration;
      TrafficState.GREEN:
        currentDuration := timing.greenDuration;
      TrafficState.YELLOW:
        currentDuration := timing.yellowDuration;
    END_CASE;

    (* Run the phase timer *)
    phaseTimer(IN := enable, PT := currentDuration);

    (* Transition to the next state when timer expires *)
    IF phaseTimer.Q THEN
      CASE currentState OF
        TrafficState.RED:
          currentState := TrafficState.GREEN;
        TrafficState.GREEN:
          currentState := TrafficState.YELLOW;
        TrafficState.YELLOW:
          currentState := TrafficState.RED;
      END_CASE;
      (* Reset timer for next phase *)
      phaseTimer(IN := FALSE, PT := currentDuration);
      phaseTimer(IN := enable, PT := currentDuration);
    END_IF;

    (* Update output lights based on current state *)
    redLight    := (currentState = TrafficState.RED);
    yellowLight := (currentState = TrafficState.YELLOW);
    greenLight  := (currentState = TrafficState.GREEN);
  END_IF;
END_FUNCTION_BLOCK
