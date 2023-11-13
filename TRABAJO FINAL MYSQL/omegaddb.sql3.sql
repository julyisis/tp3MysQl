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
(NULL,'ALE','Dangelo','ad@gmail.com','xxxxxxxx','Soberbio Misiones'),
(NULL ,'Excequiel','Garcia','eg@mail.com','xxxxxxxx','Sarmiento Chubut'),
(NUll,'Nicolas','Prez','nm@gmail.com','xxxxxxxxx','Cordoba'),
(NUll,'Camila','Diaz','@gmail.com','xxxxxxxxx','Rosario Santa Fe');

INSERT INTO equipo VALUES
(NULL,'sansung galaxi Ao4','Descripcion del equipo',1,1,1,1),
(NULL,'Moto g32','Descripcion del equipo',1,1,1,2), 
(NULL,'Sansung A23','Descripcion del equipo',1,1,1,1),
(NULL,'sansung galaxi Ao4','Descripcion del equipo',1,1,1,1),
(NULL,'Moto Edge 40','Descripcion del equipo',1,1,1,2);
  
INSERT INTO facturas VALUES
(NULL,'2023-11-03 6:08:34', 175.99,1),
(NULL,'2023-11-03 6:08:34', 219.999,1),
(NULL,'2023-11-03 6:08:34', 125.00,1),
(NULL,'2023-11-03 6:08:34', 384.99,1),
(NULL,'2023-11-03 6:08:34', 549.99,1);

INSERT INTO cuerpo_factura VALUES
(NULL,1075.99,1,1,1),
(NULL,384.99,1,1,1),
(NULL,175.99,1,1,1);

INSERT INTO cuerpo_factura VALUES
(NULL,219.999,1,1,1),
(NULL,549.99,1,1,1);

/*CREANDO LAS VISTAS PARA MI PROYECTO*/
CREATE VIEW FacturaEquipos AS 
SELECT
f.id_factura,
f.precio_total,
e.nombre AS nombre_equipo,
e.descripcion AS descripcion_equipo
FROM facturas f
INNER JOIN cuerpo_factura cf ON f.id_factura = cf.id_factura
INNER JOIN equipo e ON cf.id_equipo = e.id_equipo;

CREATE VIEW FacturasOrdenadas AS
SELECT id_factura,fecha,precio_total
FROM facturas
ORDER BY fecha ASC;

CREATE VIEW VentasPorCliente AS
SELECT id_cliente,SUM(precio_total) AS total_ventas
FROM facturas
GROUP BY id_cliente;

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


SELECT * FROM cliente;
SELECT nombreCompleto,apellidoCompleto,mail.dni,direccion FROM cliente;
DROP  FUNCTION IF EXISTS obtenerDireccionCliente;
/*
FUNCIONES
*/
DELIMITER $$
	CREATE FUNCTION obtenerDireccionCliente (idCliente INT)
	RETURNS VARCHAR(100)
	READS SQL DATA
	/*NO SQL*/
	/*DETERMINISTIC*/
	/*NO ETERMINISTIC*/
	BEGIN
      DECLARE result VARCHAR(100);
      SET result = (SELECT direccion FROM cliente WHERE id_cliente = idCliente);
      RETURN result;
      END
      $$
        /*LLAMAR A NUESTRA FUNCION*/
      SELECT nombreCompleto,direccion, obtenerDireccionCliente(id_cliente) AS 'Direccion'FROM cliente;  
      
      SELECT * FROM facturas; 
      DROP  FUNCTION IF EXISTS factura_precio_total;
DELIMITER $$
	CREATE FUNCTION factura_precio_total (id_factura INT)
	RETURNS DECIMAL(10,2)
	READS SQL DATA
/*NO SQL*/
/*DETERMINISTIC*/
/*NO ETERMINISTIC*/
	BEGIN
      DECLARE total DECIMAL(10,2);
        SELECT precio_total INTO total FROM facturas WHERE id_factura = id_factura;
      RETURN total;
      END
      $$

SELECT fecha ,factura_precio_total (id_factura) AS 'Total' FROM facturas;


SELECT * FROM facturas;
SELECT * FROM equipo;

/*=============
STORED PROCEDURE
===============*/

