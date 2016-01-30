UPDATE voj_board_header
SET
	bd_cat = @{bd_cat},
	title = @{title},
	header = @{ir1}
WHERE id = @{id};