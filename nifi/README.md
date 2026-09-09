# Conteneur NiFi (séquence 07 du cours)

## Démarrage

NiFi est un service du `docker-compose.yml` — rien à builder, l'image
officielle `apache/nifi:2.11.0` est utilisée telle quelle :

```bash
docker compose up -d          # ou : docker compose up -d nifi
# UI : https://localhost:8443/nifi
```

NiFi 2.x impose le **HTTPS** (certificat auto-signé) : au premier accès,
le navigateur propose « accepter le risque » — accepter une fois.

## Volumes montés

| Chemin hôte | Chemin conteneur | Rôle |
|---|---|---|
| `nifi/input/` | `/opt/nifi/input` | répertoire d'entrée des fichiers à ingérer (processeur **GetFile** du TP 07) |
| `nifi/hadoop/` | `/opt/nifi/hadoop` | configuration Hadoop du cluster pour **PutHDFS** (`core-site.xml`, `hdfs-site.xml`) |

## Préparer `nifi/hadoop/`

PutHDFS a besoin de la configuration Hadoop du cluster. Copier les deux
fichiers de `config/` (attention : la version montée dans NiFi doit
résoudre `hadoop-master` — le `fs.defaultFS` pointe sur le nom du
conteneur, joignable depuis NiFi sur le réseau `hadoop-net`) :

```bash
mkdir -p nifi/hadoop nifi/input
cp config/core-site.xml nifi/hadoop/
cp config/hdfs-site.xml nifi/hadoop/
```

Puis dans le TP 07, le processeur PutHDFS est configuré avec :
`Hadoop Configuration File Resources` =
`/opt/nifi/hadoop/core-site.xml,/opt/nifi/hadoop/hdfs-site.xml`.

## Pourquoi la branche 2.x ?

Le cluster local tourne sur **Hadoop 3.3.6** : NiFi 2.x (Java 21 embarqué
dans l'image, client Hadoop 3.x) est le couple cohérent — l'argument
d'ancienne note « rester en 1.x pour un Hadoop 2.x » ne s'applique plus.

## Données

Déposer le CSV Spotify à ingérer directement dans `nifi/input/` :

```bash
cp /chemin/vers/Spotify_Most_Streamed_Songs.csv nifi/input/
```
