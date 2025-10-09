-- Script PostgreSQL pour créer la base de données et la table client
-- Première étape : Créer la base de données (à exécuter en tant que superuser)
CREATE DATABASE spark_exercice;

-- Deuxième étape : Se connecter à la base spark_exercice et exécuter le reste
-- Ce script doit être exécuté après s'être connecté à la base spark_exercice_psql

-- Table client dans PostgreSQL
\c spark_exercice -- Se connecter à la base de données;
CREATE TABLE IF NOT EXISTS client (
    id_client SERIAL PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    prenom VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    telephone VARCHAR(20),
    adresse TEXT,
    ville VARCHAR(50),
    code_postal VARCHAR(10),
    pays VARCHAR(50) DEFAULT 'France',
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    date_modification TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    actif BOOLEAN DEFAULT TRUE
);

-- Index pour optimiser les recherches
CREATE INDEX idx_client_email ON client(email);
CREATE INDEX idx_client_nom_prenom ON client(nom, prenom);
CREATE INDEX idx_client_ville ON client(ville);
CREATE INDEX idx_client_actif ON client(actif);

-- Fonction pour mettre à jour automatiquement date_modification
CREATE OR REPLACE FUNCTION update_date_modification()
RETURNS TRIGGER AS $$
BEGIN
    NEW.date_modification = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Trigger pour mettre à jour automatiquement date_modification
DROP TRIGGER IF EXISTS trigger_update_date_modification ON client;
CREATE TRIGGER trigger_update_date_modification
    BEFORE UPDATE ON client
    FOR EACH ROW
    EXECUTE FUNCTION update_date_modification();

-- Insertion de données d'exemple
INSERT INTO client (nom, prenom, email, telephone, adresse, ville, code_postal, pays) VALUES
('Dupont', 'Jean', 'jean.dupont@email.com', '0123456789', '123 Rue de la Paix', 'Paris', '75001', 'France'),
('Martin', 'Marie', 'marie.martin@email.com', '0234567890', '456 Avenue des Champs', 'Lyon', '69000', 'France'),
('Bernard', 'Pierre', 'pierre.bernard@email.com', '0345678901', '789 Boulevard Saint-Michel', 'Marseille', '13000', 'France'),
('Dubois', 'Sophie', 'sophie.dubois@email.com', '0456789012', '321 Rue du Commerce', 'Toulouse', '31000', 'France'),
('Moreau', 'Paul', 'paul.moreau@email.com', '0567890123', '654 Place de la République', 'Nice', '06000', 'France'),
('Petit', 'Julie', 'julie.petit@email.com', '0678901234', '987 Cours Lafayette', 'Lille', '59000', 'France'),
('Roux', 'Michel', 'michel.roux@email.com', '0789012345', '147 Rue Nationale', 'Bordeaux', '33000', 'France'),
('Leroy', 'Anne', 'anne.leroy@email.com', '0890123456', '258 Avenue Victor Hugo', 'Nantes', '44000', 'France');
