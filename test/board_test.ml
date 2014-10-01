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

    let suite = [
        "Make new board (filled with air)" >:: make;
        "Set hero #1 tile" >:: set_hero1
      ]
  end

