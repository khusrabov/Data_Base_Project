-- Ранжирующие:
-- Вывести рейтинг игроков, упорядоченный по убыванию статистики K/D Diff
-- в рамках определенного турнира (Blast-premier-spring-groups-2023)
    -- RANK()
SELECT 'player_raiting' as table_name, cs.player.full_name, cs.player_stats.K_D_Diff, RANK() OVER (ORDER BY cs.player_stats.K_D_Diff DESC) AS rank
FROM cs.player_stats
JOIN cs.player ON cs.player.player_id = cs.player_stats.player_id
WHERE cs.player_stats.tournament_id = (SELECT tournament_id
                                       FROM cs.tournament
                                       WHERE name = 'Blast-premier-world-final-2022');