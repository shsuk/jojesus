/* {
 	id:'i', action:'i'
} */
	INSERT INTO menu01_tbl(
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
	UPDATE menu01_tbl
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
	UPDATE menu01_tbl
	SET del_yn = 'Y'
	WHERE menu_id = :menu_id;

/* {
	id:'row', action:'v', singleRow="true"
} */
	SELECT  *
	FROM menu01_tbl
	WHERE menu_id= :menu_id
	;

/* {
 	id:'rows', action:'l'
 } */

	SELECT t1.*,(SELECT count(menu_id) FROM menu01_tbl t2	WHERE upp_menu_id = t1.menu_id and del_yn = 'N') menu_count
	FROM menu01_tbl t1
	WHERE upp_menu_id = ${empty(upp_menu_id) ? "'root'" : ':upp_menu_id'} and del_yn = 'N'
	ORDER BY order_no
;

/* {
 	id:'main_rows', action:'m'
 } */

	SELECT t1.*
	FROM menu01_tbl t1
	WHERE upp_menu_id = 'root' 
		and del_yn = 'N'
	ORDER BY order_no
;
/* {
 	id:'sub_rows', action:'m'
 } */

	SELECT t1.*
	FROM menu01_tbl t1
	WHERE upp_menu_id = (SELECT upp_menu_id FROM menu01_tbl t2 WHERE menu_id = :menu_id)
		and page_access_group like concat('%', :user_group, '%')  
		and del_yn = 'N' 
	ORDER BY order_no
;
/* {
 	id:'access_row', action:'m', singleRow="true"
 } */

	SELECT count(menu_id) access_menu
	FROM menu01_tbl t1
	WHERE page_url = :request.servletpath
;
