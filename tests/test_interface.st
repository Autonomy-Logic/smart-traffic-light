(* Tests for IControllable interface implementation *)

TEST 'TrafficLight implements Enable method'
  VAR light : TrafficLight; END_VAR

  light.active := FALSE;
  light();
  ASSERT_FALSE(light.IsEnabled(), 'Should be disabled');

  light.Enable();
  ASSERT_TRUE(light.IsEnabled(), 'Should be enabled after Enable()');
END_TEST

TEST 'TrafficLight implements Disable method'
  VAR light : TrafficLight; END_VAR

  light();
  ASSERT_TRUE(light.IsEnabled(), 'Enabled by default');

  light.Disable();
  ASSERT_FALSE(light.IsEnabled(), 'Disabled after Disable()');
END_TEST

TEST 'TrafficLight GetStatus returns correct codes'
  VAR
    light  : TrafficLight;
    timing : PhaseTiming;
  END_VAR

  timing.redDuration := T#100ms;
  timing.greenDuration := T#100ms;
  timing.yellowDuration := T#50ms;
  light.timing := timing;

  (* Disabled state *)
  light.active := FALSE;
  light();
  ASSERT_EQ(light.GetStatus(), 0, 'Disabled = 0');

  (* RED state *)
  light.active := TRUE;
  light();
  ASSERT_EQ(light.GetStatus(), 1, 'RED = 1');

  (* Night mode *)
  light.nightMode := TRUE;
  light();
  ASSERT_EQ(light.GetStatus(), 4, 'Night mode = 4');
END_TEST
