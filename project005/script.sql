CREATE TABLE clientes (
   id_cliente SERIAL PRIMARY KEY,
   nombre VARCHAR(50) NOT NULL,
   apellido VARCHAR(50) NOT NULL,
   email VARCHAR(100) NOT NULL,
   telefono VARCHAR(15) NOT NULL,
   antiguedad_en_semanas INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE VIP (
   id_cliente SERIAL PRIMARY KEY,
   nombre VARCHAR(50) NOT NULL,
   facturacion DECIMAL(10,2) NOT NULL,
   FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)
);

CREATE TABLE ventas (
   id_venta SERIAL PRIMARY KEY,
   id_cliente INTEGER NOT NULL,
   precio_total DECIMAL(10,2) NOT NULL,
   para_regalo BOOLEAN NOT NULL DEFAULT false,
   fecha_venta DATE NOT NULL,
   FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)
);


INSERT INTO clientes (nombre, apellido, email, telefono, antiguedad_en_semanas)
VALUES ('Juan', 'Pérez', 'juanperez@gmail.com', '123456789', 3),
       ('María', 'González', 'mariagonzalez@hotmail.com', '987654321', 6),
       ('Pedro', 'Ramírez', 'pedroramirez@yahoo.com', '456123789', 2),
       ('Lucía', 'García', 'luciagarcia@gmail.com', '789123456', 8);

INSERT INTO VIP (id_cliente, nombre, facturacion)
VALUES (4, 'Lucía García', 180);

INSERT INTO ventas (id_cliente, precio_total, para_regalo, fecha_venta)
VALUES (1, 50.00, false, '2023-02-01'),
       (1, 100.00, true, '2023-02-10'),
       (2, 50.00, true, '2023-02-15'),
       (3, 75.00, true, '2023-02-20'),
       (4, 30.00, false, '2023-02-08'),
       (4, 150.00, false, '2023-02-19');


/* ------------------------------------------------------------------------------*/

EJERCICIO 1

CREATE OR REPLACE PROCEDURE actualizar_precio_venta()
LANGUAGE SQL
AS $$
   UPDATE ventas 
   SET precio_total = precio_total + 1 
   WHERE para_regalo = true;
$$;

CALL actualizar_precio_venta();


/* ------------------------------------------------------------------------------*/

EJERCICIO 2

actualizar_antiguedad_semanalmente.sql
UPDATE clientes SET antiguedad_en_semanas = antiguedad_en_semanas + 1;

ejecutar_actualizar_antiguedad_semanalmente.bat
@echo off
SET PGPASSWORD=XXXXXXX
psql -U postgres -d entrega3 -f actualizar_antiguedad_semanalmente.sql


/* ------------------------------------------------------------------------------*/

EJERCICIO 3

CREATE OR REPLACE FUNCTION actualizar_vip() RETURNS TRIGGER AS $$

DECLARE

   v_facturacion DECIMAL(10,2);
   v_antiguedad INTEGER;
   v_nombre VARCHAR(50);

BEGIN

   SELECT SUM(precio_total) INTO v_facturacion FROM ventas WHERE id_cliente = NEW.id_cliente;
   SELECT antiguedad_en_semanas INTO v_antiguedad FROM clientes WHERE id_cliente = NEW.id_cliente;
   SELECT nombre INTO v_nombre FROM clientes WHERE id_cliente = NEW.id_cliente;

   IF (v_facturacion > 100 AND v_antiguedad >=5) THEN
	IF EXISTS (SELECT 1 FROM VIP WHERE id_cliente = NEW.id_cliente) THEN
            UPDATE VIP SET facturacion = v_facturacion
            WHERE id_cliente = NEW.id_cliente;
        ELSE
            INSERT INTO VIP (id_cliente, nombre, facturacion) 
            VALUES (NEW.id_cliente, v_nombre, v_facturacion);
        END IF;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
	   
CREATE TRIGGER actualizar_vip_trigger
AFTER INSERT OR UPDATE ON ventas
FOR EACH ROW
EXECUTE FUNCTION actualizar_vip();


/* ------------------------------------------------------------------------------*/

EJERCICIO 4

CREATE VIEW vista_vip AS
SELECT c.nombre, c.apellido, v.facturacion
FROM clientes c
JOIN vip v ON c.id_cliente = v.id_cliente;

SELECT * FROM vista_vip


GRANT SELECT ON vista_vip TO sherlock;