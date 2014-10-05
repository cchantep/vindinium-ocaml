open Core.Std
open OUnit2
open Json
open Hero

module Json_test = struct
    let parse_valid_hero ctx = 
      match parse_hero (Yojson.Basic.from_string "{\"id\":1,\"name\":\"any_name\",\"userId\":\"po33ddb8\",\"elo\":1200,\"pos\":{\"x\":1,\"y\":2},\"life\":100,\"gold\":10,\"mineCount\":1,\"spawnPos\":{\"x\":3,\"y\":2},\"crashed\":false}") 
      with Ok(h) -> 
           (assert_equal ~msg:"Parsed hero should be first one" h.id FirstHero);
           (assert_equal ~msg:"Parsed name should be 'any_name'" 
                         h.name "any_name");
           (assert_equal ~msg:"Parsed user ID should be 'po33ddb8'"
                         h.user_id "po33ddb8");
           (assert_equal ~msg:"Parsed hero position should be (1, 2)"
                         h.position (1, 2)); 
           (assert_equal ~msg:"Parsed spawn position should be (3, 2)"
                         h.spawn_position (3, 2));
           (assert_equal ~msg:"Parsed life count should be 100" h.life 100);
           (assert_equal ~msg:"Parsed gold count should be 10" h.gold 10);
           (assert_equal ~msg:"Parsed mine count should be 1" h.mines 1);
           (assert_equal ~msg:"Parsed ELO score should be 1200" h.elo 1200);
           (assert_equal ~msg:"Parsed crashed should be false" h.crashed false)

         | Error(msg) -> 
            assert_failure (sprintf "Fails to parse hero: %s" msg)
    
    let parse_valid_pos ctx = 
      match parse_pos (Yojson.Basic.from_string "{\"x\":1,\"y\":2}") with
      | Ok((x, y)) -> 
         assert_equal ~msg:"Parsed position should be (1, 2)" (x, y) (1, 2)
      | Error(msg) -> 
         assert_failure (sprintf "Fails to parse position: %s" msg)

    let suite = [
        "Parse valid position" >:: parse_valid_pos;
        "Parse valid hero"     >:: parse_valid_hero
      ]
  end

