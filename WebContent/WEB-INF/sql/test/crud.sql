/* {
	id:'d', action:'d', desc:"데이타소스를 설정해야 하는 경우 'ds:dsname'와 같이 설정할수 있다." }
*/
	delete voj_gallery
	set bd_id = :bd_id;

/* {
 	id:'i', action:'i'
} */
	INSERT INTO voj_board(
		title,
		contents,
		reg_id,
		reg_dt
	)VALUES(
		'title',
		'ir1',
		333,
		now()
		
	);
/* {
	id:'row1', action:'i,u', singleRow="true"
} */
	SELECT  t1.*, LAST_INSERT_ID() dd
	FROM voj_board t1
	WHERE   bd_id = ${act=='u' ? ':bd_id' : 'LAST_INSERT_ID()'}
	;

/* {
	key:'cnt', action:'u', loop: 'bd_id'
} */
	UPDATE voj_board
	SET view_count = view_count + 1
	WHERE bd_id= :bd_id
	;

/* {
	id:'row', singleRow="true"
} */
	SELECT  t1.*, LAST_INSERT_ID() dd, :session.test test
	FROM voj_board t1
	WHERE  bd_id = :row1.bd_id
	;

//====================================================
/* {
 	id:'rows', action:'l'
 } */
	SELECT *
	FROM (
		@{list}
	) base 
;

/*{
 	id:'list', subQuery:true
} */
	SELECT img_id, title, link_url, t2.file_id
	FROM voj_gallery t1
	LEFT JOIN attach_tbl t2 ON t1.gal_id = t2.gal_id 
	WHERE bd_cat='img' 
;
