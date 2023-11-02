--- MAESTRO DE PROVEEDORES  (1) --  hdi_proveedores
select cod_proveed as codigo_proveedor, ruc as ruc_proveedor, replace(nombre, ',', ' ') as nombre
     , replace(direccion, ',', ' ') as direccion, pais as codigo_pais
     , tab_aux(p.pais, '25') as pais_proveedor, get_ubigeo_dpt(p.cod_ubc, 'D') as dpto
     , get_ubigeo_dpt(p.cod_ubc, 'P') as provincia, get_ubigeo_dpt(p.cod_ubc, 'T') as distrito
     , p.cod_ubc
  from proveed p
 order by 1;

-- MAESTRO DE CUENTAS DE BANCOS   (2)    --  hdi_cuentas_bancos
select c.codigo, replace(c.descripcion, ',', ' ') as descripcion, c.cuenta as cuenta_contable
     , c.moneda, tab_aux(c.moneda, '60') as descri_moneda, banco
     , tab_aux(c.banco, '11') as descri_banco, c.tipo_cuenta
     , tab_aux(c.tipo_cuenta, '12') as descri_tipo_cuenta, c.n_cta_cte as numero_cuenta_corriente
  from ctabnco c
 order by 1;

--MAESTRO DE CENTRO DE COSTOS  (3) ---- hdi_centro_costos
select centro_costo, replace(nombre, ',', ' ') as nombre
  from centro_de_costos
 order by 1;

--- CONDICION DE PAGO CTA CTE CLIENTES -- (4) hdi_condpag_clientes
select distinct (f.cond_pag) as condicion_pago, replace(p.descripcion, ',', ' ') as descripcion
  from factcob f
     , condpag p
 where f.cond_pag = p.cond_pag
 order by 2;

--- CONDICION DE PAGO CTA CTE  PROVEEDORES (5) -- hdi_condpag_ctacte_proveedores
select cond_pag as condicion_pago, replace(descripcion, ',', ' ') as descripcion
  from lg_condpag
 order by 2;

---  CUENTA CORRIENTE  CLIENTES   FACTCOB  con SALDO  (6)   ARCHIVO hdi_cta_cte_Clientes
select f.cod_cliente, f.tipdoc, f.serie_num, f.numero, to_char(f.fecha, 'DD/MM/YYYY') as fecha
     , to_char(f.f_vencto, 'DD/MM/YYYY') as f_vencto
     , to_char(f.f_aceptacion, 'DD/MM/YYYY') as f_aceptacion
     , to_char(f.f_transfe, 'DD/MM/YYYY') as f_transfe, f.ano, f.mes, f.libro, f.voucher, f.item
     , f.tipo_referencia, f.serie_ref, f.nro_referencia, replace(f.concepto, ',', ' ') as concepto
     , f.sistema_origen, f.vended, f.banco, f.l_agencia, f.l_refbco, f.l_condle, f.moneda, f.importe
     , f.tcam_imp, f.saldo, f.tcam_sal, f.numero_canje, f.estado, f.ctactble, f.importex, f.saldox
     , f.numero_factura_unix, f.cobrador, to_char(f.f_cobranza, 'DD/MM/YYYY') as f_cobranza
     , f.cond_pag, to_char(f.fecha_origen, 'DD/MM/YYYY') as fecha_origen, f.igv, f.gasban
     , to_char(f.f_incobrable, 'DD/MM/YYYY') as f_incobrable, f.vended_origen, f.unidad_negocio
     , f.situacion, f.origen, f.imp_percep, f.por_percep, f.factor_dist
  from factcob f
 where f.fecha between to_date('01/01/2023', 'dd/mm/yyyy') and to_date('01/01/2099', 'dd/mm/yyyy')
    or f.saldo <> 0;

---- CANCELACIONES  CLIENTES   (7)  ARCHIVO hdi_cta_cte_Clientes_cancelacion
select c.tipdoc, c.serie_num, c.numero, to_char(c.fecha, 'DD/MM/YYYY') as fecha, c.ano, c.mes
     , c.libro, c.voucher, replace(c.concepto, ',', '-') as concepto_pago, c.forma_pago, c.banco
     , c.cheque, c.sistema_origen, c.moneda as moneda_pago, c.importe as importe_pago
     , c.tipo_cambio as tipo_cambio_pago, c.tipo_referencia, c.serie_ref, c.nro_referencia
     , c.importe_x
  from cabfcob c
 where fecha between to_date('01/01/2023', 'dd/mm/yyyy') and to_date('01/01/2099', 'dd/mm/yyyy')
   and c.libro <> '05';

