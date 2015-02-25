INSERT INTO attach_tbl (
	file_id, 
	file_name, 
	file_ext, 
	file_size, 
	volume, 
	file_path, 
	creater, 
	mime_type, 
	ref_tbl,
	created
)
VALUES (
	@{fileId}, 
	@{fileName}, 
	@{ext}, 
	@{size}, 
	@{root}, 
	@{filePath},
	@{user_id},
	@{mimeType},
	@{ref_tbl},
	now()
	);
 