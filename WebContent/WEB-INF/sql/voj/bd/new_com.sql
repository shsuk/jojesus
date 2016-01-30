SELECT 'cafe' type, rep_id, bd_id, rep_text, reg_dt 
FROM voj_board_reply
union 
SELECT 'gallery' type, gal_rep_id, gal_id, rep_text, reg_dt 
FROM voj_gallery_reply
ORDER BY reg_dt desc
limit 0, 5;
