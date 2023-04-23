-- Boring SELECT

-- Вывод названий всех карт
SELECT name
FROM cs.maps;

-- Вывод всех турниров формата LAN
SELECT name AS tournament_name
FROM cs.tournament
WHERE format_lan = TRUE;

-- Вывод всех команд с трофеями
SELECT name AS team_name
FROM cs.team
WHERE tournaments_win > 0;

-- Вывод всех игроков
SELECT full_name FROM cs.player;

-- Турниры с количество команд 16
SELECT name
FROM cs.tournament
WHERE teams = 16;

-- Вывод ников игроков
SELECT full_name, nickname
FROM cs.player;

-- Команды который образовались после 2010 года
SELECT name, date_of_foundation
FROM cs.team
WHERE date_of_foundation > '2010-01-01';

-- More interesting SELECT

-- Вывод списока всех команд, участвующих в турнире с названием 'Blast-premier-spring-groups-2023'
    -- В общем случае можем поменять значение последней строки на название другого турнира --
SELECT DISTINCT tm.name
FROM cs.tournament t
JOIN cs.team_stats ts ON t.tournament_id = ts.tournament_id
JOIN cs.team tm ON ts.team_id = tm.team_id
WHERE t.name = 'Blast-premier-spring-groups-2023';

-- Вывод списка всех карт, которые были пикнуты командами на определенном турнире с процентом выбора на турние
    -- Процент выбора отсартирован по убыванию
SELECT cs.maps.name AS map_name,
COUNT(cs.match.map_id) * 100.0 / SUM(COUNT(cs.match.map_id)) OVER() AS percentage
FROM cs.match
JOIN cs.maps ON cs.match.map_id = cs.maps.map_id
WHERE cs.match.tournament_id = 1
GROUP BY cs.maps.name
ORDER BY percentage DESC ;

-- Вывод списка команд, в составе которых есть игроки из России или Украины
SELECT DISTINCT t.name FROM cs.team t
JOIN cs.roster r ON t.team_id = r.team_id
JOIN cs.player p ON r.player_id = p.player_id
WHERE p.nationality IN ('Russia', 'Ukraine');

-- Вывод списка игроков, рейтинг который выше среднего
    -- Игроки упорядочены по убыванию
SELECT cs.player.full_name, cs.player_stats.raiting
FROM cs.player
JOIN cs.player_stats ON cs.player.player_id = cs.player_stats.player_id
WHERE cs.player_stats.raiting > (SELECT AVG(raiting) FROM cs.player_stats)
ORDER BY cs.player_stats.raiting DESC;

-- Вывод списка игроков, который не являются MVP определенного турнира, но рейтинг больше 1.15
    -- Турнир Blast-premier-spring-groups-2023
    -- Игроки упорядочены по убыванию
SELECT p.full_name, p.nickname, ps.raiting
FROM cs.player p
INNER JOIN cs.player_stats ps ON ps.player_id = p.player_id
WHERE ps.tournament_id = (SELECT tournament_id FROM cs.tournament WHERE name = 'Blast-premier-spring-groups-2023')
  AND ps.MVP = FALSE AND ps.raiting > 1.15
GROUP BY p.full_name, p.nickname, ps.raiting
ORDER BY raiting DESC;

-- Команды, у которых больше 10 трофеев за все время
SELECT team.name FROM cs.team
   WHERE team.tournaments_win > 10;

-- Вывод команд, у которых есть игроки со статусом 'Benched', также считаем количества игроков, которые с данным статусом
SELECT team.name, COUNT(roster.player_id) AS benched_players_count FROM cs.team
   JOIN cs.roster ON team.team_id = roster.team_id
   WHERE roster.status = 'Benched'
   GROUP BY team.name;

-- Вывод лучшего игрока команды каждого турнира
SELECT t.name AS tournament_name, team.name AS team_name, player.full_name AS best_player_name
FROM cs.team team
JOIN cs.roster ON team.team_id = roster.team_id
JOIN cs.player player ON roster.player_id = player.player_id
JOIN cs.player_stats stats ON player.player_id = stats.player_id
JOIN cs.tournament t ON stats.tournament_id = t.tournament_id
WHERE stats.raiting = (SELECT MAX(raiting) FROM cs.player_stats WHERE tournament_id = t.tournament_id
    AND player_id IN (SELECT player_id FROM cs.roster WHERE team_id = team.team_id AND status = 'Starter'))
ORDER BY t.name, team.name;

-- Вывод игроков, который отыграли за свою команду более 1000 карт
SELECT p.full_name, t.name, rs.maps_played
FROM cs.player p
JOIN cs.roster rs ON p.player_id = rs.player_id
JOIN cs.team t ON rs.team_id = t.team_id
WHERE rs.maps_played > 1000;