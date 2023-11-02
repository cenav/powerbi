-- cliente
select c.cod_cliente, c.nombre as nom_cliente, c.fecha_ing
     , u.nom_dpt as departamento, u.nom_pvc as provincia, u.nom_dtt as distrito
     , c.zona, x.descripcion as dsc_zona, c.limite_cred, c.grupo, g.nombre as nom_grupo
  from clientes c
       left join ubigeo u on c.cod_ubc = u.cod_ubc
       left join tablas_auxiliares x on c.zona = x.codigo and x.tipo = '20'
       left join cliente_grupo g on c.grupo = g.grupo;
