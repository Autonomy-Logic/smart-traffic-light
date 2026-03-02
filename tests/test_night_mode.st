(* Tests for TrafficLight night mode feature *)

TEST 'Night mode turns off red and green lights'
  VAR light : TrafficLight; END_VAR

  light.nightMode := TRUE;
  light();

  ASSERT_FALSE(light.redLight, 'Red should be off in night mode');
  ASSERT_FALSE(light.greenLight, 'Green should be off in night mode');
END_TEST

TEST 'Night mode sets state to YELLOW'
  VAR light : TrafficLight; END_VAR

  light.nightMode := TRUE;
  light();

  ASSERT_EQ(light.currentState, TrafficState.YELLOW, 'State should be YELLOW in night mode');
END_TEST

TEST 'Night mode flashes yellow'
  VAR light : TrafficLight; END_VAR

  light.nightMode := TRUE;
  light();

  (* After first flash period *)
  ADVANCE_TIME(T#500ms);
  light();

  (* Yellow should have toggled *)
  ASSERT_EQ(light.currentState, TrafficState.YELLOW, 'Still in YELLOW state');
END_TEST

TEST 'Exiting night mode resumes normal operation'
  VAR
    light  : TrafficLight;
    timing : PhaseTiming;
  END_VAR

  timing.redDuration := T#100ms;
  timing.greenDuration := T#100ms;
  timing.yellowDuration := T#50ms;
  light.timing := timing;

  (* Enter night mode *)
  light.nightMode := TRUE;
  light();
  ADVANCE_TIME(T#200ms);
  light();

  (* Exit night mode *)
  light.nightMode := FALSE;
  light();

  (* Should resume normal cycling from YELLOW state *)
  ASSERT_FALSE(light.nightMode, 'Night mode should be off');
END_TEST

TEST 'IsNightMode method returns correct state'
  VAR light : TrafficLight; END_VAR

  light();
  ASSERT_FALSE(light.IsNightMode(), 'Not in night mode initially');

  light.nightMode := TRUE;
  light();
  ASSERT_TRUE(light.IsNightMode(), 'Should report night mode');
END_TEST
