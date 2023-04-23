-- UPDATE
-- Запросы написаны в общем случае:


-- Обновить никнейм игрока с полным именем "Full Name" на "new_nickname"
UPDATE cs.player SET nickname = 'new_nickname'
WHERE full_name = 'Full Name';

-- Обновить количество карт, которые сыграл игрок с никнеймом "Player" в турнире с названием "Tournament" на 10:
UPDATE cs.player_stats SET maps_played = 10
WHERE player_id = (SELECT player_id FROM cs.player WHERE nickname = 'Player')
AND tournament_id = (SELECT tournament_id FROM cs.tournament WHERE name = 'Tournament');

-- Обновить дату начала турнира с названием "Tournament2" на '2022-01-01'
UPDATE cs.tournament SET start_date = '2022-01-01'
WHERE name = 'Tournament2';

--Обновить статус игрока с полным именем "Rustam Khusrabov" в ростере команды с названием "Team" на "Benched":
UPDATE cs.roster SET status = 'Benched'
WHERE player_id = (SELECT player_id FROM cs.player WHERE full_name = 'Rustam Khusrabov')
AND team_id = (SELECT team_id FROM cs.team WHERE name = 'Team');


-- Увеличить количество побед на турнирах для команды с именем "Fnatic"
UPDATE cs.team
SET tournaments_win = tournaments_win + 1
WHERE name = 'Fnatic';

-- Изменение URL логотипа команды на "https://example.com/logo.png" для команды с именем "Astralis"
UPDATE cs.team
SET logo_url = 'https://example.com/logo.png'
WHERE name = 'Astralis';