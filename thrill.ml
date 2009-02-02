#load "unix.cma";;

open Unix;;

let stopSig, contSig = 17, 19;;

let usleep usec = ignore (select [] [] [] ((float_of_int usec) /. 1000.));; 

type child_status = ChildRunning | ChildExited of int | NoChild ;;

let childExited pid =
  try match Unix.waitpid [Unix.WNOHANG] pid with
    | (pid, Unix.WEXITED exitcode) -> ChildExited exitcode
    | _ -> ChildRunning
  with Unix.Unix_error (Unix.ECHILD, "waitpid", _) -> NoChild
;;

let doThrill dt1 dt2 sub_argv =
  let pid = Unix.fork () in
    if pid=0 then
      Unix.execvp sub_argv.(0) sub_argv
    else 
      let rec loop () = 	
	usleep dt1;
	if childExited pid = ChildRunning then begin
	    kill pid stopSig;
	    Printf.eprintf "sent sigstop\n";
	    usleep dt2;
	    if childExited pid = ChildRunning then begin
		kill pid contSig;
		Printf.eprintf "sent sigcont\n";
		loop ();
	      end;
	  end;
      in
	try loop ()
	with Unix.Unix_error (Unix.ESRCH, "kill", _) ->
	  Printf.eprintf "no pid to kill\n"
;;

if not !Sys.interactive then
  let argv, alen = Sys.argv, Array.length Sys.argv in
  doThrill
    (int_of_string argv.(1))
    (int_of_string argv.(2))
    (Array.sub argv 3 (alen-3))
;;
