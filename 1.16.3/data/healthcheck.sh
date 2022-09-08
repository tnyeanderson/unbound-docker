#!/bin/bash

# Exit on error
set -e

# If the environment variable isn't set for some reason, use the default
# Should be set in the Dockerfile anyway
# https://github.com/MatthewVance/unbound-docker/pull/111
HEALTHCHECK_DOMAIN=${HEALTHCHECK_DOMAIN:-cloudflare.com}

# First clear the cache. This ensures that the healthcheck fails if the
# name cannot be resolved.
# https://github.com/MatthewVance/unbound-docker/issues/112
unbound-control flush "${HEALTHCHECK_DOMAIN}" >/dev/null

# Perform the test lookup
drill @127.0.0.1 "${HEALTHCHECK_DOMAIN}" || exit 1
