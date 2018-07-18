# ROSpace - Spaceport

This repository contains a few scripts that will help you get started
hacking and running ROSpace. Inspiration for those scripts comes from
[rosdocked](https://github.com/jbohren/rosdocked)

### 1. build.sh

-  Creates the ROS folder structure and clones all the relevant git
   repositories.
-  Start the docker container build process with the correct environment
   variables.

### 2. Dockerfile
The build recipe for the ROSpace image:
-  Installs the dependencies
-  Installs ROS
-  Installs PyKEP
-  Mirrors your local user in the image

### 3. entrypoint.sh
Startup script that is run on each new container instance.
-  Configures the workspace
-  Builds the simulator
-  Initialises environment variables (setup.bash)

### 4. run.sh
-  Creates a new container instance
-  Connects your local workspace with the container