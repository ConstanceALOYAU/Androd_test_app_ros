
# Android Test App ROS

Ce dépôt contient une application de test ROS (Robot Operating System) développée pour Android. L'objectif de ce projet est de permettre une interaction facile entre un appareil Android et un environnement ROS 2, en utilisant des conteneurs Docker pour simplifier le déploiement et la gestion de l'environnement.

## Table des Matières

- [Prérequis](#prérequis)
- [Installation](#installation)
- [Utilisation](#utilisation)
- [Développement avec VSCode](#développement-avec-vscode)
- [Contribution](#contribution)
- [Licence](#licence)

## Prérequis

Avant de commencer, assurez-vous que les outils et logiciels suivants sont installés sur votre système :

- [Docker](https://docs.docker.com/get-docker/)
- [Docker Compose](https://docs.docker.com/compose/install/)
- [Git](https://git-scm.com/)
- [Visual Studio Code](https://code.visualstudio.com/) avec l'extension [Remote - Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)

## Installation

1. **Cloner le dépôt** :

   Clonez ce dépôt sur votre machine locale en utilisant Git :

   ```bash
   git clone https://github.com/ConstanceALOYAU/Android_test_app_ros.git
   cd Android_test_app_ros
   ```

2. **Construire l'image Docker** :

   Utilisez Docker Compose pour construire l'image Docker qui contient l'environnement ROS 2 et les outils nécessaires :

   ```bash
   docker-compose build
   ```

3. **Lancer le conteneur Docker** :

   Démarrez le conteneur Docker avec Docker Compose :

   ```bash
   docker-compose up
   ```

   Cela démarrera le conteneur et préparera l'environnement pour le développement et les tests.

## Utilisation

Une fois le conteneur Docker en cours d'exécution, vous pouvez interagir avec l'environnement ROS 2 en utilisant les commandes ROS standard.

### Exécuter un nœud ROS 2

Pour exécuter un nœud ROS 2 à l'intérieur du conteneur, suivez ces étapes :

1. Attachez-vous au conteneur en cours d'exécution :

   ```bash
   docker exec -it <nom_du_conteneur> bash
   ```

   Remplacez `<nom_du_conteneur>` par le nom ou l'ID du conteneur en cours d'exécution.

2. Sourcez l'environnement ROS 2 et exécutez le nœud :

   ```bash
   source /opt/ros/jazzy/setup.bash
   ros2 run <nom_du_package> <nom_du_noeud>
   ```

   Remplacez `<nom_du_package>` et `<nom_du_noeud>` par les noms appropriés pour votre application.

## Développement avec VSCode

Le projet est configuré pour être utilisé avec Visual Studio Code et l'extension Remote - Containers. Cela vous permet de développer et de tester directement à l'intérieur du conteneur Docker.

### Ouvrir le projet dans un conteneur

1. Ouvrez Visual Studio Code et utilisez la commande **Remote-Containers: Open Folder in Container...** pour ouvrir ce projet dans le conteneur Docker.
   
2. Vous pouvez maintenant éditer le code, exécuter des commandes ROS 2, et tester l'application directement depuis VSCode.

## Contribution

Les contributions sont les bienvenues ! Si vous souhaitez contribuer à ce projet, veuillez suivre ces étapes :

1. Forkez ce dépôt.
2. Créez une branche pour vos modifications : `git checkout -b ma-branche`.
3. Commitez vos modifications : `git commit -m 'Ajouter une nouvelle fonctionnalité'`.
4. Poussez vos modifications sur votre dépôt forké : `git push origin ma-branche`.
5. Ouvrez une Pull Request sur ce dépôt.

## Licence

Ce projet est sous licence MIT. Consultez le fichier [LICENSE](LICENSE) pour plus de détails.
