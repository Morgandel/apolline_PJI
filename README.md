# Pji : Le docker compose

## Les containers
Pour ce Pji nous avons mis en place différent container docker à l'aide de docker-compose.
- grafana : https://hub.docker.com/r/grafana/grafana/
- influxdb : https://hub.docker.com/_/influxdb/
- jupyterhub : https://hub.docker.com/r/jupyterhub/jupyterhub/
- jupyter-datascience-notebook : https://hub.docker.com/r/jupyter/datascience-notebook/

## Les problèmes rencontrés

Nous avons testé grafana, influxdb et jupyter-datascience-notebook et ils fonctionnent tous les trois.
Cependant, nous avons de gros problèmes sur jupyterhub. N'arrivant pas à nous connecter avec les PAM sur jupyterhub nous avons dû importer nos identifiants de la machine dans le container à l'aide de volumes dans le fichier docker-compose.yml.

Nous sommes maintenant confrontés au lancement du serveur jupyterhub qui ne se lance pas. Car le spawner n'arrive pas à s’exécuter.
Et nous obtenons cette erreur-ci :

    500 : Internal Server Error
    Spawner failed to start [status=1]. The logs for axel may contain details.
    You can try restarting your server from the home page.

En regardant les logs, on observe qu'il n'arrive pas à importer notebook dans python.On a donc essayé de le rajouter l'installation de jupiter dans le fichier de build des containers, mais rien n'a changé.En cherchant un peu sur le web sur les singles user qui ne peuvent pas être spawner par jupyterhub.

## Une solution ?

Nous avons rajouté une image d'un notebook jupyter au projet (le datascience-notebook) afin d'avoir une image pour les instances de singleuser.
On a réalisé plusieurs modifications sur le fichier Dockerfile ainsi que dans le docker-compose.yml
Notre dernière modification du docker-compose était :

        environment:
            # All containers will join this network
            DOCKER_NETWORK_NAME: jupyterhub-network
            # JupyterHub will spawn this Notebook image for users
            DOCKER_NOTEBOOK_IMAGE: 'jupyter/datascience-notebook'
            # Notebook directory inside user image
            DOCKER_NOTEBOOK_DIR: /home/jovyan/work
            # Using this run command (optional)
            DOCKER_SPAWN_CMD: start-singleuser.sh

Ces variables d'environnement servent à identifier l'image docker du notebook et le script pour spawner ces singleuser. Cependant ces commandes n'ont pas l'air d'avoir agi sur notre projet.

On a également ajouté des lignes concernant le spawner dans le jupyterhub_config situé dans le dossier data.
Ces éléments ont été rajoutés ou modifiés pour un changement de spawner(Utilisation de docker spawner : https://github.com/jupyterhub/jupyterhub/issues/879)

    c.JupyterHub.spawner_class = 'dockerspawner.SystemUserSpawner'
    c.DockerSpawner.container_image = 'jupyter/datascience-notebook:latest'
    c.DockerSpawner.use_internal_ip = True
    c.DockerSpawner.debug = True


## Liens supplémentaires
Voici plusieurs liens que nous avons consulté:
  - Une demo jupyterhub sur docker dont on s'est inspiré: https://github.com/jupyterhub/jupyterhub-deploy-docker
  - Le docker spawner : https://github.com/jupyterhub/dockerspawner
