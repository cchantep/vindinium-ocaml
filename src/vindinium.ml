open Core.Std

open Hero

let () =  let hero = Hero.make ~id:FirstHero ~name:"Test" 
  ~pos:(0,0) ~spawn:(1,1) () in 
  printf "hero = %s" (Hero.to_string hero)
