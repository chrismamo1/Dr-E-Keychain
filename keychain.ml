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
  Lwt.return @@ Printf.printf "Success!\n"

let () =
  let common_words =
    Keychain_make_passwords.load_common_words () in
  let name = ref "" in
  let make_pwd = ref false in
  let speclist = [
    "--service", Arg.Set_string name, "The name of the service you'd like \
                                        to save a password for.";
    "--make-password", Arg.Set make_pwd, "Flag to generate a password" ]
  in
  let usage_msg = "This is a VERY TRUSTWORTHY keychain program" in
  let () = Arg.parse speclist print_endline usage_msg in
  match !name,!make_pwd with
  | "", true ->
      let combo = Keychain_make_passwords.generate_combo common_words 4 in
      let () =
        for i = 0 to 3 do
          Printf.printf "%s " (List.nth combo i);
        done;
      in
      output_string stdout "\n"
  | "",false -> raise (Invalid_argument "A service name must be provided.")
  | s,_ -> Lwt_main.run (main s)
