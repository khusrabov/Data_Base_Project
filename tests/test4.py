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
    # team_trophy
    assert select_df.query("table_name == 'team_trophy'")['name'].iloc[0] == 'NaVi'
    assert select_df.query("table_name == 'team_trophy'")['tournaments_win'].iloc[0] == 26
    assert select_df.query("table_name == 'team_trophy'")['rank'].iloc[0] == 1
    assert select_df.query("table_name == 'team_trophy'")['name'].iloc[22] == 'Forze'
    assert select_df.query("table_name == 'team_trophy'")['tournaments_win'].iloc[22] == 0
    assert select_df.query("table_name == 'team_trophy'")['rank'].iloc[22] == 19