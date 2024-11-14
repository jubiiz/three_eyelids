open Shared;;

let the_sequence_number = Sequence_number.create_sequence_number ();;
let client_socket = Lwt_main.run @@ Udt.get_client_socket ();;
let server_sockaddr = Unix.ADDR_INET (Udt.server_address, Udt.server_port);;

let explode (msg: string) = List.init (String.length msg) (fun i -> String.make 1 (String.get msg i));;

let rdt_send (msg: string): unit =
    let rec rdt_send_segment (msg_parts: string list) = 
        match msg_parts with
        | [] -> () 
        | next_segment::parts -> let seq_num = the_sequence_number.get () in            
            let packet = Packet.create seq_num next_segment in
            let packet_bytes = Packet.bytes_of_packet packet in
            let _ = Udt.send packet_bytes client_socket server_sockaddr in
            the_sequence_number.increment (); rdt_send_segment parts in
    let msg_parts = explode msg in
    rdt_send_segment (msg_parts @ [String.make 1 (Char.chr 0)]) (* Null terminated list *)
;;

let rec client () = 
  let input = read_line () in
    print_endline @@ "Sending message: " ^ input;
  let _ = rdt_send input in
  client ()
;;

print_endline "Hello, World, this is client running!";;
let () = client();;
