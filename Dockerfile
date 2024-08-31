# Utiliser Ubuntu 24.04 comme image de base
FROM ubuntu:24.04

# Définir la distribution ROS
ARG ROSDISTRO="jazzy"
ENV ROSDISTRO=$ROSDISTRO

RUN apt-get update && apt-get install -y \
    apt-utils \
    locales \
    curl \
    iproute2 \
    gnupg2 \
    lsb-release \
    software-properties-common \
    sudo \
    openssh-server \
    net-tools \
    iputils-ping \
    vim \
    nano \
    wget \
    build-essential \
    v4l-utils \
    ffmpeg \
    git \
    systemd \
    dbus \
    systemd-sysv && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN locale-gen en_US en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
RUN update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8

RUN curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/ros2.list > /dev/null

RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y \
    ros-dev-tools \
    ros-$ROSDISTRO-ros-base \
    python3-argcomplete \
    python3-colcon-common-extensions \
    python3-rosdep \
    python3-vcstool \
    ros-$ROSDISTRO-cv-bridge \
    ros-$ROSDISTRO-rosbridge-server \ 
    gstreamer1.0-plugins-bad \
    gstreamer1.0-plugins-ugly \ 
    gstreamer1.0-libav && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN rosdep init && rosdep update

RUN useradd -m ros && echo "ros:ros" | chpasswd && adduser ros sudo
RUN usermod -a -G irc ros
RUN usermod -a -G video ros
RUN mkdir /var/run/sshd && echo 'ros ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

RUN mkdir -p /home/ros/ros2_ws/src/android_ros_test
RUN ls -lah /home/ros/ros2_ws/src/android_ros_test
COPY  FILE/ /home/ros/ros2_ws/src/android_ros_test/

RUN ls -lah /home/ros/ros2_ws/src/android_ros_test
RUN chown -R ros:ros /home/ros/ros2_ws


COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

USER ros

RUN /bin/bash -c "source /opt/ros/$ROSDISTRO/setup.bash && cd /home/ros/ros2_ws && colcon build"
ENTRYPOINT ["/entrypoint.sh"]
CMD ["bash"]
