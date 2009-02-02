
let compose f g = fun x -> f (g x)

let ($) f x = f (x)
let (@.) f g x = g (f x)
let ($.) f g x = f (g x) 

let curry f = fun x y -> f (x,y)
and uncurry f = fun (x,y) -> f x y 

(* equivs: *)
let h = function f -> function y -> (f y) + y
let h = fun f y -> (f y) + y
let h f y = (f y) + y

let rec ack m n = 
  match (m, n) with
  | (0, _) -> n+1
  | (_, 0) -> ack (m-1) 1
  | _ -> ack (m-1) (ack m (n-1)) ;;
      
let rec fac = function
  | 0 -> 1
  | n when n>0 -> n*fac(n-1)
  | _ -> failwith "negative arg" ;;

let may f = function
  | None -> ()
  | Some x -> let _ = f x in () ;;

let f ?opt () = may (printf "opt=%d ") opt;;

let revstr s =
  (* imperative string reverse - inspired by Joel S, haha *)
  let len = String.length s in
  let m=len/2 in
  let rec rev i1 i2 = 
    if (i1<m) then begin
	let c = s.[i1] in
	  s.[i1] <- s.[i2]; s.[i2] <- c;
	  rev (i1+1) (i2-1)
      end
  in rev 0 (len-1) ;;
      

module type NONNEG = 
sig
  type t
  val create : int -> t
  val get : t -> int 
end ;;

module NonNeg : NONNEG =  struct
  type t = int
  let create = function
    | x when x >= 0 -> x
    | _ -> failwith "negative arg"
  let get x = x
end ;; 

(* facN: very ugly - and in fact useless w/o operators defined on NonNeg *)
let rec facN x = match x with
  | n when n = (NonNeg.create 0) -> NonNeg.create 1
  | n -> NonNeg.create ((NonNeg.get n) * (NonNeg.get (facN (NonNeg.create ((NonNeg.get n)-1))))) ;;
(* Uff... that was really lose; how to avoid such overhead?
 * I guess the answer is: proper operators for NonNeg module. 
 * Or no such complexity at all.
 *)
 
 let head = function
   |  x::xs -> Some x
   | [] -> None ;;

let timeOf f =
  let t0, wt0 = Sys.time (), Unix.gettimeofday () in
  let res =  f () in
  let t1, wt1 = Sys.time (), Unix.gettimeofday () in
    Printf.printf "process & wall time [s]: %f %f\n" (t1 -. t0) (wt1 -. wt0);
    res ;;

let rec genlist = function 0 -> [] | n -> n :: genlist (n-1);;   

let map f xs =
  let rec rmap f xs limit = match xs, limit with
    | [], _ -> []
    | xs, 0 -> List.rev_map f (List.rev xs)
    | x::xs, _ -> f x :: rmap f xs (pred limit)
  in rmap f xs 512;;

let pfoo = `PFoo 1;;
type pfoo = [`PFoo of int];;
let pfun1 (`PFoo x : pfoo) = x;

type pquux = [`PFoo of int | `PBar];;
let pfun2 (x : pquux) = match x with
  | #pfoo as v -> pfun1 v
  | `PBar -> -42 ;;

(* a bug in tuareg-mode 1.46.{0,1}:
type 'aa foo = Foo of 'aa;;
*)

(*
type 'a monad = M of 'a;;
type ('a, 'b) proc = 'a -> 'b monad;;

type ('s, 'a) monad_st = 's -> ('s * 'a) monad;;

let ( >>= ) (m1 : ('s,'a) monad_st)  f =
  (fun st -> 
    let (a, st2) = m1 st in
    let m2 = f a in
    m2 st2) 
;;
  
let return a = fun st -> (a, st) ;;
*)

(* recursive definition of type *)
type expr = I of int | S of string | F of (expr -> expr) | L of expr list
;;

(* example of module in local scope *)
let module L = List in
  L.map
;;

(* bin, octal and hex literals, numeric  *)
[ 0b01000001; 0o101; 0x41 ];;
(* decimal (NOT octal, must be 3 digits) and hex codes in chars & strings *)
[ '\065'; '\x41' ], "\065\x42\066\x41";;

(* copying records *)
type r_t = { x:int; s:string };;
let r0 = {x=0; s="foo"};;
let r1 = {r0 with x=42};;

