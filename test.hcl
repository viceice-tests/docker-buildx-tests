group "default" {
  targets = ["test"]
}

target "settings" {
  platform = ["linux/amd64"]
}

target "test" {
  inherits = ["settings"]
  target   = "slim"
}
