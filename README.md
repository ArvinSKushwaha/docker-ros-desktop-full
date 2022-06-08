# ROS Noetic - VNC-enabled Docker container
Docker container featuring a full ROS Noetic Ubuntu Focal installation. Heavily based on [bpinaya's project](https://github.com/bpinaya/robond-docker). Read the README of the [repository this is a fork of](https://github.com/fbottarel/docker-ros-desktop-full) for more information. This rest of this README will consist of information on how to setup this docker container.

## Table of Contents
1. [Installing Docker](#installing-docker)
2. [Pulling the Image](#pulling-the-image)
3. [Creating the Container](#creating-the-container)
4. [Running the Container](#running-the-container)
5. [Stopping or Killing the Container](#stopping-or-killing-the-container)
6. [Updating the Container](#updating-the-container)
7. [Helper Command Reference](#helper-command-reference)

## Installing Docker

There is no way I could possibly explain how to install Docker any better than the official documentation itself so [here ya go](https://docs.docker.com/get-docker/).

Note that below I will be ommitting the usage of `sudo` as a prefix for the docker command. In some cases, using `sudo docker` may be necessary.

## Pulling the Image

### From GitHub

1. Clone the repository. GitHub CLI or Git, both are great!
2. Change directory into the appropriate path.
3. Build the docker image.
```bash
$ docker build -t <tag-name> . # The <tag-name> is completely up to you.
```

This command will take time. Update, upgrading, and installing `ros-noetic-desktop-full`
takes approximately 30 minutes. The rest of it is rather fast.

### From Docker Hub

As I have not yet added the dockerfile to Docker Hub, this is not possible.

## Creating the Container

To create a container from this image, we use the `docker run` command. This command is
highly configurable, so choose whatever helps your workflow the best! Here, `<tag-name>` is either the Docker Hub image name (once it's on Docker Hub) or whatever you chose [above](#from-github)

```bash
$ docker run [-p <host-novnc-port>:80] \ # Port 80 is where NoVNC can be accessed from
	[-p <host-vnc-port>:5900] \ # Port 5900 is where VNC can be accessed from
	[--name <cotainer-name>] \ # However you want to reference the container in the future
	-d # Runs the container in detached mode (so it has persistent state)
	 <tag-name>
```

I personally suggest `-p 6080:80` and `-p 5900:5900` as the host-container port combinations for NoVNC and VNC, respectively. To then access NoVNC, pull up `http://localhost:<host-no-vnc>`. Otherwise, for VNC, install a VNC client and use `localhost:<host-vnc-port>` as the address.

### Running the Container

Check if the docker container is running using `docker ps -a`. If the docker container in question is not running. Start it using `docker start <container-name>`. If you chose not to name the container, use `docker start <container-id>`. This ID should be given in the third(?) column of `docker ps -a`.

Now, we can enter the "terminal" (or use VNC is preferred). To do this, just execute the following command:

```bash
$ docker exec -it <container-name>
root@numbers69420:/root# ./login  # This here is a nice convenience script that I've written for no real reason :)
ubuntu@id42064:~$ # tada now you're logged in as ubuntu and at /home/ubuntu
# ...
# to exit
ubuntu@id42064:~$ exit
root@numbers69420:/root# exit
```

Again, replace `<container-name>` here with the id if needed. Also, see [helper command reference](#helper-command-reference).

### Stopping or Killing the Container

If the container is unresponsive or you're done with using the container and want to shut it down, use the following command:

```bash
$ docker stop <container-name> # if shutting down nicely
$ docker kill <container-name> # or forcefully
```

### Updating the container

If a brand-new, sparkly docker image comes out, and you wish to update, unfortunately, my current understanding is that you would have to delete the previous container and user the new image to create a new container. Of course, that's rather dismal, so the `docker cp` command may come in handy. Essentially, it just lets you copy data from docker to your host.

```bash
$ docker cp <src-path> <dest-path>
```

I believe `<src-path>` and `<dest-path>` must be such that one is on the host and one is in the container. They are given as follows:

* For a path on the host, it is simply given as usual: `</path/to/file>`. It must be an absolute path and may be either a file or a directory
* For a path in the container, it is given as `<container-name>:</path/to/file>`. Similarly, this must be an absolute path and can be either a file or a directory.

See [the docs](https://docs.docker.com/engine/reference/commandline/cp/) for more (and better) info.

## Helper Command Reference

- `/root/login`: This just changes the current user to `ubuntu` and move you to `/home/ubuntu`
- `/home/ubuntu/install_dev_tools`: This just installs some useful tools like `nvim` and `vim`. This is
	run already when the image was built, so you don't really need to call it, except to update neovim and vim.
- `/home/ubuntu/upgrade`: This just goes ahead and upgrades all packages on the system. It's a nice little `apt update; apt upgrade` wrapper.
- `rossource`: This command can only be called when `ubuntu` is the current user. It sources the `$ROS_WS/devel/setup.bash` file, which by default is
        located at `/home/ubuntu/ros_ws/devel/setup.bash`

## Acknowledgements

- This image is based on [FCWU image](https://github.com/fcwu/docker-ubuntu-vnc-desktop) , that has the support for the VNC server with browser support, so no VNC client is needed, kudos to him!
- A significant portion of this docker container and README is based off of [fbottarel's repo](https://github.com/fbottarel/docker-ros-desktop-full) and [bpinaya's repo](https://github.com/bpinaya/robond-docker)
