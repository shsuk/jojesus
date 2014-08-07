/* {
 	id:'i', action:'i'
} */
	INSERT INTO SYS_MENU_M(
		menu_id,
		upp_menu_id,
		menu_name,
		page_url,
		page_access_group,
		order_no,
		reg_id,
		reg_dt,
		chg_id,
		chg_dt
	)VALUES(
		:menu_id,
		:upp_menu_id,
		:menu_name,
		:page_url,
		:page_access_group,
		:order_no,
		:session.user_id,
		now(),
		:session.user_id,
		now()
	);
/* {
	key:'cnt', action:'u'
} */
	UPDATE SYS_MENU_M
	SET 
		menu_name = :menu_name,
		page_url = :page_url,
		page_access_group = :page_access_group,
		order_no = :order_no,
		chg_id = :session.user_id,
		chg_dt = now()
	WHERE menu_id= :menu_id
	;

/* {
	id:'d', action:'d', desc:"데이타소스를 설정해야 하는 경우 'ds:dsname'와 같이 설정할수 있다." }
*/
	UPDATE SYS_MENU_M
	SET del_yn = 'Y'
	WHERE menu_id = :menu_id;

/* {
	id:'row', action:'v', singleRow="true"
} */
	SELECT  *
	FROM SYS_MENU_M
	WHERE menu_id= :menu_id
	;

/* {
 	id:'rows', action:'l'
 } */

	SELECT t1.*,(SELECT count(menu_id) FROM SYS_MENU_M t2	WHERE upp_menu_id = t1.menu_id and del_yn = 'N') menu_count
	FROM SYS_MENU_M t1
	WHERE upp_menu_id = ${empty(upp_menu_id) ? "'root'" : ':upp_menu_id'} and del_yn = 'N'
	ORDER BY order_no
;

/* {
 	id:'main_rows', action:'m'
 } */

	SELECT t1.*
	FROM SYS_MENU_M t1
	WHERE upp_menu_id = 'root' 
		and del_yn = 'N'
	ORDER BY order_no
;
/* {
 	id:'sub_rows', action:'m'
 } */

	SELECT t1.*
	FROM SYS_MENU_M t1
	WHERE upp_menu_id = (SELECT upp_menu_id FROM SYS_MENU_M t2 WHERE menu_id = :menu_id)
		and page_access_group like concat('%', :user_group, '%')  
		and del_yn = 'N' 
	ORDER BY order_no
;
/* {
 	id:'access_row', action:'m', singleRow="true"
 } */

	SELECT count(menu_id) access_menu
	FROM SYS_MENU_M t1
	WHERE page_url = :request.servletpath
;


/* {
 	id:'rows', action:'al'
 } */

	SELECT t1.*, 
		t2.acc_page, 
		acc_read,
		acc_save,
		acc_excel,
		(SELECT count(menu_id) FROM SYS_MENU_M t2	WHERE upp_menu_id = t1.menu_id and del_yn = 'N') menu_count
	FROM SYS_MENU_M t1
	LEFT JOIN SYS_ROLE_M t2 ON t1.menu_id = t2.menu_id and t2.role_cd = :role_cd
	WHERE upp_menu_id = ${empty(upp_menu_id) ? "'root'" : ':upp_menu_id'} and del_yn = 'N'
	ORDER BY order_no
;
/* {
 	id:'ia1', action:'acc'
} */
	INSERT INTO SYS_ROLE_M(
		menu_id,
		role_cd,
		acc_page,
		acc_read,
		acc_save,
		acc_excel
	)
	SELECT 
		x1.*
	FROM (SELECT 
		:menu_id menu_id,
		:role_cd role_cd,
		'Y' acc_page,
		:acc_read acc_read, 
		:acc_save acc_save, 
		:acc_excel acc_excel) x1
	WHERE 0 = (SELECT count(menu_id) FROM SYS_ROLE_M WHERE menu_id = :menu_id and role_cd = :role_cd)
	;
/* {
 	id:'ia1', action:'accbtn'
} */
	UPDATE SYS_ROLE_M
	SET
		acc_read = :acc_read,
		acc_save = :acc_save,
		acc_excel = :acc_excel
	WHERE menu_id = :menu_id and role_cd = :role_cd
	;
/* {
 	id:'ia2', action:'noacc'
} */
	DELETE FROM SYS_ROLE_M WHERE menu_id = :menu_id and role_cd = :role_cd
	;