----  CUENTA CORRIENTE PROVEEDORES  (8)  ARCHIVO hdi_cta_cte_proveedores
select cod_proveedor, tipdoc, serie_num, numero, to_char(fecha, 'DD/MM/YYYY') as fecha
     , to_char(f_vencto, 'DD/MM/YYYY') as f_vencto
     , to_char(f_aceptacion, 'DD/MM/YYYY') as f_aceptacion
     , to_char(f_transfe, 'DD/MM/YYYY') as f_transfe, ano, mes, libro, voucher, item
     , tipo_referencia, serie_ref, nro_referencia, replace(concepto, ',', ' ') as concepto
     , sistema_origen, banco, l_agencia, l_refbco, l_condle, moneda, pventa, tcam_imp, saldo
     , tcam_sal, numero_canje, estado, ctactble, pventax, saldox, codigo_unidad_negocio
     , codigo_grupo_compra, forma_de_pago
  from factpag
 where fecha between to_date('01/01/2023', 'dd/mm/yyyy') and to_date('01/01/2099', 'dd/mm/yyyy')
--    where fecha between '01-01-2023' and '01-01-2099'
    or saldo <> 0;

----  CANCELACION DOCUMENTOS PROVEEDORES   (9) ARCHIVO  hdi_cta_cte_proveedores_cancelacion
select cod_proveedor, tipdoc, serie_num, numero, to_char(fecha, 'DD/MM/YYYY') as fecha, ano, mes
     , libro, voucher, item, tipo_referencia, serie_ref, nro_referencia
     , replace(concepto, ',', ' ') as concepto, forma_pago, banco, cheque, sistema_origen, moneda
     , importe, importe_x, tipo_cambio, estado
  from cabfpag
 where fecha between '01/01/2023' and '31/12/2099'
   and libro <> '39';

--- MOVIMIENTO DE  BANCOS  (10) -- ARCHIVO  HDI-MOVIMIENTO-COMPRAS
select ano, mes, libro, voucher, cuenta, tipo_cambio, tipo_relacion, relacion, tipo_referencia
     , nro_referencia, to_char(fecha, 'DD/MM/YYYY') as fecha, replace(detalle, ',', ' ') as detalle
     , cargo_s, abono_s, cargo_d, abono_d, estado, columna, generado, usuario
     , to_char(fec_reg, 'DD/MM/YYYY') as fec_reg, tipo_mov, serie
     , to_char(f_vencto, 'DD/MM/YYYY') as f_vencto, cambio, file_cta_cte
  from movdeta
 where ano >= 2022
   and mes in (1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12)
   and libro = '08'
   and estado <> 9;

--- MOVIMIENTO DE  BANCOS   (11) -- ARCHIVO  HDI-MOVIMIENTO-BANCO
select ano, mes, tipo, voucher, item, cuenta, etipor, ecodigo, etipo, eserie, enumero
     , to_char(fecha, 'DD/MM/YYYY') as fecha, cargo_s, abono_s, cargo_d, abono_d, banco
     , file_cta_cte, replace(detalle, ',', ' ') as detalle, estado, generado, usuario
     , to_char(fec_reg, 'DD/MM/YYYY') as fec_reg, tipo_mov, estado_banco, ano_concil, mes_concil
     , cambio, cobrador, operacion, cuenta_retencion, to_char(f_vencto, 'DD/MM/YYYY') as f_vencto
     , unidad_negocio, vendedor
  from movfide
 where ano >= 2022
   and mes in (1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12)
   and estado <> 9;

-- TIPO DOCUMENTOS  (12)  -- hdi_tipo_documentos
select tipo, codigo, replace(descripcion, ',', ' ') as descripcion, abreviada
  from tablas_auxiliares
--WHERE DESCRIPCION LIKE 'LIBROS%'
 where tipo = '2'
   and codigo <> '....'
 order by 2;

