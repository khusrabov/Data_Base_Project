-- -- Вывод назнваний команд с данными hltv очков и очки за прошлую неделю
--     -- Используем функцию lead
SELECT 'hltv_points' as table_name,
  t.name AS team_name,
  tr.valid_to as valid_to,
  tr.hltv_points,
  lead(tr.hltv_points) OVER (PARTITION BY tr.team_id ORDER BY tr.valid_from DESC) AS previous_hltv_points
FROM
  cs.team_ranking tr
  JOIN cs.team t ON tr.team_id = t.team_id
WHERE
  tr.valid_from > (SELECT MAX(valid_from) FROM cs.team_ranking WHERE valid_to = '2023-04-03')
ORDER BY
  tr.hltv_points DESC;