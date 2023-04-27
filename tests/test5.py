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
    # hltv_points
    assert select_df.query("table_name == 'hltv_points'")['team_name'].iloc[2] == 'G2'
    assert select_df.query("table_name == 'hltv_points'")['hltv_points'].iloc[2] == 908
    assert select_df.query("table_name == 'hltv_points'")['previous_hltv_points'].iloc[2] == 1000
