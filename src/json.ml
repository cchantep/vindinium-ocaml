open Core.Std
open Hero

(** Parses [json] of form [{"x":0,"y":1}] as position. *)
let parse_pos (json:Yojson.Basic.json): (int * int, string) Result.t =
  let open Yojson.Basic.Util in
  try (
    let x = json |> member "x" |> to_int in
    let y = json |> member "y" |> to_int in Ok (x, y)
  ) with e -> Error (Exn.to_string e)

(** Parses hero from [json]. *)
let parse_hero (json:Yojson.Basic.json): (hero, string) Result.t =
  let open Yojson.Basic.Util in
  let pos = parse_pos(json |> member "pos") in 
  let pos' = 
    Result.bind 
      pos (fun a -> let p = parse_pos(json |> member "spawnPos") in
                    Result.map p (fun b -> (a, b))) in
  Result.bind 
    pos' 
    (fun (position, spawn_position) ->
     try (
       let id' = HeroId.from_int (json |> member "id" |> to_int) in
       let id'' = match id' with 
         | Some(i) -> Ok(i) 
         | _ -> 
            let msg = sprintf "Fails to parse hero ID: %s\n" 
                              (json |> member "id" |> to_string) in
            Error msg in
       let name = json |> member "name" |> to_string in
       let user_id = json |> member "userId" |> to_string in
       let elo = json |> member "elo" |> to_int in
       let life = json |> member "life" |> to_int in
       let gold = json |> member "gold" |> to_int in
       let mines = json |> member "mineCount" |> to_int in
       let crashed = json |> member "crashed" |> to_bool in

       Result.map 
         id'' (fun id -> { id; name; user_id; position; spawn_position; 
                           life; gold; mines; elo; crashed })

     ) with e -> Error (Exn.to_string e))

(* TODO: Use from_channel if Cohttp body deferred as in_channel *)
let parse_state (buf:string) : (unit, string) Result.t = 
  let open Yojson.Basic.Util in
  let json = Yojson.Basic.from_string buf in 
  let game' = json |> member "game" |> to_assoc in 
  let hero' = parse_hero(json |> member "hero") in
  let tok = json |> member "token" |> to_string in
  let view_url = json |> member "viewUrl" |> to_string in
  let play_url = json |> member "playUrl" |> to_string in
  let _ = printf "tok = %s, view = %s, play = %s\n" tok view_url play_url in
  Ok ()
                                                    
                                                    
(*



{"game":{"id":"e7wpmqp1","turn":0,"maxTurns":40,"heroes":[{"id":1,"name":"sjdksdfdksjfh","userId":"po33ddb8","elo":1200,"pos":{"x":1,"y":2},"life":100,"gold":0,"mineCount":0,"spawnPos":{"x":1,"y":2},"crashed":false},{"id":2,"name":"random","pos":{"x":8,"y":2},"life":100,"gold":0,"mineCount":0,"spawnPos":{"x":8,"y":2},"crashed":false},{"id":3,"name":"random","pos":{"x":8,"y":7},"life":100,"gold":0,"mineCount":0,"spawnPos":{"x":8,"y":7},"crashed":false},{"id":4,"name":"random","pos":{"x":1,"y":7},"life":100,"gold":0,"mineCount":0,"spawnPos":{"x":1,"y":7},"crashed":false}],"board":{"size":10,"tiles":"######################  @1########@4  ######            ####      ##    ##      $-##[]##    ##[]##$-$-##[]##    ##[]##$-      ##    ##      ####            ######  @2########@3  ######################"},"finished":false}}  
 *)                                               
