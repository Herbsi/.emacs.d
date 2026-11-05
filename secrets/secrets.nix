let
  # Keep in sync with `herbsi-age-recipient' in lisp/herbsi-age.el.
  key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILA0+MyUCeN/XMZPefsTBAe6XpSXoioIiJtiZTJZW/Mv";
in {
  "tags.age".publicKeys = [ key ];
  "beancount.age".publicKeys = [ key ];
  "templates.age".publicKeys = [ key ];
}