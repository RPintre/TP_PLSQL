-- ====================
-- TABLE : TYPE_LIVRE
-- ====================

CREATE TABLE type_livre (
    id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nom VARCHAR2(100) NOT NULL
);


-- ====================
-- TABLE : AUTEUR
-- ====================
CREATE TABLE auteur (
    id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nom VARCHAR2(200) NOT NULL
);

-- ====================
-- TABLE : LIVRES
-- ====================
CREATE TABLE livres (
    id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    titre VARCHAR2(255) NOT NULL,
    id_auteur NUMBER NOT NULL,
    id_type NUMBER NOT NULL,
    annee NUMBER(4),

    CONSTRAINT fk_livre_auteur FOREIGN KEY (id_auteur)
        REFERENCES auteur(id)
        ON DELETE CASCADE, 
    CONSTRAINT fk_livre_type FOREIGN KEY (id_type)
        REFERENCES type_livre(id)
        ON DELETE CASCADE
);

-- ====================
-- TABLE : MEMBRES
-- ====================
CREATE TABLE membres (
    id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nom VARCHAR2(100) NOT NULL,
    prenom VARCHAR2(100) NOT NULL,
    date_de_naissance DATE,
    date_inscription DATE DEFAULT SYSDATE
);

-- ====================
-- TABLE : emprunt  
-- ====================
CREATE TABLE emprunt (
    id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_membre NUMBER NOT NULL,
    date_emprunt DATE DEFAULT SYSDATE NOT NULL,
    date_retour_prevue DATE DEFAULT SYSDATE+30 NOT NULL,
    statut VARCHAR2(20) DEFAULT 'en_cours' NOT NULL
        CHECK (statut IN ('en_cours', 'termine', 'dépassé')),
    CONSTRAINT fk_emprunt_membre FOREIGN KEY (id_membre)
        REFERENCES membres(id)
        ON DELETE CASCADE
);

-- ====================
-- TABLE : emprunt_LIVRES 
-- ====================
CREATE TABLE emprunt_livres (
    id_emprunt NUMBER NOT NULL,
    id_livre NUMBER NOT NULL,
    date_retour_effective DATE,         
    statut_ligne VARCHAR2(20) DEFAULT 'emprunte' NOT NULL
        CHECK (statut_ligne IN ('emprunte', 'retourne', 'perdu', 'endommage')),

    CONSTRAINT pk_emprunt_livres PRIMARY KEY (id_emprunt, id_livre),

    CONSTRAINT fk_empruntlivre_emprunt FOREIGN KEY (id_emprunt)
        REFERENCES emprunt(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_empruntlivre_livre FOREIGN KEY (id_livre)
        REFERENCES livres(id)
        ON DELETE CASCADE
);

-- ====================
-- Indexes 
-- ====================
CREATE INDEX idx_livres_auteur ON livres(id_auteur);
CREATE INDEX idx_livres_type ON livres(id_type);
CREATE INDEX idx_emprunt_membre ON emprunt(id_membre);
CREATE INDEX idx_empruntlivres_livre ON emprunt_livres(id_livre);