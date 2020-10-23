variable "OWNER" {
	default = "viceice-tests"
}
variable "REPO" {
	default = "viceice-tests/docker-buildx-tests"
}

group "default" {
  targets = ["test"]
}

target "settings" {
  platforms = ["linux/amd64"]
}

target "test" {
  inherits = ["settings"]
  target   = "slim"
  output   = ["type=registry"]
}

target "ghcr_inline" {
  inherits   = ["test"]
  cache-from = ["type=registry,ref=ghcr.io/${OWNER}/test:inline"]
  cache-to   = ["type=inline"]
  tags       = ["ghcr.io/${OWNER}/test:inline"]
}

target "ghcr_reg" {
  inherits   = ["test"]
  cache-from = ["type=registry,ref=ghcr.io/${OWNER}/cache:reg_cache"]
  cache-to   = ["type=registry,ref=ghcr.io/${OWNER}/cache:reg_cache,mode=max"]
  tags       = ["docker.pkg.github.com/${REPO}/test:reg", "ghcr.io/${OWNER}/test"]
}
