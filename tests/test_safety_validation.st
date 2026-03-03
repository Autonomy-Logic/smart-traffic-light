(* Safety validation tests — ensure timing parameters meet minimum requirements *)

TEST 'Default yellow duration meets minimum safety threshold'
  VAR timing : PhaseTiming; END_VAR

  (* Federal Highway Administration recommends minimum 3s yellow for
     intersections with speed limits up to 25 mph. This test enforces
     that the default yellow duration is at least 3 seconds. *)
  ASSERT_TRUE(timing.yellowDuration >= T#3s,
    'Yellow duration must be at least 3s for safety');
END_TEST

TEST 'Default green duration is reasonable'
  VAR timing : PhaseTiming; END_VAR

  ASSERT_TRUE(timing.greenDuration >= T#10s,
    'Green duration should be at least 10s');
  ASSERT_TRUE(timing.greenDuration <= T#120s,
    'Green duration should not exceed 120s');
END_TEST

TEST 'Default red duration is reasonable'
  VAR timing : PhaseTiming; END_VAR

  ASSERT_TRUE(timing.redDuration >= T#10s,
    'Red duration should be at least 10s');
END_TEST

TEST 'Total cycle time is within bounds'
  VAR timing : PhaseTiming; END_VAR

  ASSERT_TRUE(
    timing.greenDuration + timing.yellowDuration + timing.redDuration >= T#30s,
    'Total cycle should be at least 30s');
  ASSERT_TRUE(
    timing.greenDuration + timing.yellowDuration + timing.redDuration <= T#300s,
    'Total cycle should not exceed 300s');
END_TEST
