open OUnit2

let suite = 
  let open Hero_test in 
  let open Tile_test in 
  let open Board_test in
  let open Json_test in
  "Vindinium" >::: 
    (List.append 
       (List.append 
          (List.append Hero_test.suite Tile_test.suite) 
          Board_test.suite) Json_test.suite)
                 
let () = run_test_tt_main suite
