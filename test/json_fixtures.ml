open Core.Std
open Hero
open Board
open Game
open State

let (tiles1size, tiles1raw) = 
  (10, "######################  @1########@4  ######            ####      ##    ##      $-##[]##    ##[]##$-$-##[]##    ##[]##$-      ##    ##      ####            ######  @2########@3  ######################")

let tiles1 = [
    [WoodTile; WoodTile; WoodTile; WoodTile; WoodTile; WoodTile; WoodTile; WoodTile; WoodTile; WoodTile];
    [WoodTile; AirTile; HeroTile(FirstHero); WoodTile; WoodTile; WoodTile; WoodTile; HeroTile(FourthHero); AirTile; WoodTile];
    [WoodTile; WoodTile; AirTile; AirTile; AirTile; AirTile; AirTile; AirTile; WoodTile; WoodTile];
    [AirTile; AirTile; AirTile; WoodTile; AirTile; AirTile; WoodTile; AirTile; AirTile; AirTile];
    [FreeMineTile; WoodTile; TavernTile; WoodTile; AirTile; AirTile; WoodTile; TavernTile; WoodTile; FreeMineTile];
    [FreeMineTile; WoodTile; TavernTile; WoodTile; AirTile; AirTile; WoodTile; TavernTile; WoodTile; FreeMineTile];
    [AirTile; AirTile; AirTile; WoodTile; AirTile; AirTile; WoodTile; AirTile; AirTile; AirTile];
    [WoodTile; WoodTile; AirTile; AirTile; AirTile; AirTile; AirTile; AirTile; WoodTile; WoodTile];
    [WoodTile; AirTile; HeroTile(SecondHero); WoodTile; WoodTile; WoodTile; WoodTile; HeroTile(ThirdHero); AirTile; WoodTile];
    [WoodTile; WoodTile; WoodTile; WoodTile; WoodTile; WoodTile; WoodTile; WoodTile; WoodTile; WoodTile]
  ]

let board1json = "{\"size\":10,\"tiles\":\"######################  @1########@4  ######            ####      ##    ##      $-##[]##    ##[]##$-$-##[]##    ##[]##$-      ##    ##      ####            ######  @2########@3  ######################\"}"

let board1 = { size = 10; tiles = tiles1 }

let (tiles2size, tiles2raw) = 
  (18, "##############        ############################        ##############################    ##############################$4    $4############################  @4    ########################  @1##    ##    ####################  []        []  ##################        ####        ####################  $4####$4  ########################  $4####$4  ####################        ####        ##################  []        []  ####################  @2##    ##@3  ########################        ############################$-    $-##############################    ##############################        ############################        ##############")

