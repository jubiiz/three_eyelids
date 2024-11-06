open Shared.Sequence_number;;

assert true;;

(* Can create sequence number *)
let the_sample_number = create_sequence_number ();;

(* initializes to 0 *)
assert (the_sample_number.get () = 0);;

(* increments to 1 *)
the_sample_number.increment ();;
assert (the_sample_number.get () = 1);;

(* overflows to 0 *)
the_sample_number.increment ();;
assert (the_sample_number.get () = 0);;

(* separate sequence numbers increment separately*)
let number2 = create_sequence_number ();;
assert (number2.get () = 0);;
number2.increment ();;
assert (number2.get () = 1);;
assert (the_sample_number.get () = 0);;