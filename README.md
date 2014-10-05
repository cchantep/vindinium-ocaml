# Vinidium OCaml

OCaml starter pack for [Vinidium](http://vindinium.org/) challenge (inspired from the [Java starter pack](https://bitbucket.org/cchantep/vindinium-starter-java)).

## Build

*Prerequisites:*

- Build tool OASIS (`opam install oasis`).
- Compiler *ocamlbuild* (tested with 4.02.x).
- Modules *core*, *async_ssl*, *cohttp.async*, *yojson* and *ounit* (for testing).

```
cp _tags.dist _tags
oasis setup
./configure --enable-tests
make
```

## Usage

Once built, executable `main.native` is available to start the client.

```
# ./main.native
Start Vindinium client

  main.native 

=== flags ===

  -key           Private key
  -mode          Game mode ('arena' or 'training')
  [-limit]       Number of turn to play (only for training, default: 10)
  [-server]      Base URL to server (default: http://vindinium.org/)
  [-build-info]  print info about this build and exit
  [-version]     print the version of this build and exit
  [-help]        print this help text and exit
                 (alias: -?)

# ./main.native -key your_key -mode training
```

## API

- See [test cases](https://github.com/cchantep/vindinium-ocaml/tree/master/test)

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

Constants instances defined in `Board` module are `AirTile`, `FreeMineTile`, `TavernTile` and `WoodTile`.

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
