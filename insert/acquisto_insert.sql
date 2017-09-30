insert into acquisti(nScontrino,codiceProdotto,quantita,prezzo) values

('1','105','1', (select prezzo from prodotti where codice=105)*1),
('1','20','1', (select prezzo from prodotti where codice=20)*1),
('2','50','2', (select prezzo from prodotti where codice=50)*2),
('2','35','2', (select prezzo from prodotti where codice=35)*2),
('3','42','5', (select prezzo from prodotti where codice=42)*5),
('3','60','5', (select prezzo from prodotti where codice=60)*5),
('3','70','5', (select prezzo from prodotti where codice=70)*5),
('4','82','3', (select prezzo from prodotti where codice=82)*3),
('5','120','6', (select prezzo from prodotti where codice=120)*6),
('5','91','6', (select prezzo from prodotti where codice=91)*6),
('5','95','6', (select prezzo from prodotti where codice=95)*6),
('6','101','7', (select prezzo from prodotti where codice=101)*7),
('7','101','1', (select prezzo from prodotti where codice=102)*1),
('8','101','1', (select prezzo from prodotti where codice=102)*1),
('9','101','3', (select prezzo from prodotti where codice=102)*1);