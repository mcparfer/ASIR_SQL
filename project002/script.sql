/* Subconsultas (dos select) */

SELECT m.*, EXTRACT(YEAR FROM (select f.fechainicioprod from fabricacion f where m.codigomed = f.codigo)) AS "AÑO"
    FROM medicamentos m
    WHERE m.codigomed in (SELECT f.codigo
                        FROM fabricacion f
                        WHERE f.precio <= 10 and f.fechacad > '01/01/22');


/* Subconsultas (tres select) */

SELECT f.nombre, f.dni, f.telefono
    FROM farmaceuticos f
    WHERE f.dni in (SELECT d.dnifarmaceutico
                    FROM descuentos d
                    WHERE d.codigomed in (SELECT f2.codigo
                                            FROM fabricacion f2
                                            WHERE f2.idlab in ('200','300')));


/* Join con dos tablas */

SELECT f.idlab, ROUND(AVG(sueldo*12 + NVL(pagaextra,0)*2),2) AS "SALARIO MEDIO ANUAL"                                          
    FROM farmaceuticos f 
    INNER JOIN laboratorios l ON f.idlab = l.idlab
    GROUP BY f.idlab
    HAVING  ROUND(AVG(sueldo*12 + NVL(pagaextra,0)*2),2) > 18300;


/* Join con tres tablas */

SELECT f.nombre, f.dni, f.puesto, c.permisos
    FROM farmaceuticos f
        INNER JOIN cuentas c 
        ON f.dni = c.dni
        LEFT JOIN laboratorios l 
        ON f.idlab = l.idlab
        WHERE l.idlab IS NULL
    ORDER BY c.permisos DESC;


/* Funciones de grupos (AVG) */

SELECT año, COUNT(*) AS "CONTEO FARMACEÚTICOS", AVG(descuento), MAX(descuento), MIN(descuento)
    FROM descuentos
    GROUP BY año;


/* Funciones de grupos (MIN) */

SELECT idlab, tipo, min(fechacad) AS CADUCIDAD
    FROM fabricacion
    GROUP BY idlab, tipo;


/* Funciones de grupos (MAX) */

SELECT (SELECT l.especialidad FROM laboratorios l WHERE f.idlab = l.idlab), MAX(f.cantidad)
    FROM fabricacion f
    GROUP BY f.idlab;


/* Funciones de grupos (SUM) */

SELECT idlab, SUM(precio*cantidad) AS "COBRO"
    FROM fabricacion
    WHERE precio > 3 AND precio < 10
    GROUP BY idlab;
    

/* Funciones de grupos (COUNT) */

SELECT NVL(dnisupervisor,'Sin supervisor'), COUNT(*)
    FROM supervisa
    GROUP BY dnisupervisor;
    

/* Funciones de grupos y having (AVG) */ 

SELECT NVL(f.puesto,'Extrabajadores') AS PUESTO, AVG(c.permisos)
    FROM farmaceuticos f
    RIGHT JOIN cuentas c on c.dni = f.dni
    GROUP BY f.puesto
    HAVING AVG(c.permisos) > 3;


/* Funciones de grupos y having (MAX) */

SELECT NVL(idlab,0), ROUND(MAX(NVL(pagaextra,0)),2)
    FROM farmaceuticos
    GROUP BY idlab
    HAVING MAX(pagaextra) > (SELECT MIN(sueldo) 
                                FROM farmaceuticos
                                WHERE idlab = 300);
                                
                                
/* Funciones de grupos y having (MIN) */

SELECT l.especialidad, COUNT(*), SUM(sueldo), AVG(f.sueldo)
    FROM laboratorios l
    INNER JOIN farmaceuticos f ON f.idlab = l.idlab
    WHERE l.especialidad <> 'Dermatología'
    GROUP BY l.especialidad
    HAVING AVG(f.sueldo) <= (SELECT MAX(sueldo) 
                                FROM farmaceuticos f
                                where idlab = 300);
                                
SELECT *
    FROM farmaceuticos
    WHERE dni LIKE '%P' OR  dni LIKE '%H';
    
