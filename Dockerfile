# Utiliser Ubuntu 24.04 comme image de base
FROM ubuntu:24.04

# Définir la distribution ROS
ARG ROSDISTRO="jazzy"
ENV ROSDISTRO=$ROSDISTRO

# Mettre à jour le système et installer les paquets requis pour un serveur Ubuntu
RUN apt-get update && apt-get install -y \
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

# Configurer les paramètres régionaux
RUN locale-gen en_US en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
RUN update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8

# Ajouter le dépôt ROS 2
RUN curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/ros2.list > /dev/null

# Mettre à jour le système et installer ROS 2 Jazzy et outils supplémentaires
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y \
    ros-dev-tools \
    ros-$ROSDISTRO-ros-base \
    python3-argcomplete \
    python3-colcon-common-extensions \
    python3-rosdep \
    python3-vcstool \
    ros-$ROSDISTRO-cv-bridge \
    ros-$ROSDISTRO-rosbridge-server && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Initialiser rosdep
RUN rosdep init && rosdep update

# Créer un utilisateur "ros" avec les droits sudo
RUN useradd -m ros && echo "ros:ros" | chpasswd && adduser ros sudo
RUN usermod -a -G irc ros

# Configurer SSH
RUN mkdir /var/run/sshd && echo 'ros ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Créer le répertoire de travail ROS 2
RUN mkdir -p /home/ros/ros2_ws/src

# Copier les fichiers du nœud Android ROS 2 dans le répertoire de travail
COPY APP/android_test /home/ros/ros2_ws/src/android_test

# Changer le propriétaire des fichiers copiés
RUN chown -R ros:ros /home/ros/ros2_ws

# Définir l'utilisateur par défaut comme "ros"
USER ros

# Construire le workspace ROS 2
RUN /bin/bash -c "source /opt/ros/$ROSDISTRO/setup.bash && cd /home/ros/ros2_ws && colcon build"

# Copier le script d'entrée dans le conteneur
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Définir le point d'entrée
ENTRYPOINT ["/entrypoint.sh"]
CMD ["bash"]
