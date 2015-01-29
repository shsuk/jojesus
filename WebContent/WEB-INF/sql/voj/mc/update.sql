UPDATE mc_bible
SET
	wr_content = @{ir1}
WHERE wr_id = @{wr_id}
