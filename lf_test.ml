open Printf;;
open Unix;;

let test fn =
  let _ =
    try 
      let st = stat fn in
	printf "stat: size=%d\n" (st.st_size)  
    with Unix_error (EOVERFLOW, func, arg) ->
      printf "normal stat caused EOVERFLOW: %s %s\n" func arg
  in
  let _ =
    let st = LargeFile.stat fn in
      printf "LargeFile.stat: size=%s\n" (Int64.to_string st.LargeFile.st_size)
  in ()
;;
    
if not !Sys.interactive then
  test Sys.argv.(1)
;;
