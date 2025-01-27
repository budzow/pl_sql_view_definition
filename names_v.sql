CREATE OR REPLACE FORCE VIEW names_v
(
    first_name,
	first_last_name,
	second_last_name
)
AS
    SELECT 
		nombre as first_name,
		primer_appelido as first_last_name,
		segundo_appelido as second_last_name
	from datos_personales
		where nombre = 'ISAAC' and -- plsql:S1192 raises a FP here as it is not possible to declare constants inside a view defintion. In other words plsql:S1192 should not raise issues when inside view definition
			  primer_appelido = 'ISAAC' and
			  segundo_appelido = 'ISAAC';