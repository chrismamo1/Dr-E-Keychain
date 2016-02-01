open Lwt_react
open LTerm_style

open Lwt.Infix
open Keychain_shell

let main () =
  LTerm_inputrc.load ()
  >>= fun () ->
  Lazy.force LTerm.stdout
  >>= fun term ->
  (new read_password term)#run
  >>= fun password ->
  Lwt_io.printlf "You typed %S" password

let () = Lwt_main.run (main ())
