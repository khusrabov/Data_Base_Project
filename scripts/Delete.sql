-- DELETE

-- Удалить команду с именем "Virtus.pro"
DELETE FROM cs.team
WHERE name = 'Virtus.pro';

-- Удалить игроков команды с названием "G2"
DELETE FROM cs.player
WHERE player_id IN (SELECT player_id FROM cs.roster WHERE team_id = (SELECT team_id FROM cs.team WHERE name = 'G2'));

-- Удалить статистику игрока для турнира с названием "IEM Katowice 2021" с никнеймом "NiKo"
DELETE FROM cs.player_stats
WHERE player_id = (SELECT player_id FROM cs.player WHERE nickname = 'Niko')
  AND tournament_id = (SELECT tournament_id FROM cs.tournament WHERE name = 'IEM Katowice 2021');

-- Удалить статистику команды для турнира с названием "BLAST Premier: Spring Regular Season" для команды с именем "FaZe Clan"
DELETE FROM cs.team_stats
WHERE team_id = (SELECT team_id FROM cs.team WHERE name = 'FaZe Clan')
  AND tournament_id = (SELECT tournament_id FROM cs.tournament WHERE name = 'BLAST Premier: Spring Regular Season');

-- Удалить матч, в котором команда с именем "Team Liquid" одержала победу над командой с именем "Astralis"
-- на карте "Inferno" в рамках турнира "IEM Katowice 2021"
DELETE FROM cs.match
WHERE winning_team_id = (SELECT team_id FROM cs.team WHERE name = 'Team Liquid')
  AND losing_team_id = (SELECT team_id FROM cs.team WHERE name = 'Astralis')
  AND map_id = (SELECT map_id FROM cs.maps WHERE name = 'Inferno')
  AND tournament_id = (SELECT tournament_id FROM cs.tournament WHERE name = 'IEM Katowice 2021');