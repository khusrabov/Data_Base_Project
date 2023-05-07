-- Функция "get_player_stats_by_tournament" будет возвращать статистику игрока по конкретному турниру.
-- Это может быть полезно для анализа игровой активности игрока на определенном турнире.

CREATE OR REPLACE FUNCTION get_player_stats_by_tournament(player_id INT, tournament_id INT)
RETURNS TABLE (
  maps_played INT,
  rounds INT,
  K_D_Diff DECIMAL,
  K_D INT,
  raiting DECIMAL,
  MVP BOOL
) AS $$
BEGIN
  RETURN QUERY SELECT ps.maps_played, ps.rounds, ps.K_D_Diff, ps.K_D, ps.raiting, ps.MVP FROM cs.player_stats ps WHERE ps.player_id = $1 AND ps.tournament_id = $2;
END;
$$ LANGUAGE plpgsql;

-- Пример использования:
SELECT * FROM get_player_stats_by_tournament(1, 1);

-- Функция для получения статистики команды на определенном турнире.
-- Это может быть полезно для анализа игровой активности команды на определенном турнире.
CREATE OR REPLACE FUNCTION get_team_stats(team_id INT, tournament_id INT)
RETURNS TABLE (
  maps_played INT,
  raiting DECIMAL,
  K_D DECIMAL,
  K_D_Diff INT
) AS $$
BEGIN
  RETURN QUERY SELECT cs.team_stats.maps_played, cs.team_stats.raiting, cs.team_stats.K_D, cs.team_stats.K_D_Diff
  FROM cs.team_stats
  WHERE cs.team_stats.team_id = $1 AND cs.team_stats.tournament_id = $2;
END;
$$ LANGUAGE plpgsql;

-- Пример использования:
SELECT * FROM get_team_stats(1, 1);


-- Хранимая процедура для добавления новой команды.
-- Данная процедура позволяет добавлять новые команды в базу данных.
-- Это может быть полезно для обновления информации о командах и их составах.
-- Процедура принимает необходимые параметры и выполняет операцию INSERT в таблицу cs.team.
CREATE OR REPLACE PROCEDURE cs.add_team(
  name VARCHAR(255),
  country VARCHAR(255),
  logo_url VARCHAR(255),
  date_of_foundation DATE,
  tournaments_win INT
)
AS $$
BEGIN
  INSERT INTO cs.team (name, country, logo_url, date_of_foundation, tournaments_win)
  VALUES (name, country, logo_url, date_of_foundation, tournaments_win);
END;
$$ LANGUAGE plpgsql;
-- Пример использования:
CALL cs.add_team('testing', 'Denmark', 'https://example.com/astralis_logo.png', '2016-01-01', 0);


-- Хранимая процедура для добавления нового киберспортсмена.
-- Данная процедура позволяет добавлять новых игроков в базу данных.
-- Процедура принимает необходимые параметры и выполняет операцию INSERT в таблицу cs.player.
CREATE OR REPLACE PROCEDURE cs.add_player(
  full_name VARCHAR(255),
  nickname VARCHAR(255),
  age INT,
  nationality VARCHAR(255)
) AS $$
BEGIN
  INSERT INTO cs.player (full_name, nickname, age, nationality)
  VALUES (full_name, nickname, age, nationality);
END;
$$ LANGUAGE plpgsql;

-- Пример использования
CALL cs.add_player('Rustam Khusrabov', 'caxapoook', '19', 'Uzbekistan')
