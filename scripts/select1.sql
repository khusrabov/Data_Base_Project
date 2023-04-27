-- Агрегирующие:
-- Средний рейтинг команды за все турниры:
    -- Используем фукнцию AVG()
SELECT 'team_avg_raiting' as table_name, team.name, AVG(team_stats.raiting) AS avg_rating
FROM cs.team
JOIN cs.team_stats ON team.team_id = team_stats.team_id
GROUP BY team.name;





