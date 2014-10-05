open Core.Std

type hero_id   = 
  FirstHero | SecondHero  | ThirdHero   | FourthHero |
  FifthHero | SixthHero   | SeventhHero | EighthHero | 
  NinthHero

type hero_pos   = int * int
type hero_life  = int
type hero_gold  = int
type hero_elo   = int
type mine_count = int

(** Hero ID companion *)
module HeroId = struct
    (* Make ID from integer code *)
    let from_int (i:int) : (hero_id, string) Result.t = 
      match i with 
      | 1 -> Ok FirstHero   | 2 -> Ok SecondHero 
      | 3 -> Ok ThirdHero   | 4 -> Ok FourthHero
      | 5 -> Ok FifthHero   | 6 -> Ok SixthHero
      | 7 -> Ok SeventhHero | 8 -> Ok EighthHero 
      | 9 -> Ok NinthHero   | i -> Error (sprintf "Invalid hero ID: %i" i)

    (* Make ID from char representing integer code *)
    let from_char (c:char) = from_int (int_of_char c - int_of_char '0')

    let to_int id = match id with 
      | FirstHero   -> 1 | SecondHero -> 2 | ThirdHero -> 3
      | FourthHero  -> 4 | FifthHero  -> 5 | SixthHero -> 6
      | SeventhHero -> 7 | EighthHero -> 8 | NinthHero -> 9
  end

(** Game hero/player *)
type hero = {
    id             : hero_id;
    name           : string;
    user_id        : string option;
    position       : hero_pos;
    spawn_position : hero_pos;
    life           : hero_life;
    gold           : hero_gold;
    mines          : mine_count;
    elo            : hero_elo option;
    crashed        : bool;
  }

(** Type companion *)
module Hero = struct
    (* Make a hero instance *)
    let make ~id ~name ~user_id ~(pos:int*int) ~(spawn:int*int) ?(life = 1) ?(gold = 0) ?(elo = 0) ?(mines = 0) ?(crashed = false) () : hero = 
      let (px, py) = pos in 
      let (sx, sy) = spawn in 
      { id; name; user_id = Some(user_id); position = (px,py); 
        spawn_position = (sx,sy); life; gold; mines; elo = Some(elo); crashed }

    (* Returns string representation. *)
    let to_string (h : hero) : string = match h with 
      | { id; name; user_id; position = (px, py); spawn_position = (sx, sy); 
          life = l; gold = g; mines; elo; crashed = c } -> 
         sprintf "Hero(id = %i, name = %s, user_id = %s, position = %i@%i, spawn = %i@%i %i %i %i %B)" (HeroId.to_int id) name (Option.value ~default:"" user_id) px py sx sy l g (Option.value ~default:0 elo) c

  end
