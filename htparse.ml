#require "str";;
#require "netclient";;
#require "netstring";;

open Http_client;;
open Nethtml;;
open List;;

let ($) f x = f (x)
let (@.) f g x = g (f x)
let ($.) f g x = f (g x) 

let pageC urlStr =
  let call = new get urlStr in
  let pipe = new pipeline in
  let _ = pipe # add call in
  let rec run_ () = 
    pipe # run ();
    match call # status with
      | `Successful -> ()
      | `Client_error | `Server_error -> failwith "retrieve error"
      | `Http_protocol_error x -> raise x
      | `Unserved | `Redirection -> run_ ()
  in let _ = run_ () in
  call # response_body # open_value_rd ()
;;

let htBody doc = match doc with 
  | Element (_, _, h:: (Element ("body", _, d) as x) ::_) -> x
  | Element (_, _, _) -> failwith "expected non-empty body"
  | Data _ -> failwith "expected body Element"
;;

let elname = function Element (name, _, _) -> name ;;
let elsub = function Element (_, _, l) -> l ;;

let docFind matcher docL =
  let rec searchRec docL = 
    let res = map (matcher searchRec) docL 
    in try 
	find (function Some doc -> true | None -> false) res
      with Not_found -> None
  in match searchRec docL with
    | Some d -> d
    | None -> raise Not_found ;;

let parentFind pred =
  docFind 
    (fun cont doc -> match doc with
      | Element (_, _, l) as par when exists pred l -> Some par
      | Element (_, _, l) -> cont l
      | _ -> None) 
;;
    
let dataFind pattern docL =
  let rx = Str.regexp pattern in
  let matchP s = Str.string_match rx s 0 in
  let pred = function
    | Data s when matchP s -> true
    | _ -> false
  in parentFind pred docL ;;


let page1 = pageC "http://www.rada.uw.edu.pl/baza.php?operacja=9";;
let docs1 = decode $ parse page1;;
let body1 = [htBody $ hd docs1];;

let d1 =
  let e1 = dataFind "Studenckie Ko.o Naukowe Historyk.w Uniwersytetu Warszawskiego" body1 in
  let d = parentFind (fun x -> x==e1) body1 in
  parentFind (fun x -> x==d) body1
;;

let iProc1 doc = 
  try match elsub doc with
    | _ :: Element ("td", _, Data s1::_) :: _ :: Element ("td", _, Data s2::_)
      :: _ :: Element ("td", _, d) :: _
      -> Some (
	  s1 ^ " <" ^
	    (match d with
	      | Element ("a", _, Data s3::_) :: _ -> s3
	      | _ -> raise Not_found)
	  ^ ">")
    | _ -> raise Not_found
  with Not_found -> None ;;

let tProc1 doc = 
  let l = 
    map (function Some x -> x | _ -> failwith "tProc1: non-expected empty row") 
    $ filter (function Some _ -> true | None -> false) 
    (map iProc1 (elsub doc))
  in 
  let oc = open_out "foo.txt" in
    iter (fun s -> Printf.fprintf oc "%s;\n" s) l;
    close_out oc;
;;  
  
