group "default" {
	targets = ["renovate", "renovate-slim"]
}

target "base" {
  cache-to = ["type=local,dest=tmp/docker,mode=max"]
  target = "base"
}

target "settings" {
  platform = ["linux/amd64"]
}

target "cache" {
  cache-from = ["type=local,src=tmp/docker"]
  cache-to = ["type=local,dest=tmp/docker,mode=max"]
}

target "renovate-slim" {
	inherits = ["cache"],
  tags = ["renovate/renovate:slim"]
  target = "slim"
}

target "renovate" {
  inherits = ["cache"],
  tags = ["renovate/renovate"]
  target = "full"
}

target "test" {
  inherits = ["settings"],
  target = "slim"
}

target "reg-test" {
  inherits = ["settings"],
  target = "slim"
  cache-from = ["type=registry;ref=docker.pkg.github.com/viceice-tests/docker-buildx-tests/test:cache-slim"]
  cache-to = ["type=registry;ref=docker.pkg.github.com/viceice-tests/docker-buildx-tests/test:cache-slim,mode=max"]
}
