/* {
 	id:'i', action:'i'
} */
	INSERT INTO sys_notice_m(
		subject,
		contents,
		stt_dt,
		end_dt,
		reg_id,
		reg_dt,
		chg_id,
		chg_dt
	)VALUES(
		:subject,
		:ir1,
		:stt_dt,
		:end_dt,
		:session.user_id,
		now(),
		:session.user_id,
		now()
	);
/* {
 	id:'addAtt', action:'i', loop: 'attach'
} */
	INSERT INTO sys_notice_file_m(
		file_id,
		notice_id,
		file_name,
		file_path
	)VALUES(
		:attach,
		LAST_INSERT_ID(),
		:attach.name,
		:attach.path
	);
/* {
	key:'cnt', action:'u'
} */
	UPDATE sys_notice_m
	SET 
		subject = :subject,
		contents = :ir1,
		stt_dt = :stt_dt,
		end_dt = :end_dt,
		chg_id = :session.user_id,
		chg_dt = now()
	WHERE notice_id = :notice_id
	;
/* {
 	id:'addAtt', action:'u', loop: 'attach'
} */
	INSERT INTO sys_notice_file_m(
		file_id,
		notice_id,
		file_name,
		file_path
	)VALUES(
		:attach,
		:notice_id,
		:attach.name,
		:attach.path
	);
/* {
 	id:'delAtt', action:'u', loop: 'del_file_id'
} */
	DELETE FROM sys_notice_file_m
	WHERE file_id = :del_file_id and notice_id = :notice_id;

/* {
	id:'d', action:'d', desc:"데이타소스를 설정해야 하는 경우 'ds:dsname'와 같이 설정할수 있다." }
*/
	UPDATE sys_notice_m
	SET use_yn = 'N'
	WHERE notice_id = :notice_id;

/* {
	id:'row', action:'v', singleRow="true"
} */
	SELECT  notice_id,
		subject,
		contents,
		DATE_FORMAT(stt_dt,'%Y-%m-%d') stt_dt,
		DATE_FORMAT(end_dt,'%Y-%m-%d') end_dt,
		use_yn,
		qry_cnt,
		reg_id,
		DATE_FORMAT(reg_dt,'%Y-%m-%d') reg_dt,
		chg_id,
		DATE_FORMAT(chg_dt,'%Y-%m-%d') chg_dt
	FROM sys_notice_m
	WHERE notice_id= :notice_id  and use_yn = 'Y'
	;
/* {
	id:'rows', action:'v' 
} */
	SELECT *
	FROM sys_notice_file_m
	WHERE notice_id= :notice_id 
	;
/* {
	key:'cnt', action:'v'
} */
	UPDATE sys_notice_m
	SET 
		qry_cnt = qry_cnt+1
	WHERE notice_id = :notice_id
	;

/* {
 	id:'rows', action:'l'
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
		DATE_FORMAT(chg_dt,'%Y-%m-%d') chg_dt,
		(SELECT count(file_id) FROM sys_notice_file_m WHERE notice_id = t1.notice_id) attach
	FROM sys_notice_m t1
	WHERE use_yn = 'Y' 
		${search_type=='subject'  && !empty(search_text) ? '' : '--' } and subject  like concat('%', :search_text, '%') 
		${search_type=='reg_id'   && !empty(search_text) ? '' : '--' } and reg_id   like concat('%', :search_text, '%') 
		${search_type=='contents' && !empty(search_text) ? '' : '--' } and contents like concat('%', :search_text, '%') 
	ORDER BY notice_id desc
	LIMIT ${rows * (page - 1)} , ${rows}
;
/* {
 	id:'cnt', action:'l', singleRow="true"
 } */

  SELECT FOUND_ROWS() cnt
;

