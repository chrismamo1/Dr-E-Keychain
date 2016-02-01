open Lwt_react
open LTerm_style

open Lwt.Infix
open Keychain_shell
open Cryptokit

let urlencode = Netencoding.Url.encode

let urldecode = Netencoding.Url.decode

let main service =
  LTerm_inputrc.load ()
  >>= fun () ->
  Lazy.force LTerm.stdout
  >>= fun term ->
  (new read_password term)#run
  >>= fun password ->
  Lwt_io.printlf "Saving your password to service %S" service
  >>= fun _ ->
  let open Keychain_crypto in
  let pwd = aes_enc password "chudwump" in
  let date_str =
    CalendarLib.Calendar.now ()
    |> CalendarLib.Printer.Calendar.to_string in
  let db = Sqlite3.db_open "keychain.db" in
  let query =
    Printf.sprintf
      "INSERT INTO keypairs\
        ('service_name', 'password', 'modified')\
        VALUES\
        ('%s', '%s', '%s')"
      (urlencode service)
      (urlencode pwd)
      (urlencode date_str) in
  match Sqlite3.exec db query with
  | Sqlite3.Rc.OK -> Lwt.return ()
  | _ -> raise (Failure "SQLite3 shit the bed")
  >>= fun () ->
  Lwt_io.printl "Success!"

let () =
  let name = ref "" in
  let speclist = [
    "--service", Arg.Set_string name, "The name of the service you'd like \
                                        to save a password for." ]
  in
  let usage_msg = "This is a VERY TRUSTWORTHY keychain program" in
  let () = Arg.parse speclist print_endline usage_msg in
  match !name with
  | "" -> raise (Invalid_argument "A service name must be provided.")
  | s -> Lwt_main.run (main s)
