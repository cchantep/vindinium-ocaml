open Core.Std
open Hero
open Board
       
let (_, hero_tiles) = 
  List.fold_left [ FirstHero; SecondHero; ThirdHero; FourthHero; FifthHero;
                   SixthHero; SeventhHero; EighthHero; NinthHero ]
                 ~init:(1, []) 
                 ~f:(fun st hid -> 
                     let (i, l) = st in 
                     (i+1, (sprintf "@%i" i, HeroTile(hid)) :: l))

let (_, mine_tiles) = 
  List.fold_left [ FirstHero; SecondHero; ThirdHero; FourthHero; FifthHero;
                   SixthHero; SeventhHero; EighthHero; NinthHero ]
                 ~init:(1, []) 
                 ~f:(fun st hid -> 
                     let (i, l) = st in 
                     (i+1, (sprintf "$%i" i, MineTile(hid)) :: l))
