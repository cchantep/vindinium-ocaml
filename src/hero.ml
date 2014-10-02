open Core.Std

type hero_id   = 
  FirstHero | SecondHero  | ThirdHero   | FourthHero |
  FifthHero | SixthHero   | SeventhHero | EighthHero | 
  NinthHero

type hero_pos  = int * int
type hero_life = int
type hero_gold = int
type hero_elo  = int

(** Hero ID companion *)
module HeroId = struct
    (* Make ID from integer code *)
    let from_int (i:int) = match i with 
      | 1 -> Some FirstHero   | 2 -> Some SecondHero 
      | 3 -> Some ThirdHero   | 4 -> Some FourthHero
      | 5 -> Some FifthHero   | 6 -> Some SixthHero
      | 7 -> Some SeventhHero | 8 -> Some EighthHero 
      | 9 -> Some NinthHero   | _ -> None

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
    position       : hero_pos;
    spawn_position : hero_pos;
    life           : hero_life;
    gold           : hero_gold;
    elo            : hero_elo;
    crashed        : bool;
  }

(** Type companion *)
module Hero = struct
    (* Make a hero instance *)
    let make ~id ~name ~(pos:int*int) ~(spawn:int*int) 
             ?(life = 1) ?(gold = 0) ?(elo = 0) ?(crashed = false) () : hero = 
      let (px, py) = pos in 
      let (sx, sy) = spawn in 
      { id; name; position = (px,py); spawn_position = (sx,sy); 
        life; gold; elo; crashed }

    (* Returns string representation. *)
    let to_string (h : hero) : string = match h with 
      | { id; name = n; position = (px, py); spawn_position = (sx, sy); 
          life = l; gold = g; elo = e; crashed = c } -> 
         sprintf "Hero(id = %i, name = %s, position = %i@%i, spawn = %i@%i %i %i %i %B)" (HeroId.to_int id) n px py sx sy l g e c
  end
