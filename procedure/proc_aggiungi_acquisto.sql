DROP PROCEDURE if exists AggiungiAcquisto;

DELIMITER	//

CREATE PROCEDURE AggiungiAcquisto(IN _prodotto INT(11), IN _quantita INT(11), IN _cliente INT(11), IN modalità VARCHAR(20))

	BEGIN

		DECLARE msg				VARCHAR(100);
		DECLARE	numeroScontrini INT(11);
		DECLARE	qnt				INT(11);
		DECLARE pnt 			INT(11);
		DECLARE prz 			DECIMAL(7, 2);

		IF STRCMP(modalità, 'N') = 0 OR STRCMP(modalità, 'n') = 0 THEN

			IF(SELECT tessera FROM Clienti WHERE tessera = _cliente) IS NOT NULL OR (_cliente IS NULL) THEN 

				IF(SELECT codice FROM Prodotti WHERE codice = _prodotto) IS NOT NULL THEN

					IF(select quantita from Prodotti where codice = _prodotto) >= _quantita THEN

						IF(_quantita > 0)  AND (_quantita IS NOT NULL)THEN

							INSERT INTO Scontrini(cliente, dataAcquisto) values ((SELECT cf FROM Clienti WHERE tessera = _cliente), NOW());
							SELECT count(*) INTO numeroScontrini FROM Scontrini;

							SELECT prezzo INTO prz FROM Prodotti WHERE codice = _prodotto;
							SET prz = prz * _quantita;

							INSERT INTO Acquisti(nScontrino, codiceProdotto, quantita, prezzo) values (numeroScontrini, _prodotto, _quantita, prz);
							UPDATE Prodotti SET quantita = (quantita - _quantita) WHERE codice = _prodotto;

							IF(SELECT prodotto FROM ProdottiPunti WHERE prodotto = _prodotto) IS NOT NULL THEN

								SELECT punti INTO pnt FROM Clienti WHERE tessera = _cliente;
								SET pnt = pnt + (SELECT puntiOttenibili FROM ProdottiPunti WHERE prodotto = _prodotto) * _quantita;
								UPDATE Clienti SET punti = pnt WHERE tessera = _cliente;
							END IF;

							IF(SELECT soglia FROM Prodotti where codice = _prodotto) > (select quantita from Prodotti where codice = _prodotto) THEN

								UPDATE Prodotti SET quantita = 20 where codice = _prodotto;
								SET msg = 'Prodotto acquistato sotto la soglia...Riordino effettuato';
								SELECT msg;
							END IF;
							
						ELSE

							SET msg = 'Quantità uguale a zero! Non potresti acquistare gratis....';
							SELECT msg as error_message;
						END IF;

					ELSE

						SET msg = 'Quantità non sufficente!';
						SELECT msg as error_message;
					END IF;

				ELSE

					SET msg = 'Prodotto non trovato';
					SELECT msg as error_message;

				END IF;

			ELSE

				SET msg = 'Codice fiscale cliente non trovato';
				SELECT msg as error_message;

			END IF;

		ELSEIF STRCMP(modalità, 'O') = 0 OR STRCMP(modalità, 'o') = 0     THEN 

			SET numeroScontrini = (SELECT count(DISTINCT nScontrino) FROM Acquisti);

			IF(SELECT tessera FROM Clienti WHERE tessera = _cliente) IS NOT NULL OR (_cliente IS NULL) THEN 

				SELECT cf INTO msg FROM Clienti WHERE tessera = _cliente;
				SELECT msg;

				IF(STRCMP(msg, (SELECT cliente FROM Scontrini WHERE nScontrino = numeroScontrini))) = 0  OR msg IS NULL THEN

					IF(SELECT codice FROM Prodotti WHERE codice = _prodotto) IS NOT NULL THEN

						IF(select quantita from Prodotti where codice = _prodotto) >= _quantita THEN

							IF(_quantita > 0) AND (_quantita IS NOT NULL)THEN

								SELECT prezzo INTO prz FROM Prodotti WHERE codice = _prodotto;
								SET prz = prz * _quantita;

								INSERT INTO Acquisti(nScontrino, codiceProdotto, quantita, prezzo) values (numeroScontrini, _prodotto, _quantita, prz);
								UPDATE Prodotti SET quantita = (quantita - _quantita) WHERE codice = _prodotto;

								IF (SELECT prodotto FROM ProdottiPunti WHERE prodotto = _prodotto) IS NOT NULL THEN

									SELECT punti INTO pnt FROM Clienti WHERE tessera = _cliente;
									SET pnt = pnt + (SELECT puntiOttenibili FROM ProdottiPunti WHERE prodotto = _prodotto) * _quantita;
									UPDATE Clienti SET punti = pnt WHERE tessera = _cliente;
								END IF;

								IF(SELECT soglia FROM Prodotti where codice = _prodotto) > (select quantita from Prodotti where codice = _prodotto) THEN

									UPDATE Prodotti SET quantita = 20 where codice = _prodotto;
									SET msg = 'Prodotto acquistato sotto la soglia...Riordino effettuato';
									SELECT msg;
								END IF;
							ELSE

								SET msg = 'Quantità uguale a zero! Non potresti acquistare gratis....';
								SELECT msg as error_message;
							END IF;

						ELSE

							SET msg = 'Quantità non sufficente!';
							SELECT msg as error_message;
						END IF;

					ELSE

						SET msg = 'Prodotto non trovato';
						SELECT msg as error_message;
					END IF;					

				ELSE

					SET msg = 'Prima bisogna generare lo scontrino per questo cliente';
					SELECT msg as error_message;
				END IF;

			ELSE

				SET msg = 'Tessera cliente non trovato';
				SELECT msg as error_message;
			END IF;

		ELSE

			SET msg = 'Modalità acquisto non valida';
			select msg as error_message;

		END IF;
	END; //

DELIMITER ;