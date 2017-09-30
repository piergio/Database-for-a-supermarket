drop procedure if exists AggiungiProdotto;

DELIMITER ///

	CREATE PROCEDURE AggiungiProdotto(IN _prodotto VARCHAR(20), IN _reparto INT(11), IN _genere VARCHAR(20), IN _prezzo DECIMAL(7,2), IN _scadenza VARCHAR(20), IN _fornitore VARCHAR(20))

		BEGIN

			DECLARE	error_msg	VARCHAR(60);
			DECLARE	prz 		DECIMAL(7,2);
			DECLARE	cnt			INTEGER(11);

			IF (_prodotto IS NOT NULL) THEN

				IF (SELECT nome FROM Prodotti WHERE nome = _prodotto) IS NULL THEN

					IF(SELECT id from Reparti where id = _reparto) THEN

						IF(_prezzo > 0) THEN

							IF(SELECT piva FROM Fornitori WHERE piva = _fornitore) THEN
								
								INSERT INTO Prodotti(reparto, nome, genere, prezzo, soglia, quantita, scadenza) VALUES (_reparto, _prodotto, _genere, _prezzo, 20, 6, _scadenza);

								SET prz = _prezzo - (40/100) * _prezzo;

								SELECT codice INTO cnt FROM Prodotti where nome = _prodotto;
								INSERT INTO Fornitura(prodotto, fornitore, prezzoFornitura) VALUES (cnt, _fornitore, prz);
							ELSE

								SET error_msg = 'Fornitore non trovato.';
								SELECT error_msg;
							END IF;
						ELSE

							SET error_msg = 'Prezzo non valido.';
							SELECT error_msg;
						END IF;
					ELSE

						SET error_msg = 'Reparto non trovato.';
						SELECT error_msg;
					END IF;
				ELSE

					SET error_msg = 'Prodotto già esistente.';
					SELECT error_msg;
				END IF;

			ELSE

				SET error_msg = 'Argomento "prodotto" nullo';
				SELECT error_msg;
			END IF;

		END; ///

DELIMITER ;