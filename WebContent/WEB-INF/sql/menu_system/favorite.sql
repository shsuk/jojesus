/* {
 	id:'seq', action:'i', singleRow="true"
 } */
//즐겨찾기 SEQ(단일 레코드인 경우 다음 쿼리의 인자로 사용 가능))
SELECT max(favorite_seq)+1 seq
FROM user_favorite
WHERE user_seq = :user_seq
;
/* {
 	id:'h', action:'i'
} */
//즐겨찿기 헤더
INSERT INTO user_favorite(
	user_seq,favorite_seq,favorite_name,create_date,use_yn
)VALUES(
	:user_seq,:seq.seq,:favorite_name,now(),:use_yn
	
);
/* {
 	id:'d', action:'i', loop: 'item_code'
} */
//즐겨찾기 상세
INSERT INTO user_favorite_item(
	user_seq,favorite_seq,item_code
)VALUES(
	:user_seq,:seq.seq,:item_code
);

/* {
	key:'cnt', action:'u'
} */
//메뉴 수정
UPDATE user_favorite
SET 
	favorite_name = :favorite_name,
	use_yn = :use_yn
WHERE user_seq = :user_seq and favorite_seq = :favorite_seq
;
/* {
 	id:'del', action:'u', loop: 'item_code'
} */
//즐겨찾기 상세 삭제
DELETE FROM user_favorite_item
WHERE user_seq = :user_seq and favorite_seq = :favorite_seq;

/* {
 	id:'d', action:'u', loop: 'item_code'
} */
//즐겨찾기 상세
INSERT INTO user_favorite_item(
	user_seq,favorite_seq,item_code
)VALUES(
	:user_seq,:favorite_seq,:item_code
);

/* {
 	id:'rows', action:'l'
 } */
//즐겨찾기 목록
SELECT *
FROM user_favorite
WHERE user_seq = :user_seq
;
/* {
 	id:'row', action:'items', singleRow="true"
 } */
//즐겨찾기 상세
SELECT *
FROM user_favorite
WHERE user_seq = :user_seq and favorite_seq = :favorite_seq
;
/* {
 	id:'rows', action:'items'
 } */
//즐겨찾기 아이템 목록
SELECT *
FROM user_favorite_item
WHERE user_seq = :user_seq and favorite_seq = :favorite_seq
;
/* {
 	id:'rows', action:'org_items'
 } */
//즐겨찾기 아이템 목록 
SELECT *
FROM user_favorite_item;
