#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

printf 'Checking deployment files...\n'
bash -n scripts/deploy.sh
docker compose -f deploy/compose.yaml config --quiet

printf 'Copying deployment files to devops-node01...\n'
ssh devops-node01 'mkdir -p ~/deployments/voidbound-platform'

scp deploy/compose.yaml scripts/deploy.sh \
    devops-node01:deployments/voidbound-platform/

printf 'Running deployment on devops-node01...\n'
ssh -t devops-node01 \
    'cd ~/deployments/voidbound-platform && sudo bash ./deploy.sh ./compose.yaml'
