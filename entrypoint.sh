#!/bin/bash

# Vérifier si /dev/video0 est accessible
if [ ! -c /dev/video0 ]; then
  echo "Erreur: /dev/video0 n'est pas disponible dans le conteneur."
  exit 1
fi

# Démarrer ROS 2 ou toute autre configuration
source /opt/ros/$ROSDISTRO/setup.bash
echo "source /opt/ros/$ROSDISTRO/setup.bash" >> /home/$USER/.bashrc
# Exécuter la commande passée en arguments (si aucune commande n'est passée, exécuter bash)
if [ -z "$1" ]; then
  tail -f /dev/null  # Garde le conteneur en cours d'exécution
else
  exec "$@"
fi

