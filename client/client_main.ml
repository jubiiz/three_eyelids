open Shared;;

let client_socket = Lwt_main.run @@ Udt.get_client_socket ();;
let server_sockaddr = Unix.ADDR_INET (Udt.server_address, Udt.server_port);;

let explode (msg: string) = List.init (String.length msg) (fun i -> String.make 1 (String.get msg i));;

let rdt_send (msg: string): unit =
    let rec rdt_send_segment (msg_parts: string list) (seq_num: int) = 
        match msg_parts with
        | [] -> () 
        | next_segment::_ -> let packet = Packet.create seq_num next_segment in
            let packet_bytes = Packet.bytes_of_packet packet in
            let _ = Udt.send packet_bytes client_socket server_sockaddr in
            rdt_receive_ack msg_parts seq_num
    and rdt_receive_ack (msg_parts : string list) (seq_num: int) = 
      let response = Udt.recv client_socket in
      let packet_bytes = response.data in
      let packet = Packet.packet_of_bytes packet_bytes in
      let checksum = Packet.calculate_checksum_from_packet packet in
      if checksum != packet.checksum then
          let _ = print_endline "bad checksum" in
          rdt_send_segment msg_parts seq_num
      else if packet.data = Bytes.of_string "ACK" then
        if packet.seq_num = seq_num then
          let _ = print_endline "bad seq num: re-sending same seq num" in
          rdt_send_segment msg_parts packet.seq_num 
        else 
          let _ = print_endline "ACKed, sending new part" in
          match msg_parts with 
          | [] -> ()
          | _::parts -> rdt_send_segment parts (Sequence_number.increment seq_num)
      else
          let _ = print_endline "bad response" in
          rdt_send_segment msg_parts seq_num in
    let msg_parts = explode msg in
    rdt_send_segment (msg_parts @ [String.make 1 (Char.chr 0)]) 0 (* Null terminated list *)
;;

let rec client () = 
  let input = read_line () in
    print_endline @@ "Sending message: " ^ input;
  let _ = rdt_send input in
  client ()
;;

print_endline "Hello, World, this is client running!";;
let () = client();;
