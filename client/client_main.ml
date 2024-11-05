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

let rec main () = 
  let input = read_line () in
  the_sequence_number.increment();
  Printf.printf "The sequence number is: %d and you entered: %s\n" (the_sequence_number.get()) (input); 
  main ()
;;


print_endline "Hello, World, this is client running!";;
let () = main();;