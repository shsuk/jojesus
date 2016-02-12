UPDATE voj_board
SET

	security = 'N'
	
WHERE bd_id=@{bd_id} 
	and '${session.myGroups['admin']}'='true'
;
