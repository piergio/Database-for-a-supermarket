drop procedure if exists AggiornaResponsabile;


DELIMITER //
	CREATE PROCEDURE AggiornaResponsabile(IN vecchioResponsabile VARCHAR(20), IN nuovoResponsabile varchar(20), IN rep int(11))
		
        BEGIN
            
			declare tmp varchar(100);
            declare lvl int(11);
           
			select cf into tmp from Impiegati where cf = vecchioResponsabile and livello = 5;
            
            if tmp is not null
				then
                
					set tmp = null;
					select responsabile into tmp from Impiegati join Reparti on responsabile = cf where responsabile = vecchioResponsabile and id = rep;
                    
                    if tmp is not null
						
                        then
                        
							set tmp = null;
							select impiegato into tmp from Afferenza where impiegato = nuovoResponsabile and reparto = rep;
                            
                            if tmp is not null
								then
                                
									set tmp = null;
                                    
                                    select livello into lvl from Impiegati where cf = nuovoResponsabile;
                                    
                                    if lvl <= 5
                                    
										then
                                        
											update Impiegati set livello = 4 where cf = vecchioResponsabile;
											update Impiegati set livello = 5 where cf = nuovoResponsabile;
											update Reparti set responsabile = nuovoResponsabile where responsabile = vecchioResponsabile;
									else
                                    
										set tmp = 'Il nuovo responsabile ha già un grado maggiore';
                                        select tmp;
                                    end if;
							else
                            
								set tmp = 'Il nuovo responsabile non appartiene a questo reparto.';
                                select tmp as Attenzione;
						end if;
                            
					else
						
                        set tmp = 'Il responsabile non è del reparto passato come parametro.';
                        select tmp as Attenzione;
					end if;
                    
				else
				
					set tmp = 'Non esiste un vecchio responsabile con quel CF.';
					select tmp as Attenzione;
                
			end if;
            
			set tmp = null;
            
		END; //
DELIMITER ;