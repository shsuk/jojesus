INSERT INTO voj_gallery(
	title,
	img_id,
	reg_id,
	reg_dt,
	reg_ip,
	reg_nickname,
	bd_cat,
	link_url,
	file_id
)VALUES(
	@{title},
	@{img_id},
	@{session.user_id},
	now(),
	@{session.ip},
	'${empty( req.writor) ? session.nick_name : req.writor}',
	@{bd_cat},
	@{link_url},
	@{file_id}
);
