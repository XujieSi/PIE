open Batteries
open QCheck.Arbitrary

(************
 * Generators
 ************)

let quint g1 g2 g3 g4 g5 = (fun rand -> (g1 rand, g2 rand, g3 rand, g4 rand, g5 rand))

(* generate a random gpass value k out of n times, gfail value otherwise *)
let odds k n gpass gfail = (fun rand ->
  if List.hd (generate ~n:1 (0 -- n)) < k then (gpass rand) else (gfail rand)
)

(* generate random trees using node to combine sub-trees *)
let rec tree ?(maxh=5) (gdecide :bool t) (node   :('t -> 'v -> 't -> 't))
                                         (empty  :'n)
                                         (gvalue :'v t)
    : 't t = (fun rand ->
      if (not (gdecide rand)) || (maxh < 1) then empty
      else (node (tree ~maxh:(maxh - 1) gdecide node empty gvalue rand)
                 (gvalue rand)
                 (tree ~maxh:(maxh - 1) gdecide node empty gvalue  rand))
    )

(* create a generator for values generated by g that additionally satisfy predicate p *)
let pred g p =
  (fun rand ->
     let rec loopUntil () =
       let cand = g rand in
     if (p cand) then cand else loopUntil() in
       loopUntil ())

let rec char = (fun rand -> let c = Char.chr (List.hd (generate ~n:1 ~rand:rand (32 -- 126))) in
                            if c = '\\' then char rand else c)

let string_len rng =
    (fun rand ->
        let len = List.hd (generate ~n:1 ~rand:rand rng) in
            BatString.of_list (generate ~n:len char))

(* check if all characters in a string are distinct *)
let distinct s =
  let l = BatString.to_list s in
  let (b, _) =
    BatList.fold_left (fun (b,l) e -> let t = List.tl l in match BatList.index_of e t with None -> (b,t) | _ -> (false,t)) (true,l) l
  in b



(***************
 * Basic Dumpers
 ***************)

let int_dumper = string_of_int
let char_dumper c = "'" ^ (Char.escaped c) ^ "'"
let string_dumper s = "\"" ^ s ^ "\""
let list_dumper d l = "[" ^ (String.concat ", " (List.map d l)) ^ "]"
let pair_dumper d1 d2 (a, b) = "(" ^ (d1 a) ^ ", " ^ (d2 b) ^ ")"
let triple_dumper d1 d2 d3 (a, b, c) = "(" ^ (d1 a) ^ ", " ^ (d2 b) ^ ", " ^ (d3 c) ^ ")"
let quad_dumper d1 d2 d3 d4 (a, b, c, d) = "(" ^ (d1 a) ^ ", " ^ (d2 b) ^ ", " ^ (d3 c) ^ ", " ^ (d4 d) ^ ")"
let quint_dumper d1 d2 d3 d4 d5 (a, b, c, d, e) = "(" ^ (d1 a) ^ ", " ^ (d2 b) ^ ", " ^ (d3 c) ^ ", " ^ (d4 d) ^ ", " ^ (d5 e) ^ ")"



(***********
 * Constants
 ***********)

let test_size = ref 6400

let sint = (-4) -- 5
let sposInt = 0 -- 6
let string = string_len (0 -- 13)



(**********************
 * Integer combinations
 **********************)

let int_tests () = generate ~n:(!test_size) sint

let intList = list ~len:sposInt sint
let intList_dumper = list_dumper int_dumper
let intList_tests () = generate ~n:(!test_size) intList

let intListList = list ~len:sposInt intList
let intListList_dumper = list_dumper intList_dumper
let intListList_tests () = generate ~n:(!test_size) intListList

let intList_int = pair intList sint
let intList_int_dumper = pair_dumper intList_dumper int_dumper
let intList_int_tests () = generate ~n:(!test_size) intList_int

let int_intList = pair sint intList
let int_intList_dumper = pair_dumper int_dumper intList_dumper
let int_intList_tests () = generate ~n:(!test_size) int_intList

let intList_intList = pair intList intList
let intList_intList_dumper = pair_dumper intList_dumper intList_dumper
let intList_intList_tests () = generate ~n:(!test_size) intList_intList

let int_int_List = list ~len:sposInt (pair sint sint)
let int_int_List_dumper = list_dumper (pair_dumper int_dumper int_dumper)
let int_int_List_tests () = generate ~n:(!test_size) int_int_List

let int__int_int_List = pair sint int_int_List
let int__int_int_List_dumper = pair_dumper int_dumper int_int_List_dumper
let int__int_int_List_tests () = generate ~n:(!test_size) int__int_int_List




(*********************
 * String combinations
 *********************)

let distinct_string = pred string distinct

let string_tests () = generate ~n:(!test_size) string

let stringList = list ~len:sposInt string
let stringList_dumper = list_dumper string_dumper

let string_int = pair string sint
let string_int_dumper = pair_dumper string_dumper int_dumper
let string_int_tests () = generate ~n:(!test_size) string_int

let string_char = pair string char
let string_char_dumper = pair_dumper string_dumper char_dumper
let string_char_tests () = generate ~n:(!test_size) string_char

let string_string = pair string string
let string_string_dumper = pair_dumper string_dumper string_dumper
let string_string_tests () = generate ~n:(!test_size) string_string

let string_int_int = triple string sint sint
let string_int_int_dumper = triple_dumper string_dumper int_dumper int_dumper
let string_int_int_tests () = generate ~n:(!test_size) string_int_int

let int_char = pair sint char
let int_char_dumper = pair_dumper int_dumper char_dumper
let int_char_tests () = generate ~n:(!test_size) int_char

let string_int_char = triple string sint char
let string_int_char_dumper = triple_dumper string_dumper int_dumper char_dumper
let string_int_char_tests () = generate ~n:(!test_size) string_int_char

let string_stringList = pair string stringList
let string_stringList_dumper = pair_dumper string_dumper stringList_dumper
let string_stringList_tests () = generate ~n:(!test_size) string_stringList

let string_int_int_int_dumper = quad_dumper string_dumper int_dumper int_dumper int_dumper
let string_int_int_int_int_dumper = quint_dumper string_dumper int_dumper int_dumper int_dumper int_dumper

let string_int_string_int_int = quint string sint string sint sint
let string_int_string_int_int_dumper = quint_dumper string_dumper int_dumper string_dumper int_dumper int_dumper
let string_int_string_int_int_tests () = generate ~n:(!test_size) string_int_string_int_int

let string_int_int_char = quad string sint sint char
let string_int_int_char_dumper = quad_dumper string_dumper int_dumper int_dumper char_dumper
let string_int_int_char_tests () = generate ~n:(!test_size) string_int_int_char

let distinct_string_int_int_int = quad distinct_string sint sint sint
let distinct_string_int_int_int_tests () = generate ~n:(!test_size) distinct_string_int_int_int

let distinct_string_int_int_int_int = quint distinct_string sint sint sint sint
let distinct_string_int_int_int_int_tests () = generate ~n:(!test_size) distinct_string_int_int_int_int

(**********
 * AVL Tree
 **********)

let iavltree = tree (odds 4 5 (return true) (return false)) BatAvlTree.make_tree BatAvlTree.empty sint
let iavltree_iavltree = pair iavltree iavltree
let iavltree_int_iavltree = triple iavltree sint iavltree

let iavltree_tests () = generate ~n:(!test_size) iavltree
let iavltree_iavltree_tests () = generate ~n:(!test_size) iavltree_iavltree
let iavltree_int_iavltree_tests () = generate ~n:(!test_size) iavltree_int_iavltree

let rec avltree_dumper d avl =
  if (BatAvlTree.is_empty avl) then "{}"
  else "{" ^ (d (BatAvlTree.root avl)) ^ " " ^ (avltree_dumper d (BatAvlTree.left_branch avl)) ^ " " ^ (avltree_dumper d (BatAvlTree.right_branch avl)) ^ "}"

let iavltree_dumper = avltree_dumper int_dumper
let iavltree_iavltree_dumper = pair_dumper iavltree_dumper iavltree_dumper
let iavltree_int_iavltree_dumper = triple_dumper iavltree_dumper int_dumper iavltree_dumper
