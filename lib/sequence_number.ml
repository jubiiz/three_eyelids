type sequence_number = {
  increment: unit -> unit;
  get: unit -> int;
  (*equals: int -> bool;*)
};;

let increment (seq_num: int) =
  1 - seq_num
;;

let create_sequence_number () =
  let counter = ref 0 in
  {
  increment = (fun () -> counter := (increment !counter));
  get = (fun () -> !counter);
  (*equals = (fun x -> x = !counter);*)
  }
;;
