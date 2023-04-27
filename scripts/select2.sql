-- Количество MVP-наград у каждого игрока:
    -- Используем функцию COUNT()
SELECT 'player_mvp' as table_name, player.full_name as full_name, COUNT(player_stats.MVP) AS mvp_count
FROM cs.player
JOIN cs.player_stats ON player.player_id = player_stats.player_id
WHERE player_stats.MVP = TRUE
GROUP BY player.full_name;