open Core.Std
open OUnit2
open Hero
open Board

module Tile_test = struct
    let air_to_str ctx = 
      assert_equal ~msg:"Air representation should be \"  \"" 
                   (Tile.to_string AirTile) "  "

    let freemine_to_str ctx = 
      assert_equal ~msg:"Free mine representation should be \"$-\"" 
                   (Tile.to_string FreeMineTile) "$-"

    let tavern_to_str ctx = 
      assert_equal ~msg:"Tavern representation should be \"[]\"" 
                   (Tile.to_string TavernTile) "[]"

    let wood_to_str ctx = 
      assert_equal ~msg:"Wood representation should be \"##\"" 
                   (Tile.to_string WoodTile) "##"
                   
    let hero_to_str ctx = 
      for i = 1 to 9 do 
        let hid = HeroId.from_int i in 
        match hid with 
        | Some(id) -> 
           let tile = HeroTile(id) in
           assert_equal 
             ~msg:(sprintf 
                     "Hero #%i representation should be \"@%i\"" i i) 
             (Tile.to_string tile) (sprintf "@%i" i)
        | _ -> assert_failure "Fails to prepare hero tile"
      done

    let str_to_air ctx = match (Tile.make "  ") with 
      | Some(tile) -> 
         assert_equal ~msg:"Air should be parsed from \"  \"" tile AirTile
      | _ -> assert_failure "Fails to parse air tile"

    let str_to_freemine ctx = match (Tile.make "$-") with 
      | Some(tile) -> 
         assert_equal ~msg:"Free mine should be parsed from \"$-\"" 
                      tile FreeMineTile
      | _ -> assert_failure "Fails to parse free mine tile"

    let str_to_tavern ctx = match (Tile.make "[]") with 
      | Some(tile) -> 
         assert_equal ~msg:"Tavern should be parsed from \"[]\"" tile TavernTile
      | _ -> assert_failure "Fails to parse tavern tile"

    let str_to_wood ctx = match (Tile.make "##") with 
      | Some(tile) -> 
         assert_equal ~msg:"Wood should be parsed from \"  \"" tile WoodTile
      | _ -> assert_failure "Fails to parse wood tile"

    let unsupported_str ctx = 
      assert_equal ~msg:"Should fail to parse unsupported string" 
                   (Tile.make "#-") None

    let hero_expectations fixtures =
      List.fold_left 
        fixtures ~init:([], [])
        ~f:(fun ls d -> 
            let (parsed, expected) = ls in 
            let (str, exp) = d in
            match (Tile.make str) with 
            | Some(tile) -> (tile :: parsed, exp :: expected) | _ -> ls)

    let str_to_hero ctx = 
      let open Tile_fixtures in
      let (parsed, expected) = hero_expectations Tile_fixtures.hero_tiles in
      assert_equal ~msg:"Heroes should be parsed as expected" parsed expected

    let str_to_mine ctx = 
      let open Tile_fixtures in
      let (parsed, expected) = hero_expectations Tile_fixtures.mine_tiles in
      assert_equal ~msg:"Mines should be parsed as expected" parsed expected

    let suite = [
        "Air string representation" >:: air_to_str;
        "Free mine string representation" >:: freemine_to_str;
        "Tavern string representation" >:: tavern_to_str;
        "Wood string representation" >:: wood_to_str;
        "Hero string representation" >:: hero_to_str;
        "Air parsing" >:: str_to_air;
        "Freemine parsing" >:: str_to_freemine;
        "Tavern parsing" >:: str_to_tavern;
        "Wood parsing" >:: str_to_wood;
        "Parsing unsupported" >:: unsupported_str;
        "Hero parsing" >:: str_to_hero;
        "Mine parsing" >:: str_to_mine
      ]                     
  end
