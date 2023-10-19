# add the following to the Dockerfile
RUN curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/kinetic.noarmor.gpg | sudo tee /usr/share/keyrings/tailscale-archive-keyring.gpg >/dev/null
RUN curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/kinetic.tailscale-keyring.list | sudo tee /etc/apt/sources.list.d/tailscale.list
RUN sudo apt-get update && sudo apt-get install tailscale -y
