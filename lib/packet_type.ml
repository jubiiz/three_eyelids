(* the two types below are the types that will be used to contain our data nicely *)
type checksum = int;;

type packet = {
  seq_num: int;
  data: bytes;
  mutable checksum: checksum;
  msg_length: int;
}