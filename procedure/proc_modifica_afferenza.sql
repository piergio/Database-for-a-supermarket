DROP PROCEDURE if exists ModificaAfferenza;

DELIMITER //

CREATE PROCEDURE ModificaAfferenza(IN _impiegato VARCHAR(20), IN nuovoReparto INT(11))

	BEGIN

		DECLARE errormsg	VARCHAR(50);

		IF(SELECT cf FROM Impiegati WHERE cf = _impiegato) IS NOT NULL AND (_impiegato IS NOT NULL) THEN

			IF nuovoReparto <> 0 AND(SELECT id FROM Reparti WHERE id = nuovoReparto) IS NOT NULL THEN

				IF nuovoReparto IN (SELECT reparto FROM Impiegati JOIN Afferenza ON cf = impiegato) THEN

					IF (_impiegato NOT IN(SELECT responsabile FROM Reparti)) THEN

						IF(nuovoReparto <> 13) THEN 

							UPDATE Afferenza SET reparto = nuovoReparto WHERE impiegato = _impiegato;

						ELSE

							SET errormsg = 'Nel reparto direzione, il direttore è unico!';
							SELECT errormsg;
						END IF;

					ELSE

						SET errormsg = 'Non puoi cambiare reparto ad un responsabile!';
						SELECT errormsg;
					END IF;
				ELSE

					SET errormsg = 'Impiegato già in questo reparto!';
					SELECT errormsg;
				END IF;

			ELSE

				SET errormsg = 'Reparto non trovato.';
				SELECT errormsg;
			END IF;

		ELSE

			SET errormsg = 'Impiegato non trovato.';
			SELECT errormsg;
		END IF;

	END; //

DELIMITER ;