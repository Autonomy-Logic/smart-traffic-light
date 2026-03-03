(* Tests for the TurnSignalLight function block *)

TEST 'TurnSignalLight starts with arrow off'
  VAR ts : TurnSignalLight; END_VAR

  ts();
  ASSERT_FALSE(ts.turnArrowOn, 'Arrow should be off initially');
  ASSERT_EQ(ts.turnDirection, 0, 'No direction set');
END_TEST

TEST 'TurnSignalLight SetLeftTurn sets direction'
  VAR ts : TurnSignalLight; END_VAR

  ts.SetLeftTurn();
  ASSERT_EQ(ts.turnDirection, 1, 'Should be left turn');
END_TEST

TEST 'TurnSignalLight SetRightTurn sets direction'
  VAR ts : TurnSignalLight; END_VAR

  ts.SetRightTurn();
  ASSERT_EQ(ts.turnDirection, 2, 'Should be right turn');
END_TEST

TEST 'TurnSignalLight activates on RED to GREEN transition'
  VAR
    ts     : TurnSignalLight;
    timing : PhaseTiming;
  END_VAR

  timing.redDuration := T#100ms;
  timing.greenDuration := T#200ms;
  timing.yellowDuration := T#50ms;
  ts.timing := timing;
  ts.turnDuration := T#80ms;
  ts.SetLeftTurn();

  (* Start in RED *)
  ts();
  ASSERT_EQ(ts.currentState, TrafficState.RED, 'Start in RED');
  ASSERT_FALSE(ts.turnArrowOn, 'Arrow off during RED');

  (* Transition to GREEN *)
  ADVANCE_TIME(T#50ms);
  ts();
  ADVANCE_TIME(T#50ms);
  ts();
  ASSERT_EQ(ts.currentState, TrafficState.GREEN, 'Now GREEN');
  ASSERT_TRUE(ts.turnArrowOn, 'Arrow on during GREEN after RED');
END_TEST

TEST 'TurnSignalLight arrow turns off after duration'
  VAR
    ts     : TurnSignalLight;
    timing : PhaseTiming;
  END_VAR

  timing.redDuration := T#100ms;
  timing.greenDuration := T#300ms;
  timing.yellowDuration := T#50ms;
  ts.timing := timing;
  ts.turnDuration := T#80ms;
  ts.SetLeftTurn();

  (* Get to GREEN *)
  ts();
  ADVANCE_TIME(T#50ms);
  ts();
  ADVANCE_TIME(T#50ms);
  ts();
  ASSERT_TRUE(ts.turnArrowOn, 'Arrow should be on');

  (* Wait for turn duration to expire *)
  ADVANCE_TIME(T#40ms);
  ts();
  ADVANCE_TIME(T#40ms);
  ts();
  ASSERT_FALSE(ts.turnArrowOn, 'Arrow should be off after duration');
END_TEST

TEST 'TurnSignalLight IsTurnActive method'
  VAR ts : TurnSignalLight; END_VAR

  ts();
  ASSERT_FALSE(ts.IsTurnActive(), 'Not active initially');
END_TEST
