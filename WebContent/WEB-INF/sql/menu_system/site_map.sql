/* {
 	id:'rows', action:'site_map'
 } */
	SELECT SQL_CALC_FOUND_ROWS
		notice_id,
		subject,
		concat(concat(DATE_FORMAT(stt_dt,'%Y-%m-%d'), ' ~ '),  DATE_FORMAT(end_dt,'%Y-%m-%d')) noti_dt,
		use_yn,
		qry_cnt,
		reg_id,
		DATE_FORMAT(reg_dt,'%Y-%m-%d') reg_dt,
		chg_id,
		DATE_FORMAT(chg_dt,'%Y-%m-%d') chg_dt
	FROM sys_notice_m t1
	WHERE use_yn = 'Y' 
		/*and stt_dt > now() and end_dt < now()*/
	ORDER BY notice_id desc
	LIMIT 0 , 3
;


/* {
 	id:'main_rows', action:'site_map'
 } */
//최상위 메뉴를 가지고 온다 
//페이지 접근권한이 있는 메뉴만 가지고 온다
SELECT t1.*
FROM SYS_MENU_M t1
JOIN SYS_ROLE_M t2 ON t1.menu_id = t2.menu_id and t2.role_cd = :role_cd
WHERE upp_menu_id = 'root' and del_yn = 'N' 
ORDER BY order_no
;
/* {
 	id:'sub_rows', action:'site_map'
 } */
//현재 접속한 페이지가 속한 서브메뉴들을 가지고 온다.
//페이지 접근권한이 있는 메뉴만 가지고 온다 
SELECT t1.*
FROM SYS_MENU_M t1
JOIN SYS_ROLE_M t2 ON t1.menu_id = t2.menu_id and t2.role_cd = :role_cd
WHERE upp_menu_id <> 'root' and del_yn = 'N' and level in (2, 2)
ORDER BY  upp_menu_id, level, order_no
;