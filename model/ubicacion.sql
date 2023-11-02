-- ubicacion
select u.cod_ubc, u.nom_dpt as departamento, u.nom_pvc as provincia, u.nom_dtt as distrito
     , u.zona, x.descripcion as dsc_zona
  from ubigeo u
       left join tablas_auxiliares x on u.zona = x.codigo and x.tipo = '20';
