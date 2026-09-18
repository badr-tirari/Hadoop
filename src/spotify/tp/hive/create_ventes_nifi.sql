-- TP Q5 (NiFi) : table externe alimentee par l'ingestion NiFi (TSV brut 25 colonnes)
DROP TABLE IF EXISTS ventes_nifi;
CREATE EXTERNAL TABLE ventes_nifi (
  codcli STRING, genrecli STRING, nomcli STRING, prenomcli STRING, cpcli STRING,
  villecli STRING, codcde STRING, datcde STRING, timbrecli STRING, timbrecde STRING,
  Nbcolis STRING, cheqcli STRING, barchive STRING, bstock STRING, codobj STRING,
  qte STRING, Colis STRING, libobj STRING, Tailleobj STRING, Poidsobj STRING,
  points STRING, indispobj STRING, libcondit STRING, prixcond STRING, puobj STRING
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
STORED AS TEXTFILE
LOCATION '/user/root/ventes_nifi';
