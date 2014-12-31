UPDATE attach_tbl
SET backup=@{backup}
WHERE file_id = @{file_id};
