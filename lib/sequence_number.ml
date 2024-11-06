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
