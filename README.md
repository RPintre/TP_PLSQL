# Système de Gestion de Bibliothèque – Documentation SQL & PL/SQL

Ce projet met en place un système complet de gestion de bibliothèque sous Oracle. Il inclut la création des tables, l’ajout d’index, des données d’exemple, un package PL/SQL pour gérer les emprunts et retours, ainsi qu’un trigger pour mettre automatiquement à jour le statut d’un emprunt.

---

## 1. Structure de la Base de Données

### Table type_livre
Contient les catégories de livres.  
Champs : id (PK), nom.

### Table auteur
Stocke les auteurs.  
Champs : id (PK), nom.

### Table livres
Contient les livres.  
Champs : id, titre, id_auteur (FK), id_type (FK), annee.  
Suppression en cascade si l’auteur ou le type est supprimé.

### Table membres
Informations sur les membres.  
Champs : id, nom, prenom, date_de_naissance, date_inscription (default SYSDATE).

### Table emprunt
Représente un emprunt global fait par un membre.  
Champs : id, id_membre (FK), date_emprunt, date_retour_prevue, statut.  
Statut : en_cours, termine, dépassé.

### Table emprunt_livres
Associe un emprunt à des livres.  
Champs : id_emprunt + id_livre (PK composite), statut_ligne, date_retour_effective.  
Statut_ligne : emprunte, retourne, perdu, endommage.

---

## 2. Index créés
Pour faciliter les recherches fréquentes

- idx_livres_auteur : livres(id_auteur)  
- idx_livres_type : livres(id_type)  
- idx_emprunt_membre : emprunt(id_membre)  
- idx_empruntlivres_livre : emprunt_livres(id_livre)

---

## 3. Données d’exemple

Des jeux de données sont insérés automatiquement :

- Types de livres (Roman, Science-Fiction, Fantastique)
- Auteurs célèbres
- Livres
- Membres
- Emprunts avec plusieurs livres chacun

Cela permet de tester directement les fonctions et procédures.

---

## 4. Type Oracle : liste_livres

Un type TABLE OF NUMBER permettant de transmettre une liste de livres à emprunter ou retourner.  
Il est utilisé dans le package pour gérer plusieurs livres en une seule opération.

---

## 5. Package pkg_gestion

Le package regroupe la logique métier : emprunts, retours, statistiques.

### Procédure emprunter(p_id_membre, liste_livres)
- Crée un nouvel emprunt pour un membre.  
- Vérifie qu’un livre n’est pas déjà emprunté (statut_ligne = 'emprunte').  
- Ajoute chaque livre à l’emprunt.  
- Commit automatique.  
En cas de livre déjà emprunté, l’opération lève une erreur -20001.

### Procédure retourner(p_id_membre, liste_livres)
- Met à jour statut_ligne = 'retourne'.  
- Définit la date_retour_effective.  
- Commit automatique.

### Fonction get_statistique_emprunt_du_membre(p_id)
Retourne le nombre de livres actuellement empruntés par un membre (statut_ligne = en_cours).

### Fonction get_statistique_livre_emprunte(p_id_livre)
Retourne le nombre total d’emprunts contenant ce livre.

### Fonction get_statistique_auteur_emprunte(p_id_auteur)
Retourne combien de fois des livres d’un auteur ont été empruntés.

---

## 6. Trigger trg_update_emprunt

Ce trigger se déclenche après la mise à jour du statut d’une ligne d’emprunt dans emprunt_livres.

Il :
1. Identifie les emprunts dont toutes les lignes sont au statut 'retourne'.  
2. Met à jour l’emprunt global en lui donnant le statut 'termine'.  
3. S’assure qu’aucun livre de cet emprunt n'est encore en cours.

Cela permet de clôturer automatiquement un emprunt lorsque tous ses livres sont rendus.

---

## 7. Bloc de tests

Un bloc PL/SQL inclus à la fin démontre :

- Comment appeler les statistiques du package  
- Comment afficher les résultats avec DBMS_OUTPUT  

Exemples de tests présents :  
- Nombre d’emprunts d’un auteur  
- Nombre d’emprunts d’un livre  
- Nombre d’emprunts d’un membre

---

## Résumé

Ce projet propose une base complète pour un système de gestion de bibliothèque :

- Modèle de données relationnel propre et cohérent  
- Package métier complet  
- Gestion automatique des statuts via trigger  
- Statistiques utiles  
- Données d'exemple exploitables immédiatement  
