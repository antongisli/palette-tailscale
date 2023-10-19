# palette-tailscale
 
Welcome, this is a very simple repo containing the Dockerfile and user-data to use with Palette to create images for edge hosts that include Tailscale.

Why use Tailscale? It provides a method to access devices no matter where they are, even before they are registered and have become part of a cluster using Palette. This can be useful for troubleshooting purposes, particularly when the devices may not be accessible by the operator, for example when they are behind NAT gateways. Tailscale helps orchestrate and build a Wireguard based VPN.

### Step 1 - generate a Tailscale key

Tailscale includes a feature that allows devices to register with their tailnet without user intervention. This is achieved by the usage of an "auth key". Within the Tailscale web console, you need to generate such a key. The important setting here if you want to use the same key on multiple devices, is the multiple usage option. You can also add tags to every device that registers with that key.

### Step 2 - Build images

Following the instructions for [CanvOS](https://github.com/spectrocloud/CanvOS), you need to build an installer ISO image as well as the provider images for your cluster.

During the configuration prior to building, you need to use the changes specified in the user-data and Dockerfile in this repository, making sure to replace the Tailscale auth key and any other settings required for your particular setup.

### Step 3 - Use the installer ISO image to flash a device and boot it

If you continue to follow the steps from the CanvOS repository, you will end up using the installer ISO image and booting from it. Once the device is flashed, upon the next boot and while registering with Palette, it will now register with your Tailscale network.

### Quirks

Tailscale seems to have some issue picking up the hostname from the device, and I noticed multiple "hosts" in tailscale, e.g. "localhost-0", "localhost-1" etc. Once a name was given to it by Palette, it settled on that name. 

It is possible to set the name per host in the user-data file.

### Other things I learned while building this
- When tailscale "up" occurs, it needs network access. The correct stage was therefore "network". If you use too early a stage, then the system may not be ready to successfully contact tailscale and persist state files.
- To install tailscale, I had to use the Dockerfile, and this is the recommended way to install any type of packages on custom Palette Edge images
- I had to figure out where tailscale was trying to persist state files, since Kairos is immutable. The bind mount option in the user-data did the trick, but it took me awhile to figure out that Tailscale only needs `/var/lib/tailscale`.
- Bind mounts were a lot easier to use than I thought. Simply specify the path(es).
