open Lwt_react
open LTerm_style

class read_password term = object(self)
  inherit LTerm_read_line.read_password () as super
  inherit [Zed_utf8.t] LTerm_read_line.term term

  method send_action = function
    | LTerm_read_line.Break ->
        (* Ignore Ctrl+C *)
        ()
    | action ->
        super#send_action action

  initializer
    self#set_prompt (S.const (LTerm_text.of_string "Type a password: "))
end
