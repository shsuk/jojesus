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
	SELECT  notice_id,
		subject,
		contents,
		DATE_FORMAT(stt_dt,'%Y-%m-%d %T') stt_dt,
		DATE_FORMAT(end_dt,'%Y-%m-%d %T') end_dt,
		use_yn,
		qry_cnt,
		reg_id,
		DATE_FORMAT(reg_dt,'%Y-%m-%d %T') reg_dt,
		chg_id,
		DATE_FORMAT(chg_dt,'%Y-%m-%d %T') chg_dt
	FROM sys_notice_m
	WHERE notice_id= :notice_id
	;

/* {
 	id:'rows', action:'l'
 } */

	SELECT notice_id,
		subject,
		DATE_FORMAT(stt_dt,'%Y-%m-%d %T') stt_dt,
		DATE_FORMAT(end_dt,'%Y-%m-%d %T') end_dt,
		use_yn,
		qry_cnt,
		reg_id,
		DATE_FORMAT(reg_dt,'%Y-%m-%d %T') reg_dt,
		chg_id,
		DATE_FORMAT(chg_dt,'%Y-%m-%d %T') chg_dt
	FROM sys_notice_m t1
	WHERE use_yn = 'Y'
	ORDER BY notice_id desc
	LIMIT ${rows * (page - 1)} , ${rows}
;
/* {
 	id:'cnt', action:'l', singleRow="true"
 } */

	SELECT count(*) cnt
	FROM sys_notice_m t1
	WHERE use_yn = 'Y'
;

