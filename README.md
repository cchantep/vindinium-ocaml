# Vinidium OCaml

OCaml starter pack for [Vinidium](http://vindinium.org/) challenge (inspired from the [Java starter pack](https://bitbucket.org/cchantep/vindinium-starter-java)).

## Build

*Prerequisites:*

- Frontend `ocamlfind`
- Compiler `ocamlopt` (tested with 4.02.x)
- Modules `core`, `yojson` and `ounit` (for testing)

A minimal build script is provided with `make.sh`:

```
vindinium-ocaml# ./make.sh
vindinium-ocaml# ./target/vinidium

vindinium-ocaml# ./make.sh test

vindinium-ocaml# ./make.sh clean
```

## Usage

**Hero:**

Hero is a game player, identified by numerical ID from 1 to 9 that can be prepared as following.

```ocaml
open Hero

let hero1_id : hero_id = FirstHero in
let hero2_id : hero_id option = HeroId.from_int 2 in
let hero3_id : hero_id option = HeroId.from_char "3"
```

Then hero itself is represented by a record, provided with a factory function.

```ocaml
let h : hero = 
  Hero.make ~id:FirstHero ~name:"First one" ~pos:(0, 0) ~spawn:(1, 0)
```

**Tile:**

A tile is the place used by some game element (hero, tavern, ...) on the board at some coordinate (column, row).

Constants instances defined in `Board` module are `AirTile`, `FreeMineTile`, `TavernTile` and `WallTile`.

Tiles for heroes mines and heroes themselves can be created using constructors `HeroTile(hero_id)` and `MineTile(hero_id)`.

```ocaml
open Hero
open Board

let hero1_tile = HeroTile(FirstHero)
```

**Board:**

Board is a matrice of tiles, with number of column being same as number of row, aka `size` property of the `board` type.

```ocaml
open Board

(* Create initial board of size 4 with only air. *)
let init_board board = Board.make 4 in
let init_tile = Board.get init_board ~col:0 ~row:0 in (* tile 0,0: now air *)
let updated_board: board option = Board.set board ~col:0 ~row:0 TavernTile
```

> `Board.get` can also be called with a convenient infix operator `@`: `let t : tile option = a_board @ (0, 0)`.
> In a similar way, `in_on` function can be invoked using `^` operator: `let on : bool = (0, 1) ^ a_board`.

It's possible to check whether coordinate (column, row) corresponds to a tile on a given board.

```ocaml
open Board

let on : bool = Board.is_on board ~col:0 ~row:1
```