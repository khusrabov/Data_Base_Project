-- Агрегирующие:
-- Средний рейтинг команды за все турниры:
    -- Используем фукнцию AVG()
SELECT team.name, AVG(team_stats.raiting) AS avg_rating
FROM cs.team
JOIN cs.team_stats ON team.team_id = team_stats.team_id
GROUP BY team.name;
-- Количество MVP-наград у каждого игрока:
    -- Используем функцию COUNT()
SELECT player.full_name, COUNT(player_stats.MVP) AS mvp_count
FROM cs.player
JOIN cs.player_stats ON player.player_id = player_stats.player_id
WHERE player_stats.MVP = TRUE
GROUP BY player.full_name;

-- Ранжирующие:
-- Вывести рейтинг игроков, упорядоченный по убыванию статистики K/D Diff
-- в рамках определенного турнира (Blast-premier-spring-groups-2023)
    -- RANK()
SELECT cs.player.full_name, cs.player_stats.K_D_Diff, RANK() OVER (ORDER BY cs.player_stats.K_D_Diff DESC) AS rank
FROM cs.player_stats
JOIN cs.player ON cs.player.player_id = cs.player_stats.player_id
WHERE cs.player_stats.tournament_id = (SELECT tournament_id
                                       FROM tournament
                                       WHERE name = 'Blast-premier-spring-groups-2023');
-- Вывести рейтинг команд, упорядоченный по убыванию трофеев
-- за всю историю существования клуба
SELECT cs.team.name, cs.team.tournaments_win,
       RANK() OVER (ORDER BY cs.team.tournaments_win DESC) AS rank
FROM cs.team;

SELECT cs.team.name, cs.team_stats.maps_played, cs.team_stats.K_D_Diff, cs.team_stats.K_D, cs.team_stats.raiting, cs.tournament.name AS tournament_name,
       LEAD(cs.team_stats.raiting) OVER (PARTITION BY cs.team_stats.tournament_id, cs.team_stats.team_id ORDER BY cs.team_stats.maps_played) AS next_rating
FROM cs.team_stats
JOIN cs.team ON cs.team.team_id = cs.team_stats.team_id
JOIN cs.tournament ON cs.tournament.tournament_id = cs.team_stats.tournament_id
WHERE cs.team_stats.tournament_id = 1
ORDER BY cs.team_stats.team_id, cs.team_stats.maps_played DESC
LIMIT 5;

-- Вывод назнваний команд с данными hltv очков и очки за прошлую неделю
    -- Используем функцию lead
SELECT
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

-- Колличество побед каждой команды на карте "Mirage"
    -- COUNT()
SELECT t.name, COUNT(*) AS wins
FROM cs.match m
JOIN cs.team t ON m.winning_team_id = t.team_id
JOIN cs.maps mp ON m.map_id = mp.map_id AND mp.name = 'Mirage'
GROUP BY t.name
ORDER BY wins DESC
LIMIT 5;





