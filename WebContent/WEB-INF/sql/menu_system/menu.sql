/* {
 	id:'i', action:'i'
} */
//메뉴등록
INSERT INTO SYS_MENU_M(
	menu_id,
	upp_menu_id,
	menu_name,
	level,
	page_url,
	order_no,
	reg_id,
	reg_dt,
	chg_id,
	chg_dt
)VALUES(
	:menu_id,
	:upp_menu_id,
	:menu_name,
	:level,
	:page_url,
	:order_no,
	:session.user_id,
	now(),
	:session.user_id,
	now()
);
/* {
	key:'cnt', action:'u'
} */
//메뉴 수정
UPDATE SYS_MENU_M
SET 
	menu_name = :menu_name,
	page_url = :page_url,
	order_no = :order_no,
	chg_id = :session.user_id,
	chg_dt = now()
WHERE menu_id= :menu_id
;

/* {
	id:'d', action:'d', desc:"데이타소스를 설정해야 하는 경우 'ds:dsname'와 같이 설정할수 있다." }
*/
//메뉴삭제
UPDATE SYS_MENU_M
SET del_yn = 'Y'
WHERE menu_id = :menu_id;

/* {
	id:'row', action:'a', singleRow="true"
} */
//메뉴 조회
SELECT menu_name upp_menu_name
FROM SYS_MENU_M
WHERE menu_id= :upp_menu_id
;
/* {
	id:'row', action:'v', singleRow="true"
} */
//메뉴 조회
SELECT t1.*, (SELECT menu_name FROM SYS_MENU_M WHERE menu_id = t1.upp_menu_id) upp_menu_name
FROM SYS_MENU_M t1
WHERE t1.menu_id= :menu_id
;

/* {
 	id:'rows', action:'l'
 } */
//메뉴 목록 조회
SELECT t1.*,(SELECT count(menu_id) FROM SYS_MENU_M t2	WHERE upp_menu_id = t1.menu_id and del_yn = 'N') menu_count
FROM SYS_MENU_M t1
WHERE  del_yn = 'N'
ORDER BY level, order_no
;

/* {
 	id:'main_rows', action:'m'
 } */
//최상위 메뉴를 가지고 온다 
//페이지 접근권한이 있는 메뉴만 가지고 온다
//최상위 메뉴 클릭시 기본의로 이동할 페이지
SELECT t1.*
FROM SYS_MENU_M t1
JOIN SYS_ROLE_M t2 ON t1.menu_id = t2.menu_id and t2.role_cd = :role_cd
WHERE upp_menu_id = 'root' and del_yn = 'N' 
ORDER BY order_no
;
/* {
 	id:'sub_rows', action:'m'
 } */
//현재 접속한 페이지가 속한 서브메뉴들을 가지고 온다.
//페이지 접근권한이 있는 메뉴만 가지고 온다 
SELECT t1.*, (SELECT count(menu_id) FROM SYS_MENU_M t3	WHERE upp_menu_id = t1.menu_id and del_yn = 'N') sub_count
FROM SYS_MENU_M t1
JOIN SYS_ROLE_M t2 ON t1.menu_id = t2.menu_id and t2.role_cd = :role_cd
WHERE upp_menu_id <> 'root' and del_yn = 'N' and level in (2, 2)
ORDER BY  upp_menu_id, level, order_no
;
/* {
 	id:'access_row', action:'m', singleRow="true"
 } */
//메뉴에 등록된 페이지인지 확인(등록되지 않은 페이지는 권한 체크를 하지 않느다.)
SELECT count(menu_id) access_menu
FROM SYS_MENU_M t1
WHERE page_url = :request.servletpath and del_yn = 'N'
;

/* {
 	id:'rows', action:'al'
 } */
//접근권한 메뉴 목록 조회
SELECT t1.*, 
	t2.acc_page, 
	acc_read,
	acc_save,
	acc_excel,
	(SELECT count(menu_id) FROM SYS_MENU_M t2	WHERE upp_menu_id = t1.menu_id and del_yn = 'N') menu_count
FROM SYS_MENU_M t1
LEFT JOIN SYS_ROLE_M t2 ON t1.menu_id = t2.menu_id and t2.role_cd = 1
WHERE  del_yn = 'N'
ORDER BY level, order_no
;
/* {
 	id:'ia1', action:'acc'
} */
//접근권한 등록
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
//버튼 접근권한 정보 수정
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
//메뉴 접근 권한 정보 삭제
DELETE FROM SYS_ROLE_M WHERE menu_id = :menu_id and role_cd = :role_cd
;

/* {
 	id:'row', action:'access_page', singleRow="true"
 } */
//페이지 접근 권한이 있는지 체크하기 위한 쿼리
SELECT page_url, ifnull(acc_page,'N') acc_page
FROM SYS_MENU_M t1
LEFT JOIN SYS_ROLE_M t2 ON t1.menu_id = t2.menu_id and t2.role_cd = :role_cd
WHERE  del_yn = 'N' and page_url = :servletpath

;
