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
target "pkg_no-cache" {
  inherits = ["test"]
  tags     = ["docker.pkg.github.com/${REPO}/test:no-cache"]
  output   = ["type=docker"]
}

target "pkg_inline" {
  inherits   = ["test"]
  cache-from = ["type=registry,ref=docker.pkg.github.com/${REPO}/test:inline"]
  cache-to   = ["type=inline"]
  tags       = ["docker.pkg.github.com/${REPO}/test:inline"]
  output     = ["type=registry"]
}

target "pkg_inline-max" {
  inherits   = ["test"]
  cache-from = ["type=registry,ref=docker.pkg.github.com/${REPO}/test:inline-max,mode=max"]
  cache-to   = ["type=inline"]
  tags       = ["docker.pkg.github.com/${REPO}/test:inline-max"]
  output     = ["type=registry"]
}

target "ghcr_no-cache" {
  inherits = ["test"]
  tags     = ["ghcr.io/${OWNER}/test:no-cache"]
}

target "ghcr_inline" {
  inherits   = ["test"]
  cache-from = ["type=registry,ref=ghcr.io/${OWNER}/test:inline"]
  cache-to   = ["type=inline"]
  tags       = ["ghcr.io/${OWNER}/test:inline"]
}

target "ghcr_inline-max" {
  inherits   = ["test"]
  cache-from = ["type=registry,ref=ghcr.io/${OWNER}/test:inline-max,mode=max"]
  cache-to   = ["type=inline"]
  tags       = ["ghcr.io/${OWNER}/test:inline-max"]
}

target "ghcr_reg" {
  inherits   = ["test"]
  cache-from = ["type=registry,ref=ghcr.io/${OWNER}/cache:reg"]
  cache-to   = ["type=registry,ref=ghcr.io/${OWNER}/cache:reg"]
  tags       = ["ghcr.io/${OWNER}/test:reg"]
}

target "ghcr_reg-max" {
  inherits   = ["test"]
  cache-from = ["type=registry,ref=ghcr.io/${OWNER}/cache:reg-max"]
  cache-to   = ["type=registry,ref=ghcr.io/${OWNER}/cache:reg-max,mode=max"]
  tags       = ["ghcr.io/${OWNER}/test:reg-max"]
}
