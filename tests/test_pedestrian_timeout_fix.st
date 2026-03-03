(* Tests for pedestrian timeout fix — verifies timer reset on state change *)

TEST 'Walk timer resets when traffic leaves RED'
  VAR
    ped : PedestrianLight;
    timing : PhaseTiming;
  END_VAR

  timing.redDuration := T#500ms;
  timing.greenDuration := T#100ms;
  timing.yellowDuration := T#50ms;
  ped.timing := timing;
  ped.walkDuration := T#200ms;

  (* Start walking during RED *)
  ped.walkRequest := TRUE;
  ped();
  ASSERT_EQ(ped.pedestrianState, PedestrianState.WALK, 'Walking during RED');

  (* Advance partially through walk duration *)
  ADVANCE_TIME(T#50ms);
  ped();

  (* Force traffic to GREEN by advancing past red duration *)
  ADVANCE_TIME(T#450ms);
  ped();
  ASSERT_EQ(ped.currentState, TrafficState.GREEN, 'Traffic now GREEN');
  ASSERT_EQ(ped.pedestrianState, PedestrianState.DONT_WALK, 'Walk cancelled');

  (* Go through GREEN + YELLOW back to RED *)
  ADVANCE_TIME(T#50ms);
  ped();
  ADVANCE_TIME(T#50ms);
  ped();
  ADVANCE_TIME(T#25ms);
  ped();
  ADVANCE_TIME(T#25ms);
  ped();

  (* Should be back in RED now *)
  ASSERT_EQ(ped.currentState, TrafficState.RED, 'Back to RED');

  (* Request walk again during new RED phase *)
  ped.walkRequest := TRUE;
  ped();
  ASSERT_EQ(ped.pedestrianState, PedestrianState.WALK, 'Can walk again');

  (* Walk timer should start fresh, not carry over old elapsed time.
     Only 100ms elapsed out of 200ms duration — should still be walking. *)
  ADVANCE_TIME(T#100ms);
  ped();
  ASSERT_EQ(ped.pedestrianState, PedestrianState.WALK,
    'Still walking — timer was properly reset');
END_TEST

TEST 'Flash timer resets when traffic leaves RED'
  VAR
    ped : PedestrianLight;
    timing : PhaseTiming;
  END_VAR

  timing.redDuration := T#500ms;
  timing.greenDuration := T#100ms;
  timing.yellowDuration := T#50ms;
  ped.timing := timing;
  ped.walkDuration := T#50ms;

  (* Walk and transition to flashing *)
  ped.walkRequest := TRUE;
  ped();
  ADVANCE_TIME(T#25ms);
  ped();
  ADVANCE_TIME(T#25ms);
  ped();
  ASSERT_EQ(ped.pedestrianState, PedestrianState.FLASHING, 'Should be flashing');

  (* Simulate early exit — flash count and timer should reset cleanly *)
  ped.walkRequest := FALSE;
  ped();

  (* Re-request walk *)
  ped.walkRequest := TRUE;
  ped();
  ASSERT_EQ(ped.pedestrianState, PedestrianState.WALK, 'Fresh walk cycle');
END_TEST
