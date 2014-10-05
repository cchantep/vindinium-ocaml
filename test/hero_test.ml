open Core.Std
open OUnit2
open Hero

module Hero_test = struct
    let first_from_int ctx = match HeroId.from_int 1 with
      | Ok(id) -> 
         assert_equal ~msg:"First hero ID from int 1" id FirstHero
      | _ -> assert_failure "No hero ID made from int 1"
                            
    let second_from_int ctx = match HeroId.from_int 2 with
      | Ok(id) -> 
         assert_equal ~msg:"Second hero ID from int 2" id SecondHero
      | _ -> assert_failure "No hero ID made from int 2"
                            
    let third_from_int ctx = match HeroId.from_int 3 with
      | Ok(id) -> 
         assert_equal ~msg:"Third hero ID from int 3" id ThirdHero
      | _ -> assert_failure "No hero ID made from int 3"
                            
    let fourth_from_int ctx = match HeroId.from_int 4 with
      | Ok(id) -> 
         assert_equal ~msg:"Fourth hero ID from int 4" id FourthHero
      | _ -> assert_failure "No hero ID made from int 4"
                            
    let fifth_from_int ctx = match HeroId.from_int 5 with
      | Ok(id) -> 
         assert_equal ~msg:"Fifth hero ID from int 5" id FifthHero
      | _ -> assert_failure "No hero ID made from int 5"
                            
    let sixth_from_int ctx = match HeroId.from_int 6 with
      | Ok(id) -> 
         assert_equal ~msg:"Sixth hero ID from int 6" id SixthHero
      | _ -> assert_failure "No hero ID made from int 6"
                            
    let seventh_from_int ctx = match HeroId.from_int 7 with
      | Ok(id) -> 
         assert_equal ~msg:"Seventh hero ID from int 7" id SeventhHero
      | _ -> assert_failure "No hero ID made from int 7"
                            
    let eighth_from_int ctx = match HeroId.from_int 8 with
      | Ok(id) -> 
         assert_equal ~msg:"Eighth hero ID from int 8" id EighthHero
      | _ -> assert_failure "No hero ID made from int 8"
                            
    let ninth_from_int ctx = match HeroId.from_int 9 with
      | Ok(id) -> 
         assert_equal ~msg:"Ninth hero ID from int 9" id NinthHero
      | _ -> assert_failure "No hero ID made from int 9"
                            
    let first_from_char ctx = match HeroId.from_char '1' with
      | Ok(id) -> 
         assert_equal ~msg:"First hero ID from char 1" id FirstHero
      | _ -> assert_failure "No hero ID made from char 1"

    let second_from_char ctx = match HeroId.from_char '2' with
      | Ok(id) -> 
         assert_equal ~msg:"Second hero ID from char 2" id SecondHero
      | _ -> assert_failure "No hero ID made from char 2"
                            
    let third_from_char ctx = match HeroId.from_char '3' with
      | Ok(id) -> 
         assert_equal ~msg:"Third hero ID from char 3" id ThirdHero
      | _ -> assert_failure "No hero ID made from char 3"
                            
    let fourth_from_char ctx = match HeroId.from_char '4' with
      | Ok(id) -> 
         assert_equal ~msg:"Fourth hero ID from char 4" id FourthHero
      | _ -> assert_failure "No hero ID made from char 4"
                            
    let fifth_from_char ctx = match HeroId.from_char '5' with
      | Ok(id) -> 
         assert_equal ~msg:"Fifth hero ID from char 5" id FifthHero
      | _ -> assert_failure "No hero ID made from char 5"
                            
    let sixth_from_char ctx = match HeroId.from_char '6' with
      | Ok(id) -> 
         assert_equal ~msg:"Sixth hero ID from char 6" id SixthHero
      | _ -> assert_failure "No hero ID made from char 6"

    let seventh_from_char ctx = match HeroId.from_char '7' with
      | Ok(id) -> 
         assert_equal ~msg:"Seventh hero ID from char 7" id SeventhHero
      | _ -> assert_failure "No hero ID made from char 7"

    let eighth_from_char ctx = match HeroId.from_char '8' with
      | Ok(id) -> 
         assert_equal ~msg:"Eighth hero ID from char 8" id EighthHero
      | _ -> assert_failure "No hero ID made from char 8"

    let ninth_from_char ctx = match HeroId.from_char '9' with
      | Ok(id) -> 
         assert_equal ~msg:"Ninth hero ID from char 9" id NinthHero
      | _ -> assert_failure "No hero ID made from char 9"

    let make_first_hero ctx = 
      let _ = Hero.make ~id:FirstHero ~name:"First one"
                        ~pos:(0, 0) ~spawn:(1, 0) in ()
                                        

    let suite = [
        "First hero ID from int 1"    >:: first_from_int;
        "Second hero ID from int 2"   >:: second_from_int;
        "Third hero ID from int 3"    >:: third_from_int;
        "Fourth hero ID from int 4"   >:: fourth_from_int;
        "Fifth hero ID from int 5"    >:: fifth_from_int;
        "Sixth hero ID from int 6"    >:: sixth_from_int;
        "Seventh hero ID from int 7"  >:: seventh_from_int;
        "Eighth hero ID from int 8"   >:: eighth_from_int;
        "Ninth hero ID from int 9"    >:: ninth_from_int;
        "First hero ID from char 1"   >:: first_from_char;
        "Second hero ID from char 2"  >:: second_from_char;
        "Third hero ID from char 3"   >:: third_from_char;
        "Fourth hero ID from char 4"  >:: fourth_from_char;
        "Fifth hero ID from char 5"   >:: fifth_from_char;
        "Sixth hero ID from char 6"   >:: sixth_from_char;
        "Seventh hero ID from char 7" >:: seventh_from_char;
        "Eighth hero ID from char 8"  >:: eighth_from_char;
        "Ninth hero ID from char 9"   >:: ninth_from_char;
        "Make first hero"             >:: make_first_hero
      ]
  end
