-- vendedor
select v.cod_vendedor, v.nombre as nom_vendedor
  from vendedores v
 order by cod_vendedor;

-- grant select on pevisa.vendedores to powerbi;

-- grant create view to powerbi;