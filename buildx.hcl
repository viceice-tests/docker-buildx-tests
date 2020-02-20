group "default" {
	targets = ["renovate", "renovate-slim"]
}

target "base" {
  cache-to = ["type=local,dest=tmp/docker,mode=max"]
  target = "base"
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
  target = "slim"
}
