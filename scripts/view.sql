-- Представление с информацией о команде и ее статистике на турнире:
CREATE VIEW cs.teamtournamentstats AS
SELECT t.name AS tournamentname, t.start_date, tm.name AS teamname, tm.country, tm.logo_url, ts.maps_played, ts.raiting, ts.K_D, ts.K_D_Diff
FROM cs.tournament t
JOIN cs.team_stats ts ON t.tournament_id = ts.tournament_id
JOIN cs.team tm ON ts.team_id = tm.team_id;

-- Представление с информацией о матчах на турнире, скрытыми полями о командах:
CREATE VIEW cs.matchinfo AS
SELECT m.date, m.map_id, t1.name AS winningteamname, t2.name AS losingteamname
FROM cs.match m
JOIN cs.team t1 ON m.winning_team_id = t1.team_id
JOIN cs.team t2 ON m.losing_team_id = t2.team_id;

-- Представление со сводной информацией о статистике игроков на турнирах:
CREATE VIEW cs.playertournamentstats AS
SELECT p.full_name, p.nickname, t.name AS tournamentname, ts.maps_played, ts.rounds, ts.K_D_Diff, ts.K_D, ts.raiting, ts.MVP
FROM cs.player p
JOIN cs.player_stats ts ON p.player_id = ts.player_id
JOIN cs.tournament t ON ts.tournament_id = t.tournament_id;

-- Сводная таблица, показывающая количество побед команд на каждом турнире:
CREATE VIEW cs.tournament_winners AS
SELECT
  t.tournament_id,
  t.name,
  COUNT(m.winning_team_id) AS wins
FROM cs.tournament t
LEFT JOIN cs.match m ON t.tournament_id = m.tournament_id
GROUP BY t.tournament_id;


-- Сводная таблица, показывающая общую статистику игроков на каждом турнире (общаяя статистика):
CREATE VIEW cs.tournament_player_stats AS
SELECT
  t.tournament_id,
  t.name,
  ps.player_id,
  p.nickname,
  SUM(ps.maps_played) AS total_maps_played,
  SUM(ps.rounds) AS total_rounds,
  AVG(ps.K_D_Diff) AS avg_K_D_Diff,
  AVG(ps.K_D) AS avg_K_D,
  AVG(ps.raiting) AS avg_raiting,
  COUNT(CASE WHEN ps.MVP = TRUE THEN 1 END) AS total_MVP
FROM cs.player_stats ps
JOIN cs.player p ON ps.player_id = p.player_id
JOIN cs.tournament t ON ps.tournament_id = t.tournament_id
GROUP BY t.tournament_id, ps.player_id, p.nickname;

-- Представление, скрывающее персональные данные и технические поля таблицы cs.player:
CREATE VIEW cs.player_info AS
SELECT
  player_id,
  CONCAT(SUBSTR(full_name, 1, 1), REPEAT('*', LENGTH(full_name) - 1)) AS full_name,
  CONCAT(SUBSTR(nickname, 1, 1), REPEAT('*', LENGTH(nickname) - 1)) AS nickname,
  age,
  nationality
FROM cs.player;
