open Core.Std
open OUnit2
open Hero
open Board

module Board_test = struct
    let make ctx = 
      let airboard2 = Board.make 2 in
      let outside = Board.get airboard2 ~col:3 ~row:0 in
      let _ = assert_equal ~msg:"No tile should be found outside board"
                           outside None in 
      List.iter airboard2.tiles  
                (fun col -> 
                 List.iter col 
                           (fun tile ->
                            assert_equal ~msg:"Board should be filled with air"
                                         tile AirTile))
                                          
    let set_hero1 ctx =
      let board1 = Board.make 2 in
      let tile = HeroTile(FirstHero) in
      (match Board.set board1 ~col:1 ~row:0 tile with
       | Some(board2) ->
          (match Board.get board2 ~col:1 ~row:0 with
           | Some(t) -> 
              assert_equal ~msg:"Tile on board should be hero #1" t tile
           | _ -> assert_failure "Fails to find set tile on updated board"
          )
       | _ -> assert_failure "Should have created new board"
      )

    let is_on_board ctx = 
      let board = Board.make 3 in
      let on1 = Board.is_on board ~col:1 ~row:2 in
      let on2 = (1, 2) ^ board in
      let on = (on1 && on2) in
      let _  = 
        assert_equal ~msg:"Tile (1, 2) should be on board 3x3" on true in
      let off1 = Board.is_on board ~col:2 ~row:3 in 
      let _ = 
        assert_equal ~msg:"Tile (2, 3) should not be on board 3x3" off1 false in
      let off2 = Board.is_on board ~col:3 ~row:0 in 
        assert_equal ~msg:"Tile (3, 0) should not be on board 3x3" off2 false

    let set_off_tavern ctx = 
      let board = Board.make 4 in
      let updated = Board.set board ~col:5 ~row:6 TavernTile in
      assert_equal ~msg:"Should not have updated board" updated None

    let infix_get ctx =
      let ini = Board.make 5 in 
      match (Board.set ini ~col:1 ~row:3 FreeMineTile) with
      | Some(board) -> 
         (let tile1 = board @ (1, 3) in
          let tile2 = board @ (9, 0) in
          match (tile1, tile2) with 
          | (Some(tile), None) ->
             assert_equal ~msg:"Should have found free mine at (1, 3)"
                          tile FreeMineTile
          | _ -> assert_failure "Should have found tile at (1,3) but not (9,0)"
         )
      | _ -> assert_failure "Should have set free mine at (1, 3)"


    let suite = [
        "Make new board (filled with air)" >:: make;
        "Set hero #1 tile" >:: set_hero1;
        "Check tile is on board" >:: is_on_board;
        "Set tavern off the board" >:: set_off_tavern;
        "Infix get operator" >:: infix_get;
      ]
  end

