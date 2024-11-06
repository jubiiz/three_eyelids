let the_sequence_number = Shared.Sequence_number.create_sequence_number ();;

let rdt_send (msg: string): unit = 
    let seq_num = the_sequence_number.get () in
    let _ = print_endline ("Sending message: " ^ msg ^ " with sequence number: " ^ string_of_int seq_num) in
    the_sequence_number.increment ()
    
  (*let a_request_packet = form_packet input in*)
	(* TODO IMPLEMENT *)
;;

let rec client () = 
  let input = read_line () in
  let _ = rdt_send input in
  client ()
;;


print_endline "Hello, World, this is client running!";;
let () = client();;