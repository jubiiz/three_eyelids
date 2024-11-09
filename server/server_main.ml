open Shared;;

let server_socket = Lwt_main.run @@ Udt.get_server_socket ()

let rdt_recv (): unit = 
    let response = Udt.recv server_socket in
    let packet_bytes = response.data in
    let packet = Packet.packet_of_bytes packet_bytes in
    let checksum = Packet.calculate_checksum_from_packet packet in
    if checksum != packet.checksum then
        print_endline "Checksum failed, dropping packet"
    else
      print_endline ("Received packet with: ");
      print_endline ("SEQ NUM: " ^ (string_of_int packet.seq_num));
      print_endline ("DATA LENGTH: " ^ (string_of_int packet.data_length));
      print_endline ("CHECKSUM: " ^ (string_of_int packet.checksum));
      print_endline ("DATA: " ^ (Bytes.to_string packet.data) ^ "\n")
;;

let rec server () = 
  let _ = rdt_recv () in
  server ()
;;


print_endline "Hello, World, this is server running!";;
let () = server();;
