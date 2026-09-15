# Compte-rendu de projet — Écosystème Hadoop

Auteur : Badr-Eddine Tirari — Campus Diginamic — septembre 2026
Dépôt : https://github.com/badr-tirari/Hadoop

## Contenu du dossier

| Fichier | Description |
|---|---|
| `Compte-rendu_Projet_Hadoop_Badr.docx` | Compte-rendu global : installation, architecture, EX02→07 + TD01, résultats, difficultés, conclusion |
| `Rapport_TD01_Hadoop_Badr.docx`        | Rapport détaillé du TD01 (debug local MapReduce) |
| `resultats/streams_par_annee.pdf`      | Ex5 — total des streams par année (camembert + barres) |
| `resultats/streams_artist.pdf`         | Ex7 — top 15 artistes par streams (lu depuis HBase) |

## Où sont les scripts

Tous les scripts d'exercices sont dans `../src/spotify/` du dépôt :
- MapReduce : `*_mapper.py`, `reducer_*.py`, `ex1.sh`…`ex5.sh`
- Hive : `hive/*.sql`, `ex05.sh`
- HBase : `hbase/*.py`, `hbase/biblio.hb`, `ex06_*.sh`
- TD01 : `td01/*.py`

## Résultats clés (recoupés MapReduce ↔ Hive ↔ HBase)

- Total des streams (SUM) : 489 458 828 542
- Artiste n°1 : The Weeknd — 14 185 552 870 streams
- 644 artistes, 50 années (1930→2023), année record : 2022 (116,4 Md)
- Top 5 titres : Taylor Swift (34), The Weeknd (22), SZA (19), Bad Bunny (19), Harry Styles (17)
- Chaîne NiFi → HDFS → Hive : COUNT(*) = 954 (identique à l'EX05)
