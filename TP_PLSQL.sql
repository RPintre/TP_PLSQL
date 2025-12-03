CREATE OR REPLACE TYPE liste_livres AS TABLE OF NUMBER;
/

CREATE OR REPLACE PACKAGE pkg_gestion AS
    PROCEDURE emprunter(
        p_id_membre IN NUMBER,
        liste_livres IN liste_livres
    );

    PROCEDURE retourner(
        p_id_membre IN NUMBER,
        liste_livres IN liste_livres
    );

    FUNCTION get_statistique_emprunt_du_membre(p_id IN NUMBER) RETURN NUMBER;

    FUNCTION get_statistique_livre_emprunte(p_id_livre IN NUMBER) RETURN NUMBER;

    FUNCTION get_statistique_auteur_emprunte(p_id_auteur IN NUMBER) RETURN NUMBER;
END pkg_gestion;
/
CREATE OR REPLACE PACKAGE BODY pkg_gestion AS

    PROCEDURE emprunter(
        p_id_membre IN NUMBER,
        liste_livres IN liste_livres
    ) IS    
        id_emprunt_v NUMBER;
        v_count NUMBER;
    BEGIN
        INSERT INTO emprunt(id_membre) VALUES(p_id_membre) RETURNING id INTO id_emprunt_v;
        
        FOR i IN 1 .. liste_livres.COUNT LOOP
            SELECT COUNT(*) INTO v_count
            FROM emprunt_livres
            WHERE id_livre = liste_livres(i)
            AND statut_ligne = 'emprunte';

            IF v_count > 0 THEN
                RAISE_APPLICATION_ERROR(-20001, 'Le livre ' || liste_livres(i) || ' est déjà emprunté.');
            END IF;

            INSERT INTO emprunt_livres(id_emprunt,id_livre,statut_ligne) 
            VALUES(id_emprunt_v,liste_livres(i),'emprunte');
        END LOOP;
        COMMIT;
    END emprunter;

    PROCEDURE retourner(
        p_id_membre IN NUMBER,
        liste_livres IN liste_livres
    ) IS
    BEGIN
        FOR i IN 1 .. liste_livres.COUNT LOOP
            UPDATE emprunt_livres
            SET statut_ligne = 'retourne',
            date_retour_effective = SYSDATE
            WHERE id_livre = liste_livres(i)
            AND id_emprunt = (
                SELECT E.id 
                FROM emprunt E 
                INNER JOIN emprunt_livres EL ON E.id=EL.id_emprunt 
                WHERE E.id_membre=p_id_membre  
                AND EL.id_livre=liste_livres(i)
            );
        END LOOP;
        COMMIT;
    END retourner;

    FUNCTION get_statistique_emprunt_du_membre(p_id IN NUMBER)
    RETURN NUMBER IS
        v_count NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_count
        FROM emprunt E 
        INNER JOIN emprunt_livres EL ON E.id = EL.id_emprunt
        WHERE E.id_membre = p_id
        AND EL.statut_ligne = 'en_cours';
        RETURN v_count;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN 0;
    END get_statistique_emprunt_du_membre;

    FUNCTION get_statistique_livre_emprunte(p_id_livre IN NUMBER)
    RETURN NUMBER IS
        v_count NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_count
        FROM emprunt_livres
        WHERE id_livre = p_id_livre;
        RETURN v_count;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN 0;
    END get_statistique_livre_emprunte;

    FUNCTION get_statistique_auteur_emprunte(p_id_auteur IN NUMBER)
    RETURN NUMBER IS
        v_count NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_count
        FROM emprunt_livres EL
        INNER JOIN livres L ON EL.id_livre = L.id
        WHERE L.id_auteur = p_id_auteur;
        RETURN v_count;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN 0;
    END get_statistique_auteur_emprunte;
    
END pkg_gestion;
/



CREATE OR REPLACE TRIGGER trg_update_emprunt
AFTER UPDATE OF statut_ligne ON emprunt_livres
DECLARE
    TYPE emprunt_ids IS TABLE OF emprunt_livres.id_emprunt%TYPE;
    v_emprunts emprunt_ids := emprunt_ids();
BEGIN
    SELECT DISTINCT id_emprunt BULK COLLECT INTO v_emprunts
    FROM emprunt_livres
    WHERE statut_ligne = 'retourne';

    FOR i IN 1 .. v_emprunts.COUNT LOOP
        UPDATE emprunt
        SET statut = 'termine'
        WHERE id = v_emprunts(i)
        AND NOT EXISTS (
            SELECT 1
            FROM emprunt_livres
            WHERE id_emprunt = v_emprunts(i)
            AND statut_ligne <> 'retourne'
        );
    END LOOP;
END;
/

declare
    auteur_count NUMBER;
    livre_count NUMBER;
    membre_count NUMBER;
BEGIN
    --pkg_gestion.emprunter(1, liste_livres(1,5,3));
    --pkg_gestion.retourner(1, liste_livres(1,5,8));
    --pkg_gestion.retourner(2, liste_livres(6));
    
    Select PKG_GESTION.GET_STATISTIQUE_AUTEUR_EMPRUNTE(1) into auteur_count from dual ;
    
    Select PKG_GESTION.GET_STATISTIQUE_LIVRE_EMPRUNTE(1) into livre_count from dual ;
    
    Select PKG_GESTION.GET_STATISTIQUE_EMPRUNT_DU_MEMBRE(2) into membre_count from dual ;
    DBMS_OUTPUT.PUT_LINE('Auteur count: ' || auteur_count);
    DBMS_OUTPUT.PUT_LINE('Livre count: ' || livre_count);
    DBMS_OUTPUT.PUT_LINE('Membre count: ' || membre_count);
END;
/