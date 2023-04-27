-- Колличество побед каждой команды на карте "Mirage"
    -- COUNT()
SELECT 'mirage_wins' AS table_name, t.name, COUNT(*) AS wins
FROM cs.match m
JOIN cs.team t ON m.winning_team_id = t.team_id
JOIN cs.maps mp ON m.map_id = mp.map_id AND mp.name = 'Mirage'
GROUP BY t.name
ORDER BY wins DESC
LIMIT 5;