## SP CON PARAMETRO DE SALIDA
 
 -- Elimina el procedimiento almacenado si ya existe
DROP PROCEDURE IF EXISTS sp_get_count_facturas;


DELIMITER //

-- Crea el procedimiento almacenado
CREATE PROCEDURE sp_get_count_facturas(OUT p_total DECIMAL)
BEGIN
    -- Ejecuta una consulta para obtener el conteo de filas en la tabla 'facturas'
    SELECT COUNT(*) INTO p_total FROM facturas;
END //

-- Restaura el delimitador al valor predeterminado
DELIMITER ;

 
 -- LLAMAMOS AL SP OUT


-- Llamar al procedimiento almacenado y pasar la variable de salida como parámetro
SELECT @variable_resultado = 0;
CALL sp_get_count_facturas(@variable_resultado);
-- Usar el valor de la variable de salida
SELECT @variable_resultado AS total_facturas;


 DELIMITER //
-- Crea el procedimiento con el parametro de entrada
CREATE PROCEDURE sp_get_by_precio_total(IN p_precio_total DECIMAL)
BEGIN
    -- Verifica si el precio total es mayor o igual a 175.99
    IF p_precio_total >= 175.99 THEN
        -- Si es verdadero, ejecuta la siguiente consulta
        SELECT * FROM facturas WHERE precio_total >= p_precio_total ORDER BY precio_total DESC;
    ELSE
        -- Si es falso, ejecuta esta otra consulta
        SELECT * FROM facturas WHERE precio_total <= p_precio_total ORDER BY precio_total DESC;
    END IF;
END //

DELIMITER ;
CALL sp_get_by_precio_total (175.99);


/*=========
TRIGGER
===========*/

SELECT * FROM cliente;
/*REALIZAMOS UN HISTORICO DE CLIENTE*/
CREATE TABLE IF NOT EXISTS historico_cliente(
idHistoricoCliente INT PRIMARY KEY AUTO_INCREMENT,
idCliente INT,
nombre VARCHAR(200),
apellido VARCHAR(200),
fechaHora datetime,
operacion VARCHAR(200)
);
SELECT * FROM historico_cliente;
   -- Elimina el trigger si ya existe
DROP TRIGGER IF EXISTS trigger_alta_cliente;
DELIMITER //

-- Crea el trigger
CREATE TRIGGER trigger_alta_cliente
AFTER INSERT ON cliente
FOR EACH ROW
BEGIN
    -- Inserta una nueva fila en la tabla 'historico_cliente' con información sobre la operación de alta
    INSERT INTO historico_cliente(idCliente, nombre, apellido, fechaHora, operacion)
    VALUES (NEW.id_cliente, NEW.nombreCompleto, NEW.apellidoCompleto, NOW(), 'ALTA');
END //


DELIMITER ;
SELECT * FROM cliente;
INSERT INTO cliente VALUES (null, 'David', 'Real', 'dr@gmail.com','xxxxxxxx','Santa Cuz');
INSERT INTO cliente VALUES (null, 'Leo', 'Gomez', 'lg@gmail.com','xxxxxxxx','San Luis');
INSERT INTO cliente VALUES (null, 'Martina', 'Alonzo', 'ma@gmail.com','xxxxxxxx','La Rioja');
INSERT INTO cliente VALUES (null, 'Flor', 'Diaz', 'fd@gmail.com','xxxxxxxx','La Pampa');

/*=================
TIGGER DE MODIFICACION
==================*/




DROP TRIGGER IF EXISTS trigger_modificacion_cliente ;
DELIMITER //

-- Crea el trigger
CREATE TRIGGER trigger_modificacion_cliente
AFTER UPDATE ON cliente
FOR EACH ROW
BEGIN
    -- Inserta una nueva fila en la tabla 'historico_cliente' con información sobre la operación de alta
    INSERT INTO historico_cliente(idCliente, nombre, apellido, fechaHora, operacion)
    VALUES (NEW.id_cliente, NEW.nombreCompleto, NEW.apellidoCompleto, NOW(), 'MODIFICACION');
END //


DELIMITER ;

SELECT * FROM cliente;
UPDATE cliente
SET apellidoCompleto ='Perez'
WHERE id_cliente = 4;

SELECT * FROM historico_cliente;









    

























