#!/usr/bin/env bash
set -euo pipefail

edge_host="${EDGE_HOST:-edge}"
remote_dir="/srv/voidbound/platform"

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd -- "$script_dir/.." && pwd)"

local_compose="$repo_root/deploy/compose.edge.yaml"
local_deploy_script="$repo_root/scripts/deploy.sh"

remote_compose="$remote_dir/compose.yaml"
remote_deploy_script="$remote_dir/deploy.sh"

printf 'Edge host: %s\n' "$edge_host"
printf 'Validating local edge configuration...\n'

docker compose -f "$local_compose" config --quiet

printf 'Uploading deployment configuration...\n'

scp \
    "$local_compose" \
    "$edge_host:${remote_compose}.new"

printf 'Uploading deployment script...\n'

scp \
    "$local_deploy_script" \
    "$edge_host:${remote_deploy_script}.new"

printf 'Activating uploaded files...\n'

ssh "$edge_host" \
    "chmod 0644 '${remote_compose}.new' &&
     chmod 0755 '${remote_deploy_script}.new' &&
     mv '${remote_compose}.new' '${remote_compose}' &&
     mv '${remote_deploy_script}.new' '${remote_deploy_script}'"

printf 'Deploying on %s...\n' "$edge_host"

ssh -t "$edge_host" \
    "sudo '${remote_deploy_script}' '${remote_compose}'"

printf 'Edge deployment completed successfully.\n'
