open Shared;;

let the_sequence_number = Sequence_number.create_sequence_number ();;

let rdt_recv: unit = 
    let seq_num = the_sequence_number.get () in
    let response = Udt.recv Udt.server_socket in
    the_sequence_number.increment (); print_endline ("Received message: " ^ (Bytes.to_string response.data));
    ignore seq_num
    
  (*let a_request_packet = form_packet input in*)
	(* TODO IMPLEMENT *)
;;

let rec server () = 
  let _ = rdt_recv in
  server ()
;;


print_endline "Hello, World, this is server running!";;
let () = server();;