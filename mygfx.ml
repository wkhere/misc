
let ($) f x = f (x) ;;
let (@.) f g x = g (f x) ;;
let ($.) f g x = f (g x) ;;

module G = Graphics;;
module C = Complex;;

let vis () =
  try ignore (G.size_x ()); true
  with G.Graphic_failure s as exc -> 
    if s = "graphic screen not opened" then false else raise exc
;;

let forceOpen () =
  if not (vis ()) then G.open_graph 
    (try Sys.getenv "DISPLAY" with Not_found -> ":0")
and forceClose () =
  if vis () then G.close_graph () ;;

let timeOf f =
  let t0, wt0 = Sys.time (), Unix.gettimeofday () in
  let res =  f () in
  let t1, wt1 = Sys.time (), Unix.gettimeofday () in
    Printf.printf "process & wall time [s]: %f %f\n" (t1 -. t0) (wt1 -. wt0);
    res ;;
