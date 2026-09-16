-- Validation croisee : ces resultats DOIVENT coller a ceux de MapReduce
SELECT '--- COUNT(*) ---' AS info;
SELECT COUNT(*) FROM ventes;
SELECT '--- SUM(qte) total articles ---' AS info;
SELECT SUM(qte) FROM ventes;
SELECT '--- villes distinctes ---' AS info;
SELECT COUNT(DISTINCT villecli) FROM ventes;
SELECT '--- TOP 5 villes (doit = MapReduce Q1) ---' AS info;
SELECT villecli, SUM(qte) AS total FROM ventes GROUP BY villecli ORDER BY total DESC LIMIT 5;
SELECT '--- TOP 5 (ville, annee) (doit = MapReduce Q2) ---' AS info;
SELECT villecli, annee, SUM(qte) AS total FROM ventes
  WHERE annee IS NOT NULL GROUP BY villecli, annee ORDER BY total DESC LIMIT 5;
