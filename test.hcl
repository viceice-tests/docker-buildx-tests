group "default" {
  targets = ["test"]
}

target "settings" {
  platforms = ["linux/amd64"]
}

target "test" {
  inherits = ["settings"]
  target   = "slim"
}
