#!/usr/bin/env bash
set -euo pipefail

compose_file="${1:-}"

if [[ -z "$compose_file" ]]; then
    echo "Usage: $0 <compose-file>" >&2
    exit 2
fi

if [[ ! -f "$compose_file" ]]; then
    echo "Error: Compose file not found: $compose_file" >&2
    exit 1
fi

printf 'Deployment configuration: %s\n' "$compose_file"

printf 'Validating Compose configuration...\n'
docker compose -f "$compose_file" config --quiet

printf 'Pulling deployment image...\n'
docker compose -f "$compose_file" pull

printf 'Applying deployment and waiting for health...\n'
docker compose -f "$compose_file" up \
    --detach --wait --wait-timeout 60

docker compose -f "$compose_file" ps
printf 'Deployment completed successfully.\n'
