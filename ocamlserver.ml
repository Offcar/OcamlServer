(*Oscar Ortiz Gajardo, 4/03/2018*)
(*documentación para funciones de lab3 https://ocaml.github.io/ocamlunix/ocamlunix.html*)
(*documentación para la lecturia de archivo https://rosettacode.org/wiki/Read_entire_file#OCaml*)

open Unix;;
open Sys;;

(*-----------funciones para el manejo de archivos-----------*)
(*funcion que identifica si existe o no un archivo, utiliza file_exists de la libreria Sys*)
let file_existence filename =
  if (file_exists filename = true) then filename else "N";;

(*Con esta respuesta podremos seseparar entre mandar el mensaje del contenido del documento o decir al usuario que el archivo no existe*)
let read_file filename = 
  if filename = "N" then "No pudo efectuarse el envio de archivos, el archivo descrito no existe o la ruta es invalida." else 
  let ic = open_in filename in
  let n = in_channel_length ic in
  (*al utilizar los caracteres con String.create, nos quedamos sin espacio del string maximo de Ocaml, por lo que Bytes.create se usa en su lugar*)
  let s = Bytes.create n in
  really_input ic s 0 n;
  close_in ic;
  (s);;

(*-----------funciones faltantes en el lab3-----------*)
let try_finalize f x finally y =
  let res = try f x with exn -> finally y; raise exn in
  finally y;
  res;;

let rec restart_on_EINTR f x = 
  try f x with Unix_error (EINTR, _, _) -> restart_on_EINTR f x;;

let double_fork_treatment server service (client_descr, _ as client) =
  let treat () = match fork () with
    | 0 ->
        if fork () <> 0 then exit 0;
        close server; service client; exit 0
    | k ->
        ignore (restart_on_EINTR (waitpid []) k)
  in
  try_finalize treat () close client_descr;;

let install_tcp_server_socket addr =
  let s = socket PF_INET SOCK_STREAM 0 in
    try
       bind s addr;
       listen s 10;
       s
    with z -> close s; raise z;;

let tcp_server treat_connection addr =
  ignore (signal sigpipe Signal_ignore);
  let server_sock = install_tcp_server_socket addr in
  while true do
    let client = restart_on_EINTR accept server_sock in
    treat_connection server_sock client
  done;;

(*-----------funcion de server del lab3-----------*)
let server () =
  if Array.length Sys.argv < 2 then
    begin  prerr_endline "Usage: client <port> <command> [arg1 ... argn]";
      exit 2;
    end;
  let port = int_of_string Sys.argv.(1) in
  let host = (gethostbyname("0.0.0.0")).h_addr_list.(0) in
  let addr = ADDR_INET (host, port) in
  let treat sock (client_sock, client_addr as client) =
    begin
      match client_addr with
      | ADDR_INET(caller, _) ->
        prerr_endline ("Connection from " ^ string_of_inet_addr caller);
      | ADDR_UNIX _ ->
        prerr_endline "Connection from the Unix domain (???)";
    end;
    let service (s, _) =
      dup2 s stdin; dup2 s stdout; dup2 s stderr; close s;
      (*este response debe cambiar para que lea el input de un client*)
      let input_client = read_line(); in
      (*luego se muestrar la respuesta generada por el input de un client*)
      let response = read_file(file_existence(input_client));
      in
      Unix.write stdout response 0 (String.length response);
    in
    double_fork_treatment sock service client in
  tcp_server treat addr;;
handle_unix_error server ();;
