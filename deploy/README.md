# VM deployment

This configuration runs the published GHCR image pinned by digest.
It does not build the application on the server.

The current image was built from commit `fdb3f88`.
`APP_VERSION` is a display value; the image digest selects the actual code.

## Deploy from the workstation

The SSH alias `devops-node01` must point to the deployment server.
Docker Engine and the Compose plugin must be installed there.

Create the destination directory and copy the configuration:

```bash
ssh devops-node01 'mkdir -p ~/deployments/voidbound-platform'
scp deploy/compose.yaml devops-node01:deployments/voidbound-platform/compose.yaml
```

Connect to the server:

```bash
ssh devops-node01
cd ~/deployments/voidbound-platform
sudo docker compose config --quiet
sudo docker compose pull
sudo docker compose up --detach --wait
sudo docker compose ps
```

## Access from the workstation

The application listens on the VM's localhost port 8000.

Open an SSH tunnel and leave it running:

```bash
ssh -N -L 127.0.0.1:8080:127.0.0.1:8000 \
  -o ExitOnForwardFailure=yes devops-node01
```

Open http://127.0.0.1:8080/docs in the workstation browser.
Closing the tunnel does not stop the application.

## Inspect or stop the deployment

Inside the deployment directory on the server:

```bash
sudo docker compose logs --tail 50 app
sudo docker compose down
```

`down` removes the deployment's container and network. The image remains.

## Update and rollback

Run these commands inside `~/deployments/voidbound-platform` on the VM.

### Save the current configuration

Before updating, preserve the working deployment configuration:

```bash
cp -i compose.yaml compose.rollback.yaml
```

If a backup already exists, confirm that it is safe to replace it.

### Deploy an update

Pull the desired release and inspect its digest:

```bash
sudo docker pull ghcr.io/zero9tracex4/voidbound-platform:sha-<commit>
sudo docker image inspect \
  ghcr.io/zero9tracex4/voidbound-platform:sha-<commit> \
  --format '{{index .RepoDigests 0}}'
```

Replace `<commit>` with the release's short Git commit ID.

Edit `compose.yaml`:
- Set `image` to the full image reference containing the new digest.
- Set `APP_VERSION` to the corresponding commit ID.

Apply and verify:

```bash
sudo docker compose config --quiet &&
sudo docker compose up --detach --wait --wait-timeout 60
```

```bash
sudo docker compose ps
curl --fail --silent --show-error http://127.0.0.1:8000/version
```

Confirm that the container is healthy and uses the intended digest.
Replacing this single container causes a brief interruption.
If the health check times out, investigate the logs; rollback is not automatic.

### Roll back

Restore the saved configuration and apply it:

```bash
cp compose.rollback.yaml compose.yaml
sudo docker compose config --quiet &&
sudo docker compose up --detach --wait --wait-timeout 60
```

Repeat the verification commands above.

The image digest selects the application and its dependencies.
`APP_VERSION` only controls the reported version; changing it alone
does not restore the previous image.

This procedure restores container configuration and image contents.
It does not undo changes to persistent data or database schemas.

## Deploy with the workstation script

From the repository root on the workstation:

```bash
bash scripts/deploy-remote.sh
```

The script validates the local deployment files, copies the Compose
configuration and deployment script to `devops-node01`, then runs the
deployment over SSH. Enter the VM's sudo password when prompted.

It deploys the current local files, including uncommitted changes.
It does not automatically select the newest published image: the digest
in `deploy/compose.yaml` determines which image runs.

The remote Compose file is overwritten. Preserve any server-only changes
or rollback configuration before running this command.
