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
