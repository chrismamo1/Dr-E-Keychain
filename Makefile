all: keychain.native

keychain.native: keychain.ml
	ocamlbuild $@