let tiles2 = [
    [WoodTile; WoodTile; WoodTile; WoodTile; WoodTile; WoodTile; WoodTile; AirTile; AirTile; AirTile; AirTile; WoodTile; WoodTile; WoodTile; WoodTile; WoodTile; WoodTile; WoodTile];
    [WoodTile; WoodTile; WoodTile; WoodTile; WoodTile; WoodTile; WoodTile; AirTile; AirTile; AirTile; AirTile; WoodTile; WoodTile; WoodTile; WoodTile; WoodTile; WoodTile; WoodTile];
    [WoodTile; WoodTile; WoodTile; WoodTile; WoodTile; WoodTile; WoodTile; WoodTile; AirTile; AirTile; WoodTile; WoodTile; WoodTile; WoodTile; WoodTile; WoodTile; WoodTile; WoodTile];
    [WoodTile; WoodTile; WoodTile; WoodTile; WoodTile; WoodTile; WoodTile; MineTile(FourthHero); AirTile; AirTile; MineTile(FourthHero); WoodTile; WoodTile; WoodTile; WoodTile; WoodTile; WoodTile; WoodTile];
    [WoodTile; WoodTile; WoodTile; WoodTile; WoodTile; WoodTile; WoodTile; AirTile; HeroTile(FourthHero); AirTile; AirTile; WoodTile; WoodTile; WoodTile; WoodTile; WoodTile; WoodTile; WoodTile];
    [WoodTile; WoodTile; WoodTile; WoodTile; WoodTile; AirTile; HeroTile(FirstHero); WoodTile; AirTile; AirTile; WoodTile; AirTile; AirTile; WoodTile; WoodTile; WoodTile; WoodTile; WoodTile];
    [WoodTile; WoodTile; WoodTile; WoodTile; WoodTile; AirTile; TavernTile; AirTile; AirTile; AirTile; AirTile; TavernTile; AirTile; WoodTile; WoodTile; WoodTile; WoodTile; WoodTile];
    [WoodTile; WoodTile; WoodTile; WoodTile; AirTile; AirTile; AirTile; AirTile; WoodTile; WoodTile; AirTile; AirTile; AirTile; AirTile; WoodTile; WoodTile; WoodTile; WoodTile];
    [WoodTile; WoodTile; WoodTile; WoodTile; WoodTile; WoodTile; AirTile; MineTile(FourthHero); WoodTile; WoodTile; MineTile(FourthHero); AirTile; WoodTile; WoodTile; WoodTile; WoodTile; WoodTile; WoodTile];
    [WoodTile; WoodTile; WoodTile; WoodTile; WoodTile; WoodTile; AirTile; MineTile(FourthHero); WoodTile; WoodTile; MineTile(FourthHero); AirTile; WoodTile; WoodTile; WoodTile; WoodTile; WoodTile; WoodTile];
    [WoodTile; WoodTile; WoodTile; WoodTile; AirTile; AirTile; AirTile; AirTile; WoodTile; WoodTile; AirTile; AirTile; AirTile; AirTile; WoodTile; WoodTile; WoodTile; WoodTile];
    [WoodTile; WoodTile; WoodTile; WoodTile; WoodTile; AirTile; TavernTile; AirTile; AirTile; AirTile; AirTile; TavernTile; AirTile; WoodTile; WoodTile; WoodTile; WoodTile; WoodTile];
    [WoodTile; WoodTile; WoodTile; WoodTile; WoodTile; AirTile; HeroTile(SecondHero); WoodTile; AirTile; AirTile; WoodTile; HeroTile(ThirdHero); AirTile; WoodTile; WoodTile; WoodTile; WoodTile; WoodTile];
    [WoodTile; WoodTile; WoodTile; WoodTile; WoodTile; WoodTile; WoodTile; AirTile; AirTile; AirTile; AirTile; WoodTile; WoodTile; WoodTile; WoodTile; WoodTile; WoodTile; WoodTile];
    [WoodTile; WoodTile; WoodTile; WoodTile; WoodTile; WoodTile; WoodTile; FreeMineTile; AirTile; AirTile; FreeMineTile; WoodTile; WoodTile; WoodTile; WoodTile; WoodTile; WoodTile; WoodTile];
    [WoodTile; WoodTile; WoodTile; WoodTile; WoodTile; WoodTile; WoodTile; WoodTile; AirTile; AirTile; WoodTile; WoodTile; WoodTile; WoodTile; WoodTile; WoodTile; WoodTile; WoodTile];
    [WoodTile; WoodTile; WoodTile; WoodTile; WoodTile; WoodTile; WoodTile; AirTile; AirTile; AirTile; AirTile; WoodTile; WoodTile; WoodTile; WoodTile; WoodTile; WoodTile; WoodTile];
    [WoodTile; WoodTile; WoodTile; WoodTile; WoodTile; WoodTile; WoodTile; AirTile; AirTile; AirTile; AirTile; WoodTile; WoodTile; WoodTile; WoodTile; WoodTile; WoodTile; WoodTile]
  ]

let board2json = "{
         \"size\":18,
         \"tiles\":\"##############        ############################        ##############################    ##############################$4    $4############################  @4    ########################  @1##    ##    ####################  []        []  ##################        ####        ####################  $4####$4  ########################  $4####$4  ####################        ####        ##################  []        []  ####################  @2##    ##@3  ########################        ############################$-    $-##############################    ##############################        ############################        ##############\"
      }"

let board2 = { size = 18; tiles = tiles2 }

