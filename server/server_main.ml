open Shared;;

let the_sequence_number = Sequence_number.create_sequence_number ();;

let rdt_recv (msg: string): unit = 
    let seq_num = the_sequence_number.get () in
    let _ = print_endline ("Receiving message: " ^ msg ^ " with sequence number: " ^ string_of_int seq_num) in
    let response = Udt.recv Udt.server_socket in
    the_sequence_number.increment (); print_endline ("Received message: " ^ (Bytes.to_string response.data))
    
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