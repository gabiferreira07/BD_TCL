create database bd_exporta;
use bd_exporta;

create table departamento(
	id int primary key auto_increment not null,
    nome varchar(50),
    localizacao varchar(50),
    orcamento decimal(10,2)
);

insert into  departamento(nome, localizacao, orcamento) values
	("RH", "São Paulo", 50000.00),
    ("Financeiro", "Rio de Janeiro", 75000.00),
    ("Markenting", "Belo Horizonte", 60000.00),
    ("TI", "Curitiba", 90000.00),
    ("Vendas", "Porto Alegre", 45000.00);
    
select * from departamento
INTO outfile 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\depto.csv'
fields terminated by ',' enclosed by '"'
lines terminated by '\n';

show variables like 'secure_file_priv';

#IMPORTA ARQUIVO .csv EXPORTADO
load data infile 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\depto.csv'
into table departamento
fields terminated by ',' enclosed by '"'
lines terminated by '\n';

-- INICIO DA TRANSAÇÃO
start transaction;

-- AUMENTAR O ORÇAMENTO DO DEPARTAMENTO DE TI EM 1000
update departamento set orcamento = orcamento + 1000.00 where nome = 'TI';

-- AUMENTARO ORÇAMENTO DO DEPARTAMENTO FINANCEIRO EM 1000
update departamento set orcamento = orcamento + 1000.00 where nome = 'Financeiro';

-- CONFIRMAR A TRANSAÇÃO
commit;

-- INICIO DA TRANSAÇÃO
start transaction;

-- REDUZIR O ORÇAMENTO DO DEPARTAMENTO DE MARKENTING EM 5000
update departamento set orcamento = orcamento - 5000.00 where nome = 'Markenting';

-- REDUZIR O ORÇAMENTO DO DEPARTAMENTO DE VENDAS EM 3000
update departamento set orcamento = orcamento - 3000.00 where nome = 'Vendas';

-- CANCELAR A TRANSAÇÃO
rollback;

-- INICIO DA TRANSAÇÃO
start transaction;

-- AUMENTAR O ORÇAMENTO DO DEPARTAMENTO DE RH EM 7000
update departamento set orcamento = orcamento + 7000.00 where nome = 'RH';

-- DEFINIR UM PONTO INTERMEDIÁRIO
savepoint ajuste_parcial;

-- AUMENTARO ORÇAMENTO DO DEPARTAMENTO VENDAS EM 2000
update departamento set orcamento = orcamento + 2000.00 where nome = 'Vendas';

-- REVERTER PARA O PONTO INTERMEDIÁRIO (DESFAZ O AUMENTO DO ORÇAMENTO DE VENDAS)
rollback to ajuste_parcial;

-- CONFIRMAR A TRANSAÇÃO
commit;