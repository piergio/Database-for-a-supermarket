drop database if exists supermercato;
create database if not exists supermercato;
USE `supermercato`;

CREATE TABLE IF NOT EXISTS `supermercato`.`Stipendi` (
  `livelloQualifica` INT(11) NOT NULL,
  `retribuzione` INT(11) UNIQUE NOT NULL,
  PRIMARY KEY (livelloQualifica))
ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS `supermercato`.`Impiegati` (
  `cf` VARCHAR(20),
  `nome` VARCHAR(20) NOT NULL,
  `cognome` VARCHAR(20) NOT NULL,
  `sesso` CHAR(1) NOT NULL,
  `comuneNascita` VARCHAR(20) NOT NULL,
  `provinciaNascita` VARCHAR(20) NOT NULL,
  `dataNascita` DATE NOT NULL,
  `indirizzo` VARCHAR(45) NOT NULL,
  `comuneResidenza` VARCHAR(20) NOT NULL,
  `livello` INT(11) NOT NULL,
  PRIMARY KEY (`cf`))
ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS `supermercato`.`Reparti` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(20) UNIQUE NOT NULL,
  `responsabile` VARCHAR(20) UNIQUE,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `supermercato`.`Afferenza` (
  `impiegato` varchar (20) UNIQUE NOT NULL,
  `reparto` INT(11) NOT NULL,
  `dataAssunzione` DATE NOT NULL,
 PRIMARY KEY (`impiegato`, `reparto`))
ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS `supermercato`.`Fornitori` (
  `piva` varchar(11) NOT NULL,
  `ragioneSociale` VARCHAR(10) NOT NULL,
  `indirizzo` VARCHAR(45) NOT NULL,
  `comuneSede` VARCHAR(20) NOT NULL,
  `provinciaSede` VARCHAR(20) NOT NULL,
  `pagamento` VARCHAR(20) NOT NULL,
  `telefono` VARCHAR(15) UNIQUE NOT NULL,
  `fax` VARCHAR(15) UNIQUE NOT NULL,
  PRIMARY KEY (`piva`))
ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS `supermercato`.`Fornitura` (
  `prodotto` INT(11) NOT NULL,
  `fornitore` varchar(11) NOT NULL,
  `prezzoFornitura` DECIMAL(7,2) UNSIGNED NOT NULL,
  PRIMARY KEY (`prodotto`, `fornitore`))
ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS `supermercato`.`Prodotti` (
  `codice` INT(11) UNIQUE NOT NULL AUTO_INCREMENT,
  `reparto` INT(11) NOT NULL,
  `nome` VARCHAR(45) UNIQUE NOT NULL,
  `genere` VARCHAR(45) NOT NULL,
  `prezzo` DECIMAL(7,2) UNSIGNED NOT NULL,
  `quantita` INT(11) NULL,
  `soglia` INT(11) NULL,
  `scadenza` DATE NOT NULL,
  PRIMARY KEY (`codice`))
ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS `supermercato`.`Premi` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `prodotto` INT(11) UNIQUE NOT NULL,
  `puntiNecessari` INT(11) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS `supermercato`.`ProdottiPunti` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `prodotto` INT(11) UNIQUE NOT NULL,
  `puntiOttenibili` INT(11) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS `supermercato`.`Composizione` (
  `composto` INT(11) NOT NULL,
  `componente` INT(11) NOT NULL,
  `quantita` VARCHAR(45) NULL,
  PRIMARY KEY (`composto`, `componente`))
ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS `supermercato`.`Clienti` (
  `cf` varchar(20) NOT NULL,
  `tessera` INT(11) UNIQUE NOT NULL AUTO_INCREMENT,
  `punti` INT(11) NULL DEFAULT 0,
  `nome` VARCHAR(20) NOT NULL,
  `cognome` VARCHAR(20) NOT NULL,
  `sesso` CHAR(1) NOT NULL,
  `comuneNascita` VARCHAR(20) NOT NULL,
  `provinciaNascita` VARCHAR(20) NOT NULL,
  `dataNascita` DATE NOT NULL,
  `indirizzo` VARCHAR(45) NOT NULL,
  `comuneResidenza` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`cf`))
ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS `supermercato`.`Scontrini` (
  `nScontrino` INT(11) NOT NULL AUTO_INCREMENT,
  `cliente` varchar(20),
  `dataAcquisto` DATETIME NOT NULL,
  PRIMARY KEY (`nScontrino`))
ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS `supermercato`.`Acquisti` (
  `nScontrino` INT(11) NOT NULL,
  `codiceProdotto` INT(11) NOT NULL,
  `quantita` INT(11) NOT NULL,
  `prezzo` DECIMAL(7,2) NOT NULL,
  PRIMARY KEY (`nScontrino`, `codiceProdotto`))
ENGINE = InnoDB;


ALTER TABLE Impiegati ADD CONSTRAINT fk_livelloImpiegati FOREIGN KEY (livello) REFERENCES Stipendi(livelloQualifica) ON DELETE RESTRICT ON UPDATE RESTRICT;

ALTER TABLE Reparti ADD CONSTRAINT fk_responsabileReparti FOREIGN KEY (responsabile) REFERENCES Impiegati(cf) ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE Afferenza ADD CONSTRAINT fk_impiegatoAfferenza FOREIGN KEY (impiegato) REFERENCES Impiegati(cf) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE Afferenza ADD CONSTRAINT fk_repartoAfferenza FOREIGN KEY (reparto) REFERENCES Reparti(id) ON DELETE RESTRICT ON UPDATE RESTRICT;

ALTER TABLE Prodotti ADD CONSTRAINT fk_repartoProdotti FOREIGN KEY (reparto) REFERENCES Reparti(id) ON DELETE RESTRICT ON UPDATE RESTRICT;

ALTER TABLE Fornitura ADD CONSTRAINT fk_prodottoFornitura FOREIGN KEY (prodotto) REFERENCES Prodotti(codice) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE Fornitura ADD CONSTRAINT fk_fornitoreFornitura FOREIGN KEY (fornitore) REFERENCES Fornitori(piva) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE Premi ADD CONSTRAINT fk_prodottoPremi FOREIGN KEY (prodotto) REFERENCES Prodotti(codice) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE ProdottiPunti ADD CONSTRAINT fk_prodottipuntiPremi FOREIGN KEY (prodotto) REFERENCES Prodotti(codice) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE Composizione ADD CONSTRAINT fk_compostoComposizione FOREIGN KEY (composto) REFERENCES Prodotti(codice) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE Composizione ADD CONSTRAINT fk_componenteComposizione FOREIGN KEY (componente) REFERENCES Prodotti(codice) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE Scontrini ADD CONSTRAINT fk_clienteScontrini FOREIGN KEY (cliente) REFERENCES Clienti(cf) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE Acquisti ADD CONSTRAINT fk_codiceProdottoAcquisti FOREIGN KEY (codiceProdotto) REFERENCES Prodotti(codice) ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE Acquisti ADD CONSTRAINT fk_nScontrinoAcquisti FOREIGN KEY (nScontrino) REFERENCES Scontrini(nScontrino) ON DELETE RESTRICT ON UPDATE RESTRICT;

