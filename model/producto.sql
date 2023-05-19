select a.cod_art, a.descripcion, a.grupo, g.descripcion as dsc_grupo, a.cod_lin
     , l.descripcion as dsc_linea, a.indicador, a.aplicacion
  from articul a
       left join tab_grupos g on a.grupo = g.grupo
       left join tab_lineas l on a.cod_lin = l.linea;