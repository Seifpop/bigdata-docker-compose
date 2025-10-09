-- Script MySQL pour créer la base de données et la table facture
CREATE DATABASE IF NOT EXISTS spark_exercice;
USE spark_exercice;

-- Table facture dans MySQL
CREATE TABLE IF NOT EXISTS facture (
    id_facture INT AUTO_INCREMENT PRIMARY KEY,
    id_client INT NOT NULL,
    numero_facture VARCHAR(50) UNIQUE NOT NULL,
    date_facture DATE NOT NULL,
    montant_ht DECIMAL(10,2) NOT NULL,
    montant_tva DECIMAL(10,2) NOT NULL,
    montant_ttc DECIMAL(10,2) NOT NULL,
    statut ENUM('en_attente', 'payee', 'annulee') DEFAULT 'en_attente',
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    date_modification TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Index pour optimiser les recherches par client
CREATE INDEX idx_facture_client ON facture(id_client);
CREATE INDEX idx_facture_date ON facture(date_facture);
CREATE INDEX idx_facture_statut ON facture(statut);

-- Insertion de données d'exemple
INSERT INTO facture (id_client, numero_facture, date_facture, montant_ht, montant_tva, montant_ttc, statut) VALUES
(1, 'FAC-2024-001', '2024-01-15', 1000.00, 200.00, 1200.00, 'payee'),
(2, 'FAC-2024-002', '2024-01-20', 1500.00, 300.00, 1800.00, 'en_attente'),
(1, 'FAC-2024-003', '2024-02-01', 750.00, 150.00, 900.00, 'payee'),
(3, 'FAC-2024-004', '2024-02-10', 2000.00, 400.00, 2400.00, 'en_attente'),
(2, 'FAC-2024-005', '2024-02-15', 1250.00, 250.00, 1500.00, 'annulee'),
(4, 'FAC-2024-006', '2024-03-01', 3000.00, 600.00, 3600.00, 'payee'),
(1, 'FAC-2024-007', '2024-03-05', 800.00, 160.00, 960.00, 'en_attente'),
(5, 'FAC-2024-008', '2024-03-10', 1800.00, 360.00, 2160.00, 'payee');
