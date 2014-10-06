open Core.Std
open Hero
open Board
open Game
open State

let pad_to (s:string) (len:int) : string = 
  let sl = String.length s in
  if (sl >= len) then (String.sub s 0 len)
  else 
    let rem = len - sl in 
    let pad : string = String.make rem ' ' in
    String.concat [s; pad]

(** Return pretty string for tile [t]. *)
let string_of_tile (t:tile) : string = Tile.to_string t

(** Returns pretty string for board [b]. *)
let string_of_board ?(sep:string = "|") (b:board) : string = 
  let rec topbar : string list -> int -> string = 
    (fun cur idx -> 
     if (phys_equal idx b.size) then String.concat ~sep:"|" (List.rev cur)
     else 
       let num = idx + 1 in
       topbar ((sprintf "%02i" num) :: cur) num) in
  let rec hor_sep : string list -> int -> string =
    (fun cur idx ->
     if (phys_equal idx b.size) then String.concat ~sep:"-" cur
     else hor_sep ("--" :: cur) (idx+1)) in
  let hsep = (hor_sep [] 0) in
  let (_, tiles) =
    List.fold_left 
      b.tiles ~init:(1, "") 
      ~f:(fun (i, str) row ->
          let row_str = 
            String.concat ~sep:sep (List.map row ~f:string_of_tile) in
          (i+1, String.concat [str; (sprintf " %02i|" i); row_str; "|\r\n"])) in
  String.concat ["    "; (topbar [] 0); "\r\n"; "   +"; 
                 hsep; "+\r\n"; tiles; "   +"; hsep; "+"]
      
(** Returns pretty string for game [g]. *)
let string_of_game (g:game) : string = 
  let title = 
    pad_to (sprintf "Game is %s (turn %i / %i)" g.id g.turn g.max_turn) 80 in
  let board = string_of_board g.board in
  String.concat [title; "\r\n\r\n"; board]

(** Returns pretty string for state [s]. *)
let string_of_state (s:state) : string = 
  let game = string_of_game s.game in
  let hero_status = 
    Option.fold 
      (State.hero s) ~init:""
      ~f:(fun _ hero ->
          let hero_num = HeroId.to_int s.hero_id in
          let (x, y) = hero.position in
          pad_to (sprintf "You're hero @%i at position (%i, %i)" 
                          hero_num (x+1) (y+1)) 80) in
  let view = pad_to (sprintf "View URL: %s" s.view_url) 80 in
  let play = pad_to (sprintf "Play URL: %s" s.play_url) 80 in
  String.concat [ "\r\n"; game; "\r\n\r\n"; hero_status; "\r\n\r\n"; 
                  view; "\r\n"; play; "\r\n\r\n" ]
