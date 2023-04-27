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
    # player_raiting
    assert select_df.query("table_name == 'player_raiting'")['full_name'].iloc[0] == 'Ilya Osipov'
    assert select_df.query("table_name == 'player_raiting'")['k_d_diff'].iloc[0] == 77
    assert select_df.query("table_name == 'player_raiting'")['rank'].iloc[0] == 1
    assert select_df.query("table_name == 'player_raiting'")['full_name'].iloc[9] == 'Oleksandr Kostyliev'
    assert select_df.query("table_name == 'player_raiting'")['k_d_diff'].iloc[9] == 22
    assert select_df.query("table_name == 'player_raiting'")['rank'].iloc[9] == 10
    assert select_df.query("table_name == 'player_raiting'")['full_name'].iloc[40] == 'Dan Madesclaire'
    assert select_df.query("table_name == 'player_raiting'")['k_d_diff'].iloc[40] == -53
    assert select_df.query("table_name == 'player_raiting'")['rank'].iloc[40] == 41