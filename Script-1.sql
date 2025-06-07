--CREATE OR REPLACE VIEW public.vw_egresados_media
--AS SELECT em."MRUN",
--    em."AGNO_EGRESO",
--    em."RBD",
--    em."COD_DEPE",
--    em."NEM",
--    em."PERCENTIL",
--    em."PUESTO_10",
--    em."PUESTO_30",
--    c."COD_COM_RBD",
--    c."NOM_COM_RBD"
--   FROM egresados_media em
--     JOIN colegio c ON em."RBD" = c."RBD" AND em."AGNO_EGRESO" = c."AGNO" AND NOT (em."MRUN" IN ( SELECT em_1."MRUN" AS mrun
--           FROM egresados_media em_1
--          GROUP BY em_1."MRUN"
--         HAVING count(*) > 1));

--CREATE OR REPLACE VIEW public.vw_matricula
--AS SELECT cat_periodo,
--    "MRUN",
--    gen_alu,
--    fec_nac_alu,
--    rango_edad,
--    anio_ing_carr_ori,
--    anio_ing_carr_act,
--    tipo_inst_2,
--    tipo_inst_3,
--    cod_inst,
--    nomb_inst,
--    comuna_sede,
--    nivel_global,
--    cod_carrera,
--    nomb_carrera,
--    dur_total_carr
--   FROM matricula m
--  WHERE tipo_inst_2 = 'Universidades CRUCH'::text AND nivel_global = 'Pregrado'::text;

select distinct em."AGNO_EGRESO" from egresados_media em;

select distinct c."AGNO" from colegio c;


select COUNT(*) from egresados_media em
inner join colegio c on em."RBD" = c."RBD" and em."AGNO_EGRESO" = c."AGNO"
;
select COUNT(distinct em."MRUN") from egresados_media em
inner join colegio c on em."RBD" = c."RBD" and em."AGNO_EGRESO" = c."AGNO"
;
SELECT em."MRUN"AS mrun
FROM egresados_media em
GROUP BY em."MRUN"
HAVING COUNT(*) > 1;

select * from egresados_media em
where em."MRUN" in (SELECT em."MRUN"AS cantidad
FROM egresados_media em
GROUP BY em."MRUN"
HAVING COUNT(*) > 1);

select em."MRUN", em."AGNO_EGRESO", em."RBD", em."COD_DEPE", em."NEM", em."PERCENTIL", em."PUESTO_10", em."PUESTO_30", c."COD_COM_RBD", c."NOM_COM_RBD" from egresados_media em
inner join colegio c on em."RBD" = c."RBD" and em."AGNO_EGRESO" = c."AGNO"
--where em."AGNO_EGRESO" = 2023
and em."MRUN" not in (
	SELECT em."MRUN"AS mrun
	FROM egresados_media em
	GROUP BY em."MRUN"
	HAVING COUNT(*) > 1
	)
;

--select m.cat_periodo, m."MRUN", m.gen_alu, m.fec_nac_alu, m.rango_edad, m.anio_ing_carr_ori, m.anio_ing_carr_act , m.tipo_inst_2 , m.tipo_inst_3 , m.cod_inst , m.nomb_inst , m.comuna_sede, m.nivel_global from matricula m;
--select * from vw_matricula vm
--where vm.cat_periodo = 2024; 


select *  from vw_matricula m inner join vw_egresados_media vem on m."MRUN" = vem."MRUN" and m.cat_periodo = vem."AGNO_EGRESO" + 1
--where m.cat_periodo = 2024
--order by m."MRUN" desc

;

select vem."NOM_COM_RBD" , count(*) as num_alumnos from vw_matricula m inner join vw_egresados_media vem on m."MRUN" = vem."MRUN" and m.cat_periodo = vem."AGNO_EGRESO" + 1
where m.cod_inst = 71 and m.cat_periodo = 2022
group by "NOM_COM_RBD"
order by num_alumnos desc
;

select nem."AGNO_EGRESO", nem."RBD", nem."MRUN", es.cat_periodo, es."MRUN", es.nomb_inst, es.nomb_carrera, c."NOM_COM_RBD" from (select * from vw_matricula vm
where vm.cat_periodo = 2022) AS es inner join (select * from egresados_media em where em."AGNO_EGRESO" = 2021) as nem on es."MRUN" = nem."MRUN"
left join colegio c on nem."RBD" = c."RBD" and c."AGNO" = nem."AGNO_EGRESO"
where es.nomb_inst = 'UNIVERSIDAD DE CHILE'
;

select c."NOM_COM_RBD" , count(*) as num_alumnos from (select * from vw_matricula vm
where vm.cat_periodo = 2018) AS es inner join (select * from egresados_media em where em."AGNO_EGRESO" = 2017) as nem on es."MRUN" = nem."MRUN"
left join colegio c on nem."RBD" = c."RBD" and c."AGNO" = nem."AGNO_EGRESO"
where es.cod_inst = 70
group by "NOM_COM_RBD"
order by num_alumnos desc
;

