open Core.Std

open Board
open Bot
open Game
open Hero
open State

(** Bot with a dumb/random strategy to find next direction. *)
module Random_bot : Bot = struct
    (* 'Free' tiles *)
    let free_tiles = [ AirTile; FreeMineTile; TavernTile ]

    let next_move (st: state) : (direction, string) Result.t = 
      let _ = st.game.board @ (0, 0) in
      match Option.map ~f:(fun h -> h.position) (State.hero st) with
      | Some(pos) -> 
         (if (pos ^ st.game.board) then Ok Stay
          else Error "Hero is off the board"
         )
      | _ -> Error "Fails to locate played hero"
  end
