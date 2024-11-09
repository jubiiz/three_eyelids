let rdt_recv (msg: string): unit = 
    print_endline ("Receiving message: " ^ msg ^ " with sequence number: ")
    
  (*let a_request_packet = form_packet input in*)
	(* TODO IMPLEMENT *)
;;

let rec server () = 
  let input = read_line () in
  let _ = rdt_recv input in
  server ()
;;


print_endline "Hello, World, this is server running!";;
let () = server();;