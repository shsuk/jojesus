
/*
 {key:'rows'}
 */
SELECT *
FROM mc_bible 
WHERE 
	${empty(req.nevi) ? '' : '--'} mc_dt = @{mc_dt}
	${req.nevi=='a' ? '' : '--'}   mc_dt > @{mc_dt}
	${req.nevi=='a' && req.mc_dt=='12-31' ? '' : '--'} or  mc_dt = '01-01'
	${req.nevi=='b' ? '' : '--'}   mc_dt < @{mc_dt}
	${req.nevi=='b' && req.mc_dt=='01-01' ? '' : '--'} or  mc_dt = '12-31' 
ORDER BY mc_dt ${req.nevi=='a' ? '' : 'desc'} , ca_name
LIMIT 0,4
;