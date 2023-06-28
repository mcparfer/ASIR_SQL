drop table descuento;
drop table supervisa;
drop table cuenta;
drop table medicamento;
drop table maquinacafe;
drop table farmaceuticos;
drop table laboratorio;

create table laboratorio(
    IDlab number(5,0)
        CONSTRAINT PK_laboratorio PRIMARY KEY
        CONSTRAINT CK_laboratorio_idlab CHECK (IDlab >= 100 AND IDlab < 1000),        
    Especialidad varchar2(20)
        CONSTRAINT NN_laboratorio_especialidad NOT NULL
);

create table farmaceuticos(
    DNI char(9)
        CONSTRAINT PK_farmaceuticos PRIMARY KEY
        CONSTRAINT CK_farmaceuticos_dni CHECK (REGEXP_LIKE(DNI,'[[:digit:]]{8}[[:upper:]]')),
    Nombre varchar2(40) 
        CONSTRAINT UQ_farmaceuticos_nombre UNIQUE
        CONSTRAINT NN_farmaceuticos_nombre NOT NULL,
    Telefono number (9,0)
        CONSTRAINT NN_farmaceuticos_telefono NOT NULL,
    IDlab number (5,0)
        CONSTRAINT NN_farmaceuticos_idlab NOT NULL
        CONSTRAINT FK_farmaceuticos_laboratorio REFERENCES laboratorio (IDlab),
    Puesto varchar2(20)
        CONSTRAINT NN_farmaceuticos_puesto NOT NULL
);

create table maquinacafe(
    NumSerie number(8,0)
        CONSTRAINT PK_maquinacafe PRIMARY KEY,
    IDlab number (5,0)
        CONSTRAINT NN_maquinacafe_idlab NOT NULL
        CONSTRAINT FK_maquinacafe_laboratorio REFERENCES laboratorio (IDlab)
);

create table medicamento(
    Codigo char(8)
        CONSTRAINT CK_medicamento_codigo CHECK (REGEXP_LIKE(Codigo,'[[:upper:]]{2}[[:digit:]]{4}')),
    IDlab number (5,0)
        CONSTRAINT FK_medicamento_laboratorio REFERENCES laboratorio (IDlab),
    FechaInicioProd date,
    FechaFinProd date
        CONSTRAINT NN_medicamento_fechafinprod NOT NULL,
    FechaCad date
        CONSTRAINT NN_medicamento_fechacad NOT NULL,
    Tipo varchar2(15)
        CONSTRAINT NN_medicamento_tipo NOT NULL,
    Forma varchar2(10),
    Color varchar2(10),
    DispAdm varchar2(10),
    
        
    CONSTRAINT PK_medicamento PRIMARY KEY (Codigo, IDlab, FechaInicioProd)
);

create table cuenta(
    Usuario char(9)
        CONSTRAINT PK_cuenta PRIMARY KEY
        CONSTRAINT CK_cuenta_usuario CHECK (REGEXP_LIKE(Usuario,'[[:lower:]]{7}[[:digit:]]{2}')),
    Contraseña char(8)
        CONSTRAINT UQ_cuenta_contraseña UNIQUE
        CONSTRAINT NN_cuenta_contraseña NOT NULL
        CONSTRAINT CK_cuenta_contraseña CHECK (REGEXP_LIKE(Contraseña,'[[:upper:]]{3}[[:lower:]]{3}[[:digit:]]{2}')),
    DNI char(9)
        CONSTRAINT UQ_cuenta_dni UNIQUE
        CONSTRAINT NN_cuenta_dni NOT NULL
        CONSTRAINT FK_cuenta_farmaceuticos REFERENCES farmaceuticos (DNI)
);

create table supervisa(
    DNIFarmaceutico char(9)
        CONSTRAINT PK_supervisa PRIMARY KEY
        CONSTRAINT FK_supervisafar_farmaceuticos REFERENCES farmaceuticos (DNI),
    DNISupervisor char(9)
        CONSTRAINT NN_supervisa_dnisupervisor NOT NULL
        CONSTRAINT FK_supervisasup_farmaceuticos REFERENCES farmaceuticos (DNI)
);

create table descuento(
    DNIFarmaceutico char(9)
        CONSTRAINT FK_descuento_farmaceuticos REFERENCES farmaceuticos (DNI),
    CodigoMed char(8),
    Año date,
    IDlab number (5,0),
    FechaInicioProd date,
    Descuento number(4,2)
        CONSTRAINT NN_descuento_descuento NOT NULL,
        
    CONSTRAINT PK_descuento PRIMARY KEY (DNIFarmaceutico, CodigoMed, Año),
    CONSTRAINT FK_descuento_medicamento FOREIGN KEY (CodigoMed, IDlab, FechaInicioProd) REFERENCES medicamento (Codigo, IDlab, FechaInicioProd)
);

ALTER TABLE medicamento 
    ADD CONSTRAINT CK_medicamento_dispadm CHECK (( Tipo = 'Aerosol' AND  DispAdm  is not null) OR Tipo <> 'Aerosol' )
    ADD CONSTRAINT CK_medicamento_color CHECK (( Tipo = 'Líquido' AND  Color  is not null) OR Tipo <> 'Líquido' )
    ADD CONSTRAINT CK_medicamento_forma CHECK (( Tipo = 'Sólido' AND  Forma  is not null) OR Tipo <> 'Sólido' );

ALTER TABLE medicamento
    ADD CONSTRAINT CK_medicamento_dateprod CHECK (FechaInicioProd < FechaFinProd)
    ADD CONSTRAINT CK_medicamento_datecad CHECK (FechaFinProd < FechaCad);