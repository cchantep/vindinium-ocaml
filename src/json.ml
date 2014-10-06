open Core.Std
open Hero
open Board
open Game
open State
open Result.Monad_infix

(** Parses [json] of form [{"x":0,"y":1}] as position. *)
let parse_pos (json:Yojson.Basic.json): (int * int, string) Result.t =
  let open Yojson.Basic.Util in
  try (
    let x = json |> member "x" |> to_int in
    let y = json |> member "y" |> to_int in Ok (y, x) (* ? *)
  ) with e -> Error (Exn.to_string e)

(** Parses hero from [json]. *)
let parse_hero (json:Yojson.Basic.json): (hero, string) Result.t =
  let open Yojson.Basic.Util in
  let id' = 
    try Ok (json |> member "id" |> to_int)
    with e -> Error (Exn.to_string e) in
  let id'' = Result.bind id' HeroId.from_int in
  parse_pos(json |> member "pos")
  >>= (fun a -> let p = parse_pos(json |> member "spawnPos") in
                Result.map p (fun b -> (a, b)))
  >>= (fun (position, spawn_position) ->
       try (
         let name = json |> member "name" |> to_string in
         let user_id = json |> member "userId" |> to_string_option in
         let elo = json |> member "elo" |> to_int_option in
         let life = json |> member "life" |> to_int in
         let gold = json |> member "gold" |> to_int in
         let mines = json |> member "mineCount" |> to_int in
         let crashed = json |> member "crashed" |> to_bool in
         Result.map 
           id'' (fun id -> { id; name; user_id; position; spawn_position; 
                             life; gold; mines; elo; crashed })
       ) with e -> Error (Exn.to_string e))

(** Parses tiles from [raw] string representation, according board [size]. *)
let parse_tiles (size:int) (raw:string): (tile list list, string) Result.t =
  let rec parse : char list -> int -> tile list -> tile list list -> (tile list list, string) Result.t = 
    (fun chars idx row tiles ->
     match chars with 
     | [] -> Ok(List.rev (row :: tiles))
     | ch :: [] -> Error (sprintf "Orphan character: %c" ch)
     | a :: b :: rem -> 
        match (Tile.from_chars [a; b]) with 
        | Error(msg) -> Error(msg)
        | Ok(tile) -> 
           if (idx > 0 && (phys_equal (idx mod size) 0)) then (* new col *)
             parse rem (idx+1) [tile] ((List.rev row) :: tiles)
           else parse rem (idx+1) (tile :: row) tiles (* new row *)
    ) in parse (String.to_list raw) 0 [] []

(** Parses board from [json]. *)
let parse_board (json:Yojson.Basic.json): (board, string) Result.t =
  let open Yojson.Basic.Util in
  (try Ok (json |> member "size" |> to_int)
   with e -> Error(Exn.to_string e))
  >>= (fun size -> 
       (try Ok (json |> member "tiles" |> to_string)
       with e -> Error(Exn.to_string e)) 
       >>= (parse_tiles size) >>| (fun tiles -> { size; tiles }))

(** Parses game from [json]. *)
let parse_game (json:Yojson.Basic.json): (game, string) Result.t =
  let open Yojson.Basic.Util in
  (try Ok (json |> member "heroes" |> to_list)
   with e -> Error(Exn.to_string e))
  >>= (fun js -> Result.all (List.map js ~f:parse_hero))
  >>= (fun heroes ->
       (try Ok (json |> member "board")
        with e -> Error(Exn.to_string e)) >>= parse_board 
       >>= (fun board ->
            try (
              let id = json |> member "id" |> to_string in
              let turn = json |> member "turn" |> to_int in
              let max_turn = json |> member "maxTurns" |> to_int in
              let finished = json |> member "finished" |> to_bool in
              Ok { id; turn; max_turn; finished; heroes; board }
            ) with e -> Error(Exn.to_string e)))

(* TODO: Use from_channel if Cohttp body deferred as in_channel *)
(** Parses state from JSON [buffer]. *)
let parse_state (buffer:string) : (state, string) Result.t = 
  let open Yojson.Basic.Util in
  let json = Yojson.Basic.from_string buffer in 
  (parse_game (json |> member "game")) >>=
    (fun game ->
     (parse_hero (json |> member "hero")) >>=
       (fun hero ->
        try (
          let token = json |> member "token" |> to_string in
          let view_url = json |> member "viewUrl" |> to_string in
          let play_url = json |> member "playUrl" |> to_string in
          Ok { game; hero_id = hero.id; token; view_url; play_url }
        ) with e -> Error(Exn.to_string e)))