-- OK
select nem."AGNO_EGRESO", nem."RBD", nem."MRUN", es.cat_periodo, es.nomb_inst, es.nomb_carrera, es.anio_ing_carr_ori, es.dur_total_carr, c."NOM_COM_RBD" from (select * from vw_matricula vm
where vm.cat_periodo = 2019) AS es inner join (select * from egresados_media em where em."AGNO_EGRESO" = 2018) as nem on es."MRUN" = nem."MRUN"
left join colegio c on nem."RBD" = c."RBD" and c."AGNO" = nem."AGNO_EGRESO"
order by es."MRUN" 
;
-- OK
select 
	nem."AGNO_EGRESO",
	nem."MRUN", 
	m.cat_periodo, 
	m.nomb_inst, 
	m.nomb_carrera, 
	m.anio_ing_carr_ori,
	vm_ultimo.ultimo_agno,
	c."NOM_COM_RBD" as comuna,
	nem."PERCENTIL",
	m.dur_total_carr/2 as duracion_carrera, 
	(vm_ultimo.ultimo_agno - m.anio_ing_carr_ori + 1) as permanencia
from (select * from vw_matricula vm where vm.cat_periodo = 2018) AS m 
inner join (select * from egresados_media em where em."AGNO_EGRESO" = 2017) as nem 
on m."MRUN" = nem."MRUN"
left join colegio c on nem."RBD" = c."RBD" and c."AGNO" = nem."AGNO_EGRESO"
left join (
			select 
				vm."MRUN", 
				max(vm.cat_periodo) as ultimo_agno  
			from vw_matricula vm 
			where vm.anio_ing_carr_ori = vm.anio_ing_carr_act 
			group by vm."MRUN") as vm_ultimo 
on m."MRUN" = vm_ultimo."MRUN"
where m.dur_total_carr > 4
order by m."MRUN" 
;

select 
	nem."AGNO_EGRESO",
	nem."MRUN", 
	m.cat_periodo, 
	m.nomb_inst,
	M.comuna_sede,
	m.nomb_carrera, 
	m.anio_ing_carr_ori,
	vm_ultimo.ultimo_agno,
	c."NOM_COM_RBD" as comuna,
	c."COD_REG_RBD" as region, 
	c."LATITUD" ,
	c."LONGITUD",
	nem."PERCENTIL",
	m.dur_total_carr/2 as duracion_carrera,
	(vm_ultimo.ultimo_agno - m.anio_ing_carr_ori + 1) as permanencia,
	((vm_ultimo.ultimo_agno - m.anio_ing_carr_ori + 1) / (m.dur_total_carr/2.0)) as pct_permanencia
from (select * from vw_matricula vm where vm.cat_periodo = 2018) AS m 
inner join (select * from egresados_media em where em."AGNO_EGRESO" = 2017) as nem 
on m."MRUN" = nem."MRUN"
left join colegio c on nem."RBD" = c."RBD" and c."AGNO" = nem."AGNO_EGRESO"
left join (
			select 
				vm."MRUN", 
				max(vm.cat_periodo) as ultimo_agno  
			from vw_matricula vm 
			where vm.anio_ing_carr_ori = vm.anio_ing_carr_act 
			group by vm."MRUN") as vm_ultimo 
on m."MRUN" = vm_ultimo."MRUN"
where m.dur_total_carr > 4 and c."COD_REG_RBD" = 13
order by m."MRUN" 
;


select 
	consolidado.comuna,
	COUNT(CASE WHEN consolidado.pct_permanencia < 1 THEN 1 END) AS desertores, count(*) as total,
	COUNT(CASE WHEN consolidado.pct_permanencia < 1 THEN 1 END)::REAL / count(*) as porcentaje_desertores
	from 
		(select 
		nem."AGNO_EGRESO",
		nem."MRUN", 
		m.cat_periodo, 
		m.nomb_inst,  
		m.nomb_carrera, 
		m.anio_ing_carr_ori,
		vm_ultimo.ultimo_agno,
		c."NOM_COM_RBD" as comuna,
		c."LATITUD" ,
		c."LONGITUD",
		nem."PERCENTIL",
		m.dur_total_carr/2 as duracion_carrera,
		(vm_ultimo.ultimo_agno - m.anio_ing_carr_ori + 1) as permanencia,
		((vm_ultimo.ultimo_agno - m.anio_ing_carr_ori + 1) / (m.dur_total_carr/2.0)) as pct_permanencia
	from (select * from vw_matricula vm where vm.cat_periodo = 2018) AS m 
	inner join (select * from egresados_media em where em."AGNO_EGRESO" = 2017) as nem 
	on m."MRUN" = nem."MRUN"
	left join colegio c on nem."RBD" = c."RBD" and c."AGNO" = nem."AGNO_EGRESO"
	left join (
				select 
					vm."MRUN", 
					max(vm.cat_periodo) as ultimo_agno  
				from vw_matricula vm 
				where vm.anio_ing_carr_ori = vm.anio_ing_carr_act 
				group by vm."MRUN") as vm_ultimo 
	on m."MRUN" = vm_ultimo."MRUN"
	where m.dur_total_carr > 4 and c."COD_REG_RBD" = 13
	order by m."MRUN") as consolidado
	group by consolidado.comuna 
	order by porcentaje_desertores desc
;