let game1json = "{\"id\":\"e7wpmqp1\",\"turn\":0,\"maxTurns\":40,\"heroes\":[{\"id\":1,\"name\":\"sjdksdfdksjfh\",\"userId\":\"po33ddb8\",\"elo\":1200,\"pos\":{\"x\":1,\"y\":2},\"life\":100,\"gold\":0,\"mineCount\":0,\"spawnPos\":{\"x\":1,\"y\":2},\"crashed\":false},{\"id\":2,\"name\":\"random\",\"pos\":{\"x\":8,\"y\":2},\"life\":100,\"gold\":0,\"mineCount\":0,\"spawnPos\":{\"x\":8,\"y\":2},\"crashed\":false},{\"id\":3,\"name\":\"random\",\"pos\":{\"x\":8,\"y\":7},\"life\":100,\"gold\":0,\"mineCount\":0,\"spawnPos\":{\"x\":8,\"y\":7},\"crashed\":false},{\"id\":4,\"name\":\"random\",\"pos\":{\"x\":1,\"y\":7},\"life\":100,\"gold\":0,\"mineCount\":0,\"spawnPos\":{\"x\":1,\"y\":7},\"crashed\":false}],\"board\":{\"size\":10,\"tiles\":\"######################  @1########@4  ######            ####      ##    ##      $-##[]##    ##[]##$-$-##[]##    ##[]##$-      ##    ##      ####            ######  @2########@3  ######################\"},\"finished\":false}"

let game1 : game = {
    id = "e7wpmqp1"; turn = 0; max_turn = 40; finished = false; board = board1;
    heroes = [ {id = FirstHero; name = "sjdksdfdksjfh"; user_id = Some("po33ddb8"); elo = Some(1200); position = (2, 1); life = 100; gold = 0; mines = 0; spawn_position = (2, 1); crashed = false}; {id = SecondHero; name = "random"; position = (2, 8); life = 100; gold = 0; mines = 0; spawn_position = (2, 8); crashed = false; user_id = None; elo = None}; {id = ThirdHero; name = "random"; position = (7, 8); life = 100; gold = 0; mines = 0; spawn_position = (7, 8); crashed = false; user_id = None; elo = None}; {id = FourthHero; name = "random"; position = (7, 1); life = 100; gold = 0; mines = 0; spawn_position = (7, 1); crashed = false; user_id = None; elo = None} ]
  }

let state1json = "{\"game\":{\"id\":\"e7wpmqp1\",\"turn\":0,\"maxTurns\":40,\"heroes\":[{\"id\":1,\"name\":\"sjdksdfdksjfh\",\"userId\":\"po33ddb8\",\"elo\":1200,\"pos\":{\"x\":1,\"y\":2},\"life\":100,\"gold\":0,\"mineCount\":0,\"spawnPos\":{\"x\":1,\"y\":2},\"crashed\":false},{\"id\":2,\"name\":\"random\",\"pos\":{\"x\":8,\"y\":2},\"life\":100,\"gold\":0,\"mineCount\":0,\"spawnPos\":{\"x\":8,\"y\":2},\"crashed\":false},{\"id\":3,\"name\":\"random\",\"pos\":{\"x\":8,\"y\":7},\"life\":100,\"gold\":0,\"mineCount\":0,\"spawnPos\":{\"x\":8,\"y\":7},\"crashed\":false},{\"id\":4,\"name\":\"random\",\"pos\":{\"x\":1,\"y\":7},\"life\":100,\"gold\":0,\"mineCount\":0,\"spawnPos\":{\"x\":1,\"y\":7},\"crashed\":false}],\"board\":{\"size\":10,\"tiles\":\"######################  @1########@4  ######            ####      ##    ##      $-##[]##    ##[]##$-$-##[]##    ##[]##$-      ##    ##      ####            ######  @2########@3  ######################\"},\"finished\":false},\"hero\":{\"id\":1,\"name\":\"sjdksdfdksjfh\",\"userId\":\"po33ddb8\",\"elo\":1200,\"pos\":{\"x\":1,\"y\":2},\"life\":100,\"gold\":0,\"mineCount\":0,\"spawnPos\":{\"x\":1,\"y\":2},\"crashed\":false},\"token\":\"dj42\",\"viewUrl\":\"http://vindinium.org/e7wpmqp1\",\"playUrl\":\"http://vindinium.org/api/e7wpmqp1/dj42/play\"}"

let state1 : state = 
  { game = game1; hero_id = FirstHero; token = "dj42";
    view_url = "http://vindinium.org/e7wpmqp1";
    play_url = "http://vindinium.org/api/e7wpmqp1/dj42/play" }
