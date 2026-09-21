CREATE DATABASE IF NOT EXISTS formation_hive;
USE formation_hive;
CREATE TABLE commandes (
    id_commande INT,
    client_id INT,
    date_commande STRING,
    montant DOUBLE
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE;

-- Table produits
CREATE TABLE produits (
    id_produit INT,
    nom_produit STRING,
    prix DOUBLE,
    categorie STRING
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE;

-- Table produits
CREATE TABLE client (
    id_client INT,
    nom STRING,
    prenom STRING,
    ville STRING,
    age INT
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE;

LOAD DATA INPATH '/user/root/formation/commandes.csv' OVERWRITE INTO TABLE commandes;
LOAD DATA INPATH '/user/root/formation/produits.csv' OVERWRITE INTO TABLE produits;
LOAD DATA INPATH '/user/root/formation/clients.csv' OVERWRITE INTO TABLE client;


 SELECT c.nom,
     SUM(co.montant) as total_ventes
     FROM client c
     JOIN commandes co ON c.id_client = co.client_id
     GROUP BY c.nom
     ORDER BY c.nom;

SELECT
     SUBSTRING(date_commande, 6, 2) as mois,
     COUNT(*) as nb_commande,
     SUM(montant) as ca_mensuel,
     AVG(montant) as panier_moyen_mensuel
     FROM commandes
     GROUP BY SUBSTRING(date_commande, 6, 2);
     