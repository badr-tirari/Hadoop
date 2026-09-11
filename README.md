# Hadoop Learning Cluster

Stack Hadoop complète pour l'apprentissage, déployable en local ou sur VM.

## Versions

| Composant | Version | URL de téléchargement |
|-----------|---------|----------------------|
| OS | Debian 12 (bookworm) | `debian:bookworm-slim` (Docker Hub) |
| Java | OpenJDK 17.0.14 | `java-17-openjdk-jdk-headless` |
| Hadoop | 3.3.6 | [dlcdn.apache.org](https://dlcdn.apache.org/hadoop/common/hadoop-3.3.6/hadoop-3.3.6.tar.gz) |
| HBase | 2.5.15 | [dlcdn.apache.org](https://dlcdn.apache.org/hbase/2.5.15/hbase-2.5.15-hadoop3-bin.tar.gz) |
| ZooKeeper | 3.8.6 | [dlcdn.apache.org](https://dlcdn.apache.org/zookeeper/zookeeper-3.8.6/apache-zookeeper-3.8.6-bin.tar.gz) |
| Hive | 4.1.0 | [archive.apache.org](https://archive.apache.org/dist/hive/hive-4.1.0/apache-hive-4.1.0-bin.tar.gz) — 4.2 exige Java 21, l'image tourne en Java 17 |
| NiFi | 2.11.0 | `apache/nifi:2.11.0` (Docker Hub, conteneur dédié) |
| Python | 3.11 | pip : pandas, matplotlib, happybase, thriftpy2 |

## Prérequis

- Docker Engine 24+ et Docker Compose v2+
- 5+ GB RAM recommandés (master 1.8g + 2 slaves 0.8g + NiFi 1g)

## Quick start

```bash
# Build de l'image (~5-10 min selon la connexion)
docker compose build

# Lancement des 4 conteneurs (3 cluster + NiFi) (froids : SSH uniquement)
docker compose up -d

# Vérification
docker compose ps
```

### Premiers pas dans le cluster

Les conteneurs démarrent sans aucun service Hadoop/HBase actif.
Vous devez lancer les services manuellement depuis le master.

```bash
# 1. Accéder au master
./bash_hadoop_master.sh
# ou : docker exec -it hadoop-master bash

# 2. Tout en un (ZooKeeper → HDFS → YARN → History → HBase → Thrift → REST → Hive)
./start-all.sh

# Ou étape par étape :
./start-zookeeper.sh    # ZooKeeper (coordination)
./start-dfs.sh          # HDFS (NameNode + DataNodes)
./start-yarn.sh         # YARN (ResourceManager + NodeManagers)
./start-jobhistory.sh   # MapReduce JobHistory (optionnel)
./start-hbase.sh        # HBase (Master + RegionServers)
./start-thrift.sh       # HBase Thrift API (optionnel)
./start-rest.sh         # HBase REST API (optionnel)
./start-hive.sh         # HiveServer2 (SQL sur HDFS)

# 3. Vérifier les processus
jps

# 4. Lancer un MapReduce wordcount
cd /home/src/wordcount
./run_mr.sh data.txt mapper.py reducer.py wordcount
```

Pour arrêter les services, depuis le master :

```bash
# Arrêter tous les services Java
pkill -f 'hbase' 2>/dev/null;
pkill -f 'zookeeper' 2>/dev/null
pkill -f 'ResourceManager' 2>/dev/null;
pkill -f 'NodeManager' 2>/dev/null
pkill -f 'NameNode' 2>/dev/null;
pkill -f 'DataNode' 2>/dev/null
pkill -f 'SecondaryNameNode' 2>/dev/null;
pkill -f 'historyserver' 2>/dev/null
pkill -f 'hiveserver2' 2>/dev/null
```

Puis arrêter les conteneurs depuis l'hôte :

```bash
docker compose down
```

## Services

### Master (`hadoop-master`)

| Processus | Rôle | Port |
|-----------|------|------|
| `NameNode` | Gestionnaire HDFS (métadonnées) | 9870 (UI), 9000 (RPC) |
| `SecondaryNameNode` | Checkpoint du NameNode | 9868 (UI) |
| `DataNode` | Stockage HDFS local | — |
| `ResourceManager` | Ordonnanceur YARN | 8088 (UI) |
| `NodeManager` | Exécuteur YARN local | 8042 (UI) |
| `HMaster` | Gestionnaire HBase | 16010 (UI) |
| `HRegionServer` | Stockage HBase local | — |
| `HQuorumPeer` | Serveur ZooKeeper | 2181 |
| `ThriftServer` | API Thrift (happybase) | 9090 |
| `RESTServer` | API REST (Power BI) | 9091 |
| `HiveServer2` (RunJar) | SQL sur HDFS (Metastore Derby) | 10000 (JDBC), 10002 (UI) |

### Conteneur NiFi (`hadoop-nifi`)

| Processus | Rôle | Port |
|-----------|------|------|
| NiFi (Java 21) | Ingestion visuelle de flux (GetFile → ConvertRecord → PutFile) | 8443 (UI, **https**) |

> NiFi vit dans son propre conteneur (image officielle `apache/nifi`), sur le
> réseau `hadoop-net`. Volumes : `nifi/input/` (fichiers à ingérer),
> `nifi/output/` (déposé par `PutFile` ; monté aussi dans le master sous
> `/home/staging`, pour `hdfs dfs -moveFromLocal`), `nifi/errors/` (relations
> `failure` câblées) et `nifi/hadoop/` (conf Hadoop) — voir
> [`nifi/README.md`](nifi/README.md).
>
> **L'image officielle n'embarque aucun bundle Hadoop** : `PutHDFS` n'existe
> pas dans cette distribution (118 NAR, 0 NAR hdfs). Le flux s'arrête donc à
> `PutFile` et le dépôt dans HDFS se fait à la main depuis le master — choix
> pédagogique du cours, pas un oubli (cf. EX/07 du cours).

> 🔑 **Une fois par clone** : `cp nifi/credentials.env.example
> nifi/credentials.env`, puis fixez le mot de passe (**12 caractères
> minimum**). Sans ce fichier — ou avec un mot de passe trop court, ce qui
> revient exactement au même — NiFi négocie un couple aléatoire à chaque
> création du conteneur et l'écrit dans `docker logs hadoop-nifi`. Le fichier
> n'est pas versionné ; seul le `.example` l'est.

### Slaves (`hadoop-slave1`, `hadoop-slave2`)

| Processus | Rôle | Port |
|-----------|------|------|
| `DataNode` | Stockage HDFS | — |
| `NodeManager` | Exécuteur YARN | 8041 / 8042 (UI) |
| `HRegionServer` | Stockage HBase | — |

### URLs utiles

| URL | Port | Service | Description |
|-----|------|---------|-------------|
| `http://<IP>:9870` | `9870` | NameNode | Interface web HDFS (métadonnées, blocs, datanodes) |
| `http://<IP>:9868` | `9868` | SecondaryNameNode | Statut du checkpointing |
| `http://<IP>:8088` | `8088` | ResourceManager | Interface web YARN (jobs, scheduler, nodes) |
| `http://<IP>:8041` | `8041` *(→8042 interne)* | NodeManager slave1 | Logs et statut du nœud d'exécution YARN slave1 |
| `http://<IP>:8042` | `8042` | NodeManager slave2 | Logs et statut du nœud d'exécution YARN slave2 |
| `http://<IP>:16010` | `16010` | HMaster | Interface web HBase (tables, regions, masters) |
| `http://<IP>:9091` | `9091` | HBase REST | API REST HBase (requêtes HTTP JSON/XML) |
| `https://<IP>:8443/nifi` | `8443` | NiFi | Canvas des flux d'ingestion (séquence 07 du cours) — HTTPS auto-signé, accepter le certificat dans le navigateur |
| `jdbc:hive2://<IP>:10000` | `10000` | HiveServer2 | SQL sur HDFS — connexion Beeline |
| `http://<IP>:10002` | `10002` | HiveServer2 UI | Statut des sessions Hive |

> Le master n'a pas de NodeManager (il ne figure pas dans `workers`).
> Les ports 2181 (ZooKeeper), 9000 (NameNode RPC), 9090 (Thrift) sont des protocoles binaires, pas des interfaces web.

## Utilisation

### HBase avec happybase

```bash
python3 /home/src/hbase.py
```

### Hive avec Beeline

```bash
# Dans le master (après ./start-hive.sh)
beeline -u jdbc:hive2://localhost:10000
```

```sql
SHOW DATABASES;
CREATE DATABASE spotify_db;
```

> Le Metastore Derby embarqué accepte **une session à la fois** (verrou sur
> `/home/metastore_db`) — suffisant pour un cluster d'apprentissage, un
> seul apprenant/facilitateur à la fois. Hive 4.x ne fournit plus la
> vieille CLI `hive` : Beeline est le client officiel.

### Power BI

1. Power BI Desktop → **Obtenir des données** → **Web**
2. URL : `http://<IP_PROXMOX>:9091/`
3. Utiliser l'éditeur Power Query pour parser le JSON

> Amélioration par la suite pour utiliser un 'Hbase ODBC driver'

## Déploiement sur VM

Guide complet pour l'installation sur VM Proxmox → [`docs/deploiement-vm.md`](docs/deploiement-vm.md)

## Rebuild complet

```bash
# -v : supprime aussi les volumes
docker compose down -v
docker compose build --no-cache
docker compose up -d
```

## Arborescence

```
hadoop-cluster/
├── Dockerfile.debian         # Image multistage (Debian 12) — actif
├── Dockerfile.rocky          # Image multistage (Rocky Linux 9) — conservé
├── docker-compose.yml        # Orchestration (3 conteneurs cluster + NiFi)
├── container_start.sh        # Démarre les conteneurs
├── container_stop.sh         # Arrête les conteneurs
├── bash_hadoop_master.sh     # Console dans le master
├── config/                   # Fichiers de configuration statiques
│   ├── core-site.xml
│   ├── hdfs-site.xml
│   ├── mapred-site.xml
│   ├── yarn-site.xml
│   ├── hbase-site.xml
│   ├── hive-site.xml         # Metastore Derby + HiveServer2 (port 10000)
│   ├── zoo.cfg
│   └── datanodes
├── nifi/                     # Conteneur NiFi (séquence 07)
│   ├── README.md             # Setup volumes + PutHDFS
│   ├── hadoop/               # core-site.xml + hdfs-site.xml pour PutHDFS
│   └── input/                # Fichiers à ingérer (GetFile)
├── scripts/                  # Scripts copiés dans le conteneur
│   ├── entrypoint.sh          # Entrypoint (init réseau + heaps JVM)
│   └── master/                # Scripts de gestion des services (dans /home/)
│       ├── start-all.sh       # Démarre tous les services en ordre
│       ├── start-zookeeper.sh
│       ├── start-dfs.sh
│       ├── start-yarn.sh
│       ├── start-jobhistory.sh
│       ├── start-hbase.sh
│       ├── start-thrift.sh
│       ├── start-rest.sh
│       ├── start-hive.sh      # HiveServer2 (Derby embarqué)
│       └── README.md
├── src/                     # Scripts des TP
│   ├── hbase.py              # Exemple HBase (étudiants)
│   ├── wordcount/
│   │   ├── mapper.py
│   │   ├── reducer.py
│   │   ├── put_hbase.py       # Stocke le résultat MR dans HBase
│   │   └── run_mr.sh         # Script générique de lancement MR
│   └── tp_hbase.py
├── docs/                   # Documentation
│   ├── technical-implementation.md
│   ├── rest-api.md
│   ├── amelioration-prod.md
│   └── deploiement-vm.md
```
