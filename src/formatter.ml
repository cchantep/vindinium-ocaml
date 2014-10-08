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

let ansi (styles: ANSITerminal.style list) (s:string): string =
  ANSITerminal.sprintf styles "%s" s

type fmt_settings = (hero_id * ANSITerminal.style list) list

(** Return pretty string for tile [t]. *)
let string_of_tile (settings:fmt_settings) (t:tile) : string = 
  let content = Tile.to_string t in
  let open ANSITerminal in
  let rec hero_styles' : fmt_settings -> hero_id -> style list option = 
    (fun set id ->
     match set with 
     | (h, styles) :: rem when (phys_equal h id) -> Some(styles)
     | _ :: rem -> hero_styles' rem id
     | _ -> None) in
  let hero_styles : hero_id -> style list option = hero_styles' settings in
  match t with
  | AirTile -> ansi [on_white] content
  | FreeMineTile -> ansi [Bold; cyan; on_white] content
  | TavernTile -> ansi [magenta; on_white] content
  | WoodTile -> ansi [on_green] content
  | HeroTile(id) ->
     (match hero_styles id with
      | Some(styles) -> ansi (on_white :: styles) content
      | _ -> content)
  | MineTile(id) ->
     (match hero_styles id with
      | Some(styles) -> ansi (on_white :: styles) content
      | _ -> content)

(** Returns pretty string for board [b]. *)
let string_of_board (settings:fmt_settings) (b:board) : string = 
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
  let of_tile = string_of_tile settings in
  let (_, tiles) =
    List.fold_left 
      b.tiles ~init:(1, "") 
      ~f:(fun (i, str) row ->
          let row_str = 
            String.concat ~sep:" " (List.map row ~f:of_tile) in
          (i+1, String.concat 
                  [str; (sprintf " %02i|" i); row_str; "|\r\n"])) in
  String.concat ["    "; (topbar [] 0); "\r\n"; "   +"; 
                 hsep; "+\r\n"; tiles; "   +"; hsep; "+"]
      
(** Returns pretty string for game [g]. *)
let string_of_game (settings:fmt_settings) (g:game) : string = 
  let title = 
    pad_to (sprintf "Game is %s (turn %i / %i)" g.id g.turn g.max_turn) 80 in
  let board = string_of_board settings g.board in
  String.concat [title; "\r\n\r\n"; board]

(** Returns pretty string for state [s]. *)
let string_of_state (s:state) : string = 
  let hero_status = 
    Option.fold 
      (State.hero s) ~init:""
      ~f:(fun _ hero ->
          let hero_num = HeroId.to_int s.hero_id in
          let (x, y) = hero.position in
          pad_to (sprintf "You're hero @%i at position (%i, %i)" 
                          hero_num (x+1) (y+1)) 80) in
  let (settings, view_url, play_url) = 
    let open ANSITerminal in
    let (_, settings) = 
      List.fold_left 
        s.game.heroes ~init:([green; blue; yellow], [])
        ~f:(fun (av, l) h ->
            if (phys_equal h.id s.hero_id) then (av, l)
            else match av with
                 | c :: cs -> (cs, (h.id, [c]) :: l)
                 | _ -> ([blue; yellow], (h.id, [green]) :: l)) in
    let vu = ansi [Underlined; cyan] s.view_url in
    let pu = ansi [Underlined; cyan] s.play_url in
    ((s.hero_id, [Bold; red]) :: settings, vu, pu) in
  let game = string_of_game settings s.game in
  let view = pad_to (sprintf "View URL: %s" view_url) 80 in
  let play = pad_to (sprintf "Play URL: %s" play_url) 80 in
  String.concat [ "\r\n"; game; "\r\n\r\n"; hero_status; "\r\n\r\n"; 
                  view; "\r\n"; play; "\r\n\r\n" ]
