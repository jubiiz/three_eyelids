open Shared;;

let server_socket = Lwt_main.run @@ Udt.get_server_socket ()
let null_byte = Bytes.make 1 (Char.chr 0);;

let rdt_recv (): string= 
  let rec rdt_recv_part (parts: string list) = 
    let response = Udt.recv server_socket in
    let packet_bytes = response.data in
    print_endline ("Received packet with bytes: " ^ (Bytes.to_string packet_bytes));
    let packet = Packet.packet_of_bytes packet_bytes in
    let checksum = Packet.calculate_checksum_from_packet packet in
    if checksum != packet.checksum then
        print_endline "Checksum failed, dropping packet"
    else
      print_endline ("Received packet with: ");
      print_endline ("SEQ NUM: " ^ (string_of_int packet.seq_num));
      print_endline ("DATA LENGTH: " ^ (string_of_int packet.data_length));
      print_endline ("CHECKSUM: " ^ (string_of_int packet.checksum));
      print_endline ("DATA: " ^ (Bytes.to_string packet.data) ^ "\n");
      if packet.data = null_byte then String.concat "" (List.rev parts)
      else rdt_recv_part ((Bytes.to_string packet.data)::parts) in
  rdt_recv_part []
;;

let rec server () = 
  let response = rdt_recv () in
  print_endline ("Received message: " ^ response);
  server ()
;;


print_endline "Hello, World, this is server running!";;
let () = server();;
