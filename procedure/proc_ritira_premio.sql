DROP PROCEDURE IF EXISTS RitiraPremio;

DELIMITER //

CREATE PROCEDURE RitiraPremio(IN _premio INT(11), IN _cliente INT(11))

	BEGIN

		DECLARE error_msg	VARCHAR(50);
		DECLARE pnt 		INT(11);

		IF(SELECT id FROM Premi WHERE id = _premio) IS NOT NULL THEN

			IF(SELECT tessera FROM Clienti WHERE tessera = _cliente) IS NOT NULL THEN

				IF((SELECT quantita FROM Prodotti where codice = _premio) > (SELECT soglia FROM Prodotti where codice = _premio)) THEN

					IF(SELECT punti FROM Clienti where tessera = _cliente) >= (SELECT puntiNecessari FROM Premi WHERE id = _premio) THEN

						SELECT puntiNecessari INTO pnt FROM Premi WHERE id = _premio;
						UPDATE Clienti SET punti = punti - pnt WHERE tessera = _cliente;
						UPDATE Prodotti SET quantita = quantita - 1 WHERE codice = (SELECT prodotto FROM Premi WHERE id = _premio);
					ELSE

						SET error_msg = 'Punti non sufficienti per ritirare il premio.';
						SELECT error_msg;
					END IF;

				ELSE

					SET error_msg = 'Premio al momento non disponibile.';
					SELECT error_msg;
				END IF;
			ELSE

				SET error_msg = 'Tessera cliente non trovata.';
				SELECT error_msg;
			END IF;

		ELSE

			SET error_msg = 'Codice premio non trovato.';
			SELECT error_msg;
		END IF;
	
	END//

DELIMITER ;