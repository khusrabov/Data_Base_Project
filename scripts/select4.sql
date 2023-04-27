-- Вывести рейтинг команд, упорядоченный по убыванию трофеев
-- за всю историю существования клуба
SELECT 'team_trophy' as table_name, cs.team.name, cs.team.tournaments_win,
       RANK() OVER (ORDER BY cs.team.tournaments_win DESC) AS rank
FROM cs.team;