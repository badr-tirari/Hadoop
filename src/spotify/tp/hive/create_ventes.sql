-- TP final Q3 : table externe des ventes (TSV prepare par prepare_ventes_tsv.py)
DROP TABLE IF EXISTS ventes;
CREATE EXTERNAL TABLE ventes (
  villecli STRING,
  annee    INT,
  libobj   STRING,
  qte      INT
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
STORED AS TEXTFILE
LOCATION '/user/root/ventes/clean';
