all: keychain.native

keychain.native: keychain.ml keychain_shell.ml
	ocamlbuild -pkgs lwt.react,lambda-term $@
