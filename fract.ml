
module G = Graphics;;
module C = Complex;;

let vis () =
  try ignore (G.size_x ()); true
  with G.Graphic_failure s as exc -> 
    if s = "graphic screen not opened" then false else raise exc
;;

let forceOpen () =
  if not (vis ()) then G.open_graph ":0"
and forceClose () =
  if vis () then G.close_graph () ;;

let colorTab = [20, G.white;
		10, G.yellow;
		8, G.green;
		6, G.cyan;
		5, G.red;
		3, G.magenta;
		min_int, G.blue;
	       ];;

type mandelity = InSet | Escape of int;;

let goMandelC maxit (x0,y0) = 
  let c0 = {C.re=x0; C.im=y0} in 
  let rec cMandel i c = match i, (C.norm2 c) with
  | _, m2 when m2 >= 4. -> Escape i
  | i, _ when i >= maxit -> InSet
  | _-> cMandel (succ i) (C.add c0 (C.mul c c))
  in cMandel 0 c0 ;;

(* float instead of complex: much faster with bytecode,
   significantly faster with native G4 code *)
let goMandelF maxit (x0,y0) =
  let rec fMandel i (x,y) = match i, (x*.x), (y*.y) with
    | _, x2, y2 when x2 +. y2 >= 4. -> Escape i
    | i, _, _ when i >= maxit -> InSet
    | _, x2, y2 -> 
	let y' = 2. *. x *. y +. y0 
	and x' = x2 -. y2 +. x0 in 
	  fMandel (succ i) (x',y')
  in fMandel 0 (x0,y0) ;;

let goMandelF' maxit (x0,y0) =
  let rec fMandel i x y = match i, (x*.x), (y*.y) with
    | _, x2, y2 when x2 +. y2 >= 4. -> Escape i
    | i, _, _ when i >= maxit -> InSet
    | _, x2, y2 -> 
	let y' = 2.*.x*.y +. y0 
	and x' = x2 -. y2 +. x0 in 
	  fMandel (succ i) x' y'
  in fMandel 0 x0 y0 ;;

let goMandelF'' maxit (x0,y0) =
  let rec fMandel x y i = match (x*.x), (y*.y), i with
    | x2, y2, _ when x2 +. y2 >= 4. -> Escape i
    | _ when i >= maxit -> InSet
    | x2, y2, _ -> 
	let y' = 2.*.x*.y +. y0 
	and x' = x2 -. y2 +. x0 in 
	  fMandel x' y' (succ i)
  in fMandel x0 y0 0;;

let goMandelF''' maxit (x0,y0) =
  let rec fMandel x y i = 
    let x2 = x*.x and y2 = y*.y in
      if x2 +. y2 >= 4. then Escape i else
	if i >= maxit then InSet else
	  let y' = 2.*.x*.y +. y0 
	  and x' = x2 -. y2 +. x0 in 
	    fMandel x' y' (succ i)
  in fMandel x0 y0 0;;

let rectMandel mandelFun (x0,y0) (x1,y1) xp yp =
  let dx = (x1 -. x0) /. float_of_int xp 
  and dy = (y1 -. y0) /. float_of_int yp in
  let rec iterX x xi =
    if xi < xp then 
      let rec iterY y yi = 
	if yi < yp then
	  let color = match mandelFun (x,y) with
	    | InSet -> G.black
	    | Escape i -> snd (List.find (fun c -> i >= fst c) colorTab)
	  in G.set_color color; G.plot xi yi;
	    iterY (y +. dy) (succ yi)
      in iterY y0 0;
	iterX (x +. dx) (succ xi)
  in iterX x0 0 ;;

(* Imperative version is usually a bit faster with bytecode 
   and sometimes a bit slower with native G4 code. 
   It also depends on a cpu cache (?) *)
let rectMandelI mandelFun (x0,y0) (x1,y1) xp yp =
  let dx = (x1 -. x0) /. float_of_int xp 
  and dy = (y1 -. y0) /. float_of_int yp in
  let x = ref x0 in 
    for xi=0 to xp do
      begin
	let y = ref y0 in
	  for yi=0 to yp do
	    begin
	      let color = match mandelFun (!x,!y) with
	    | InSet -> G.black
	    | Escape i -> snd (List.find (fun c -> i >= fst c) colorTab)
	      in G.set_color color; G.plot xi yi;
	    end; y := !y +. dy 
	  done
      end; x := !x +. dx
    done ;;

let timeOf f =
  let t0, wt0 = Sys.time (), Unix.gettimeofday () in
  let res =  f () in
  let t1, wt1 = Sys.time (), Unix.gettimeofday () in
    Printf.printf "process & wall time [s]: %f %f\n" (t1 -. t0) (wt1 -. wt0);
    res ;;

let test maxit xp yp fsel =
  forceOpen ();
  G.resize_window xp yp;
  let fs = [| rectMandel (goMandelC maxit); 
	      rectMandel (goMandelF maxit);
	      rectMandel (goMandelF' maxit);
	      rectMandel (goMandelF'' maxit);
	      rectMandel (goMandelF''' maxit);
	      rectMandelI (goMandelC maxit); 
	      rectMandelI (goMandelF maxit);
	      rectMandelI (goMandelF' maxit);
	      rectMandelI (goMandelF'' maxit);
	      rectMandelI (goMandelF''' maxit);
	   |] in
  let testf f =
    G.clear_graph ();
    timeOf (fun _-> f (-1.7,-1.2) (0.8,1.2) xp yp);
    flush stdout;
  in match fsel with
    | "all" -> Array.iter testf fs
    | fno -> testf fs.(int_of_string fno)
;;

if not !Sys.interactive then 
  let args = String.concat " " (List.tl (Array.to_list Sys.argv))
  in Scanf.sscanf args "%d %d %d %s" test
;;
