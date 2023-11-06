create database temporario1;
use temporario1;

CREATE TABLE IF NOT EXISTS  marca(
id_marca INT PRIMARY KEY AUTO_INCREMENT,
nombre VARCHAR(20)
);

CREATE TABLE IF NOT EXISTS  bateria(
id_bateria INT PRIMARY KEY AUTO_INCREMENT,
tipo VARCHAR(15),
capacidad VARCHAR(10)
);

CREATE TABLE IF NOT EXISTS  camara(
id_camara INT PRIMARY KEY AUTO_INCREMENT,
nombre VARCHAR(10)
);

CREATE TABLE IF NOT EXISTS  cliente(
id_cliente INT PRIMARY KEY AUTO_INCREMENT,
nombreCompleto VARCHAR(20) NOT NULL,
apellidoCompleto VARCHAR(20) NOT NULL,
mail VARCHAR(100) NOT NULL UNIQUE,
dni VARCHAR(15) NOT NULL,
direccion VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS  equipo(
id_equipo INT PRIMARY KEY AUTO_INCREMENT,
nombre VARCHAR(20),
descripcion TEXT,
marca_id INT NOT NULL,
bateria_id INT NOT NULL,
camara_frontal INT NOT NULL,
camara_trasera INT NOT NULL,
FOREIGN KEY (marca_id) REFERENCES marca(id_marca),
FOREIGN KEY (bateria_id) REFERENCES bateria(id_bateria),
FOREIGN KEY (camara_frontal) REFERENCES camara(id_camara),
FOREIGN KEY (camara_trasera) REFERENCES camara(id_camara)
);

CREATE TABLE IF NOT EXISTS  facturas(
id_factura INT PRIMARY KEY AUTO_INCREMENT,
fecha datetime default current_timestamp,
precio_total DECIMAL(10,2) NOT NULL,
id_cliente int NOT NULL,
FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente)
);

CREATE TABLE IF NOT EXISTS  cuerpo_factura(
id_cuerpo INT PRIMARY KEY AUTO_INCREMENT,
precio_unitario DECIMAL(10,2) NOT NULL,
cantidad int,
id_factura int NOT NULL,
id_equipo int NOT NULL,
FOREIGN KEY (id_factura) REFERENCES facturas(id_factura),
FOREIGN KEY (id_equipo) REFERENCES equipo(id_equipo)
);

INSERT INTO bateria VALUES
(NULL,'LITIO(lI-ON)','5000'),
(NULL,'Litio','4500');

INSERT INTO marca VALUES
(NULL,'Motorola'),
(NULL,'Sansung');

INSERT INTO camara VALUES
(NULL,'50MP'),
(NULL,'50MP,5MP');

INSERT INTO cliente VALUES
(NULL,'Julieta','Gutierrez','jg@gmail.com','xxxxxxxx','San Rafael Mendoza'),
(NULL,'ALE','Dangelo','ad@gmail.com','xxxxxxxx','Soberbio Misiones');

INSERT INTO equipo VALUES
(NULL,'Moto g32','Descripcion del equipo',1,1,1,2),
(NULL,'Sansung A23','Descripcion del equipo',1,1,1,1);
  
INSERT INTO facturas VALUES
(NULL,'2023-11-03 6:08:34',175.99,1),
(NULL,'2023-11-03 6:08:34',219.999,1);

INSERT INTO cuerpo_factura VALUES
(NULL,1075.99,1,1,1);

INSERT INTO cuerpo_factura VALUES
(NULL,219.999,1,1,1);

/*CREANDO LAS VISTAS PARA MI PROYECTO*/
CREATE VIEW view_cliente AS
SELECT * FROM cliente;

CREATE VIEW vista_equipo AS
SELECT * FROM equipo;
SELECT * FROM vista_equipo;

CREATE VIEW view_precio_equipo As
SELECT id_equipo,nombre,bateria_id
FROM equipo;

CREATE VIEW view_facturas AS
SELECT * FROM facturas;

CREATE VIEW FacturasEquipos AS
SELECT
    f.id_factura,
    f.fecha,
    f.precio_total,
    e.nombre AS nombre_equipo,
    e.descripcion AS descripcion_equipo
FROM facturas f
INNER JOIN cuerpo_factura cf ON f.id_factura = cf.id_factura
INNER JOIN equipo e ON cf.id_equipo = e.id_equipo;


CREATE VIEW ClientesFacturas AS
SELECT
    c.id_cliente,
    c.nombreCompleto,
    c.apellidoCompleto,
    c.mail,
    c.dni,
    c.direccion,
    f.id_factura,
    f.fecha,
    f.precio_total
FROM cliente c
LEFT JOIN facturas f ON c.id_cliente = f.id_cliente;

























ON cf.id_equipo = e.id_equipo;