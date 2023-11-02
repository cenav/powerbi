-- MAESTRO CLIENTES -- (1) dim_clientes.csv
select c.cod_cliente, replace(c.nombre, ',', ' ') as nombre, c.zona
     , get_descripcion_zona(c.zona) as descri_zona, c.alm_cons as tipo_cliente, tab_aux(
      decode(length(c.giro), 4, substr(c.giro, 1, 2), substr(c.giro, 1, 1)) || '00', '27') as sector
     , tab_aux(c.giro, '27') as giro_cliente, c.grupo as grupo_cliente
     , get_cliente_grupo(c.grupo) as descri_grupo_cliente, tab_aux_obs(c.pais, 25) as pais
     , tab_aux(c.pais, 25) as descri_pais, get_ubigeo_dpt(c.cod_ubc, 'D') as region
     , get_ubigeo_dpt(c.cod_ubc, 'P') as provincia, get_ubigeo_dpt(c.cod_ubc, 'T') as distrito
     , null as latitud, null as longitud
  from clientes c
 order by 1;


-- PRESUPUESTO ---- (2) dim_presupuesto.csv
select ano, mes, division, cod_vende, pspto_dolar
  from pbi_presupuesto
 order by 1, 2, 3, 4;

--- Productos  ---- (3) dim_producto.csv
select a.cod_art as codigo_producto, replace(a.descripcion, ',', ' ') as nombre_producto
     , a.cod_lin as linea_producto
     , replace(get_deslinea(a.cod_lin), ',', ' ') as descri_lineaproducto, a.grupo as grupo_producto
     , replace(get_desgrupo(a.grupo), ',', ' ') as descri_grupoproducto
     , get_marca_articulo(a.cod_art) as marca_producto, decode(get_codmegagrupo(a.grupo), '1',
                                                               'DIESEL', '2', 'HIDRAULICA', '3',
                                                               'FILTRO', 'OTROS') as gran_grupo
     , a.tp_art as tipo_producto
  from articul a;


--- Vendedores ---- (4) dim_vendedor.csv
-- select x_especial || v.cod_vendedor as cod_vendedor, v.nombre as nombre_vendedor, decode(
select v.cod_vendedor as cod_vendedor, v.nombre as nombre_vendedor, decode(
    v.supervisor, '01', 'GERENTE DIESEL', '61', 'GERENTE HIDRAULICA', '62', 'GERENTE DIESEL',
    'OTROS') as supervisor
     , v.gerente, decode(v.indicador1, '1', 'FFVV DIESEL', '2', 'FFVV HIDRAULICA',
                         'X ASIGNAR') as ffvv
     , decode(v.estado, '1', 'ACTIVO', 'DE BAJA') as situacion
  from vendedores v
--WHERE V.COD_VENDEDOR < '99'
 order by 1;

--- VENTAS      -- (5)th_ventas.csv
select to_char(d.fecha, 'DD/MM/YYYY') as fecha, tab_abre(d.tipodoc, '02') as tipodoc, d.serie
     , d.numero, decode(d.serie, '2', 'SERV.', '3', 'VTA.RPTOS.', '10', 'VTA.RPTOS.', 'F050',
                        'VTA.RPTOS.', 'F052', 'ADMIN.', 'F053', 'VTA.DIST.GRATUITA',
                        'F055', 'VTA.EXPORTACION', 'F060', 'SERV.HIDRAULICA', 'F061', 'SERV.DIESEL',
                        'F070', 'VTA.EXPRESS', 'F071', 'VTA.RPTOS.',
                        'B050', 'VTA.RPTOS.', 'B052', 'ADMIN.', 'B053', 'VTA.DIST.GRATUITA', 'B071',
                        'VTA.RPTOS.',
                        'B055', 'VTA.EXPORTACION', 'B060', 'SERV.HIDRAULICA', 'B061', 'SERV.DIESEL',
                        'B070', 'VTA.EXPRESS') as tipo_venta
     , i.cod_art, d.cod_cliente, d.cod_vende as cod_vende, d.moneda, d.import_cam as tipo_cambio
     , (decode(d.moneda, 'D', i.neto, round(i.neto / d.import_cam, 2))) as neto_dolar
     , (pr_cos_mes_hdi(i.cod_art, d.fecha, 'D') * i.cantidad) as total_costo_dolar, i.cantidad
     , null as tipo_servicio, i.cod_eqi as codigo_equivalente, decode(d.tipodoc, '07',
                                                                      decode(d.tp_transac_kardex,
                                                                             '21', 'VENTA', '14',
                                                                             'DEVOL.MERCADERIA',
                                                                             'DSCTO.')) as tipo_mov
  from docuvent d
     , itemdocu i
 where d.tipodoc = i.tipodoc
   and d.serie = i.serie
   and d.numero = i.numero
   and d.tipodoc in ('01', '03', '07')
   and d.estado <> '9'
   and d.cond_pag <> 'W'
   and d.fecha >= to_date('01/01/2023', 'dd/mm/yyyy')
 order by 1, 2;

