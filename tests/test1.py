import os
import pytest
from . import execute_sql_to_df
from . import read_sql


@pytest.fixture()
def select_script():
    path = os.getenv("SCRIPT_PATH")
    return read_sql(path)


@pytest.fixture()
def select_df(select_script, sqlalchemy_conn):
    return execute_sql_to_df(
        conn=sqlalchemy_conn,
        sql=select_script
    )


def test(select_df):
    # team_avg_raiting
    assert select_df.query("table_name == 'team_avg_raiting'")['name'].iloc[0] == 'Complexity'
    assert select_df.query("table_name == 'team_avg_raiting'")['avg_rating'].iloc[0] > 0.0
    assert select_df.query("table_name == 'team_avg_raiting'")['name'].iloc[1] == 'NaVi'
    assert select_df.query("table_name == 'team_avg_raiting'")['avg_rating'].iloc[1] > 0.0
    assert select_df.query("table_name == 'team_avg_raiting'")['name'].iloc[2] == 'G2'
    assert select_df.query("table_name == 'team_avg_raiting'")['avg_rating'].iloc[2] > 0.0
    assert select_df.query("table_name == 'team_avg_raiting'")['name'].iloc[3] == 'Vitality'
    assert select_df.query("table_name == 'team_avg_raiting'")['avg_rating'].iloc[3] > 0.0
    assert select_df.query("table_name == 'team_avg_raiting'")['name'].iloc[4] == 'Astralis'
    assert select_df.query("table_name == 'team_avg_raiting'")['avg_rating'].iloc[4] > 0.0
    assert select_df.query("table_name == 'team_avg_raiting'")['name'].iloc[5] == 'Faze'
    assert select_df.query("table_name == 'team_avg_raiting'")['avg_rating'].iloc[5] > 0.0
    assert select_df.query("table_name == 'team_avg_raiting'")['name'].iloc[6] == 'Heroic'
    assert select_df.query("table_name == 'team_avg_raiting'")['avg_rating'].iloc[6] > 0.0
    assert select_df.query("table_name == 'team_avg_raiting'")['name'].iloc[7] == 'Outsiders'
    assert select_df.query("table_name == 'team_avg_raiting'")['avg_rating'].iloc[7] > 0.0
    assert select_df.query("table_name == 'team_avg_raiting'")['name'].iloc[8] == 'BIG'
    assert select_df.query("table_name == 'team_avg_raiting'")['avg_rating'].iloc[8] > 0.0
    assert select_df.query("table_name == 'team_avg_raiting'")['name'].iloc[9] == 'OG'
    assert select_df.query("table_name == 'team_avg_raiting'")['avg_rating'].iloc[9] > 0.0
    assert select_df.query("table_name == 'team_avg_raiting'")['name'].iloc[10] == 'NIP'
    assert select_df.query("table_name == 'team_avg_raiting'")['avg_rating'].iloc[10] > 0.0
    assert select_df.query("table_name == 'team_avg_raiting'")['name'].iloc[11] == 'EG'
    assert select_df.query("table_name == 'team_avg_raiting'")['avg_rating'].iloc[11] > 0.0
    assert select_df.query("table_name == 'team_avg_raiting'")['name'].iloc[12] == 'Team Liquid'
    assert select_df.query("table_name == 'team_avg_raiting'")['avg_rating'].iloc[12] > 0.0

