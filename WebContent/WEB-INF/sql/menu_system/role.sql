/* {
 	id:'rows', action:'role'
 } */

	SELECT t1.*, 
		t2.role_cd, 
		acc_read,
		acc_save,
		acc_excel
	FROM SYS_MENU_M t1
	LEFT JOIN SYS_ROLE_M t2 ON t1.menu_id = t2.menu_id and  t2.role_cd = :role_cd
	WHERE  del_yn = 'N'
;

