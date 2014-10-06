open Core.Std
open Hero

(** Board tiles *)
type tile =
  AirTile | FreeMineTile | TavernTile | WoodTile 
  | HeroTile of hero_id
  | MineTile of hero_id

(** Tile companion *)
module Tile = struct
    (** Creates tile instance from given character list. *)
    let from_chars (cs: char list) : (tile, string) Result.t =
      let open Result.Monad_infix in
      match cs with
      | ' ' :: ' ' :: [] -> Ok AirTile
      | '$' :: '-' :: [] -> Ok FreeMineTile
      | '[' :: ']' :: [] -> Ok TavernTile
      | '#' :: '#' :: [] -> Ok WoodTile
      | '@' :: h   :: [] -> HeroId.from_char h >>| fun id -> HeroTile(id)
      | '$' :: h   :: [] -> HeroId.from_char h >>| fun id -> MineTile(id)
      | _ -> Error "Invalid tile string"

    (** Creates tile instance corresponding to string. *)
    let make (s:string) : (tile, string) Result.t = 
      Result.map_error 
        (from_chars (String.to_list s))
        ~f:(fun _ -> sprintf "Invalid tile string: %s" s)

    (** Returns string representation of given tile. *)
    let to_string (t:tile) : string = match t with
      | AirTile    -> "  " | FreeMineTile -> "$-" 
      | TavernTile -> "[]" | WoodTile     -> "##"
      | HeroTile(h) -> sprintf "@%i" (HeroId.to_int h)
      | MineTile(h) -> sprintf "$%i" (HeroId.to_int h)
  end

(** Board itself *)
type board = {
    size  : int;
    tiles : tile list(*col*) list(*row*); (* Tiles matrix *)
  }

(** Board companion *)
module Board = struct
    (** Creates a board of 'n' (size) rows of 'n' columns, filled only with air. *)
    let make (size:int) : board = 
      let airCol = Array.to_list (Array.create size AirTile) in
      let tiles = Array.to_list (Array.create size airCol) in
      { size; tiles }

    (** Returns specified tile, if coordinates (first [col] = 0, first [row] = 0) are on the given board. *)
    let get (b:board) ~(col:int) ~(row:int) : tile option = 
      if (row < 0 || row >= b.size || col < 0 || col >= b.size) then None
      else match List.nth b.tiles row with
           | Some(r) -> List.nth r col
           | _ -> None

    (** Checks whether tile specified by column and row is on given board. *)
    let is_on (b:board) ~(col:int) ~(row:int) : bool = 
      if (row >= 0 && row < b.size && col >= 0 && col < b.size) 
      then true else false

    (** Returns new some new board with tile set if coordinates are valid (first [col] = 0, first [row] = 0), or none if not (board considered unchanged). *)
    let set (b:board) ~(col:int) ~(row:int) (t:tile) : board option = 
      if (is_on b ~col:col ~row:row) then
        let (_, rev_tiles) =
          List.fold_left 
            b.tiles ~init:(0, [])
            ~f:(fun (row_idx, tiles_copy) row_tiles ->
                if (phys_equal row_idx row) then
                  let (_, rev_row) = 
                    List.fold_left 
                      row_tiles ~init:(0, [])
                      ~f:(fun (col_idx, row_copy) orig_tile ->
                          if (phys_equal col_idx col)
                          then (col_idx+1, t :: row_copy)
                          else (col_idx+1, orig_tile :: row_copy))
                  in (row_idx+1, (List.rev rev_row) :: tiles_copy)
                else (row_idx+1, row_tiles :: tiles_copy))
        in Some { size = b.size; tiles = (List.rev rev_tiles) }
      else None

  end

(** Convenient infix operator to get specified tile on given board. *)
let (@) (b:board) (coords: int * int) : tile option = 
  let (c, r) = coords in Board.get b ~col:c ~row:r

(** Convenient infox operator to check whether coordinates are on board. *)
let (^) (coords: int * int) (b:board) : bool = 
  let (c, r) = coords in Board.is_on b ~col:c ~row:r
