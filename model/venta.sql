select d.tipodoc, d.serie, d.numero, d.fecha, d.cod_vende, d.cod_cliente, d.cta_pvta, d.moneda
     , d.import_cam, i.cod_art, i.cantidad, i.precio_de_lista, i.por_desc1, i.por_desc2, i.por_desc3
     , i.descuento, i.neto
     , decode(d.moneda, 'D', i.neto, round(i.neto / d.import_cam, 2)) as neto_dolar
     , (pr_cos_mes_hdi(i.cod_art, d.fecha, 'D') * i.cantidad) as total_costo_dolar
     , (decode(d.moneda, 'D', i.neto, round(i.neto / d.import_cam, 2)) -
        (pr_cos_mes_hdi(i.cod_art, d.fecha, 'D') * i.cantidad)) as margen_dolar
     , c.cred_usado as credito_usado, d.cond_pag
     , d.tip_doc_ref as tipo_referencia
     , d.ser_doc_ref as serie_referencia
     , d.nro_doc_ref as numero_referencia
     , d.detalle
  from docuvent d
       join itemdocu i on d.tipodoc = i.tipodoc and d.serie = i.serie and d.numero = i.numero
       join clientes c on d.cod_cliente = c.cod_cliente
 where extract(year from d.fecha) = 2023;


select *
  from sistabgen
 where sisdatdes like '%VENTA%';