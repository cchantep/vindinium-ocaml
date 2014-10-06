open Core.Std
open OUnit2
open Hero
open Board
open Json

module Json_test = struct
    let parse_raw_tiles1 ctx =
      let open Json_fixtures in
      match (parse_tiles tiles1size tiles1raw) with
      | Ok(parsed) ->
         assert_equal ~msg:"Parsed tiles should be expected one" parsed tiles1
      | Error(msg) -> assert_failure (sprintf "Fails to parse tiles: %s" msg)

    let parse_raw_tiles2 ctx =
      let open Json_fixtures in
      match (parse_tiles tiles2size tiles2raw) with
      | Ok(parsed) ->
         assert_equal ~msg:"Parsed tiles should be expected one" parsed tiles2
      | Error(msg) -> assert_failure (sprintf "Fails to parse tiles: %s" msg)

    let parse_valid_board1 ctx =
        let open Json_fixtures in
        match parse_board (Yojson.Basic.from_string board1json) with
        | Ok(parsed) ->
           (match (parsed @ (2,1)) with
           | Some(tile) -> 
              assert_equal ~msg:"Tile (2,1) should be Hero #1"
                           tile (HeroTile FirstHero)
           | _ -> 
              assert_failure "Should find a tile at (2,1)");
           assert_equal ~msg:"Board should be expected one" parsed board1
        | Error msg -> assert_failure (sprintf "Fails to parse board: %s" msg)

    let parse_valid_board2 ctx =
        let open Json_fixtures in
        match parse_board (Yojson.Basic.from_string board2json) with
        | Ok(parsed) ->
           (match (parsed @ (7,3)) with
           | Some(tile) -> 
              assert_equal ~msg:"Tile (7,3) should be mine of hero #4"
                           tile (MineTile FourthHero)
           | _ -> 
              assert_failure "Should find a tile at (7,3)");
           assert_equal ~msg:"Board should be expected one" parsed board2
        | Error(msg) -> assert_failure (sprintf "Fails to parse board: %s" msg)

    let parse_valid_hero ctx = 
      match parse_hero (Yojson.Basic.from_string "{\"id\":1,\"name\":\"any_name\",\"userId\":\"po33ddb8\",\"elo\":1200,\"pos\":{\"x\":1,\"y\":2},\"life\":100,\"gold\":10,\"mineCount\":1,\"spawnPos\":{\"x\":3,\"y\":2},\"crashed\":false}") 
      with Ok(h) -> 
           (assert_equal ~msg:"Parsed hero should be first one" h.id FirstHero);
           (assert_equal ~msg:"Parsed name should be 'any_name'" 
                         h.name "any_name");
           (assert_equal ~msg:"Parsed user ID should be 'po33ddb8'"
                         h.user_id (Some "po33ddb8"));
           (assert_equal ~msg:"Parsed hero position should be (2, 1)"
                         h.position (2, 1)); 
           (assert_equal ~msg:"Parsed spawn position should be (2, 3)"
                         h.spawn_position (2, 3));
           (assert_equal ~msg:"Parsed life count should be 100" h.life 100);
           (assert_equal ~msg:"Parsed gold count should be 10" h.gold 10);
           (assert_equal ~msg:"Parsed mine count should be 1" h.mines 1);
           (assert_equal ~msg:"Parsed ELO score should be 1200" 
                         h.elo (Some 1200));
           (assert_equal ~msg:"Parsed crashed should be false" h.crashed false)

         | Error(msg) -> 
            assert_failure (sprintf "Fails to parse hero: %s" msg)
    
    let parse_valid_pos ctx = 
      match parse_pos (Yojson.Basic.from_string "{\"x\":1,\"y\":2}") with
      | Ok((x, y)) -> 
         assert_equal ~msg:"Parsed position should be (2, 1)" (x, y) (2, 1)
      | Error(msg) -> 
         assert_failure (sprintf "Fails to parse position: %s" msg)

    let parse_valid_game1 ctx = 
      let open Json_fixtures in
      match parse_game (Yojson.Basic.from_string game1json) with
      | Ok(parsed) ->
         assert_equal ~msg:"Game should be expected one" parsed game1
      | Error(msg) -> assert_failure (sprintf "Fails to parse game: %s" msg)

    let parse_valid_state1 ctx =
      let open Json_fixtures in
      match (parse_state state1json) with
      | Ok(parsed) ->
         assert_equal ~msg:"State should be expected one" parsed state1
      | Error(msg) -> assert_failure (sprintf "Fails to parse state: %s" msg)

    let suite = [
        "Parse valid position"    >:: parse_valid_pos;
        "Parse valid hero"        >:: parse_valid_hero;
        "Parse valid tiles 10x10" >:: parse_raw_tiles1;
        "Parse valid tiles 18x18" >:: parse_raw_tiles2;
        "Parse valid board 10x10" >:: parse_valid_board1;
        "Parse valid board 18x18" >:: parse_valid_board2;
        "Parse valid game 10x10"  >:: parse_valid_game1;
        "Parse valid state 10x10" >:: parse_valid_state1
      ]
  end

