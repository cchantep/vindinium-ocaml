open Core.Std
open Hero
open Game

type api_token = string
type url = string

(** Game state *)
type state = {
    game     : game;
    hero_id  : hero_id; (* ID of hero played by current client *)
    token    : api_token; (* Client token *)
    view_url : url; (* URL of view *)
    play_url : url; (* Play URL *)
  }

(** State companion *)
module State = struct
    (** Returns hero of given game state. *)
    let hero (st:state) : hero option = 
      List.nth st.game.heroes (HeroId.to_int st.hero_id)
  end
