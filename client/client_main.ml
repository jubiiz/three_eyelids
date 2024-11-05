exception NotImplemented;;

type sequence_number = {
  increment: unit -> unit;
  get: unit -> int;
  (*equals: int -> bool;*)
};;

let create_sequence_number () =
  let counter = ref 0 in
  {
  increment = (fun () -> counter := (1 - !counter));
  get = (fun () -> !counter);
  (*equals = (fun x -> x = !counter);*)
  }
;;

let the_sequence_number = create_sequence_number ();;

let rdt_send (msg: string): unit = 
  raise NotImplemented
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