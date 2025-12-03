INSERT INTO type_livre (nom) VALUES ('Roman');
INSERT INTO type_livre (nom) VALUES ('Science-Fiction');
INSERT INTO type_livre (nom) VALUES ('Fantastique');

INSERT INTO auteur (nom) VALUES ('Jules Verne');
INSERT INTO auteur (nom) VALUES ('Victor Hugo');
INSERT INTO auteur (nom) VALUES ('J.R.R. Tolkien');
INSERT INTO auteur (nom) VALUES ('George Orwell');
INSERT INTO auteur (nom) VALUES ('Isaac Asimov');

INSERT INTO livres (titre, id_auteur, id_type, annee) VALUES ('Vingt mille lieues sous les mers', 1, 2, 1870);
INSERT INTO livres (titre, id_auteur, id_type, annee) VALUES ('Les Misérables', 2, 1, 1862);
INSERT INTO livres (titre, id_auteur, id_type, annee) VALUES ('Le Seigneur des Anneaux', 3, 3, 1954);
INSERT INTO livres (titre, id_auteur, id_type, annee) VALUES ('Le Hobbit', 3, 3, 1937);
INSERT INTO livres (titre, id_auteur, id_type, annee) VALUES ('1984', 4, 2, 1949);
INSERT INTO livres (titre, id_auteur, id_type, annee) VALUES ('Fondation', 5, 2, 1950);
INSERT INTO livres (titre, id_auteur, id_type, annee) VALUES ('Notre-Dame de Paris', 2, 1, 1831);
INSERT INTO livres (titre, id_auteur, id_type, annee) VALUES ('Voyage au centre de la Terre', 1, 1, 1864);

INSERT INTO membres (nom, prenom, date_de_naissance) VALUES ('Martin', 'Luc', DATE '1990-04-12');
INSERT INTO membres (nom, prenom, date_de_naissance) VALUES ('Durand', 'Sophie', DATE '1985-11-23');
INSERT INTO membres (nom, prenom, date_de_naissance) VALUES ('Bernard', 'Paul', DATE '2000-02-05');
INSERT INTO membres (nom, prenom, date_de_naissance) VALUES ('Petit', 'Emma', DATE '1998-07-19');

INSERT INTO emprunt (id_membre, date_retour_prevue, statut) VALUES (1, SYSDATE + 14, 'en_cours');

INSERT INTO emprunt (id_membre, date_retour_prevue, statut) VALUES (2, SYSDATE + 10, 'en_cours');

INSERT INTO emprunt (id_membre, date_retour_prevue, statut) VALUES (4, SYSDATE + 7, 'en_cours');

INSERT INTO emprunt_livres (id_emprunt, id_livre) VALUES (1, 1); -- Vingt mille lieues
INSERT INTO emprunt_livres (id_emprunt, id_livre) VALUES (1, 5); -- 1984
INSERT INTO emprunt_livres (id_emprunt, id_livre) VALUES (1, 8); -- Voyage au centre

INSERT INTO emprunt_livres (id_emprunt, id_livre) VALUES (2, 2); -- Les Misérables
INSERT INTO emprunt_livres (id_emprunt, id_livre) VALUES (2, 6); -- Fondation

INSERT INTO emprunt_livres (id_emprunt, id_livre) VALUES (3, 3); -- Le Seigneur des Anneaux
INSERT INTO emprunt_livres (id_emprunt, id_livre) VALUES (3, 4); -- Le Hobbit
INSERT INTO emprunt_livres (id_emprunt, id_livre) VALUES (3, 7); -- Notre-Dame de Paris

COMMIT;

