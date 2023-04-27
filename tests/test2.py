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
    # player_mvp
    assert select_df.query("table_name == 'player_mvp'")['full_name'].iloc[0] == 'Ilya Osipov'
    assert select_df.query("table_name == 'player_mvp'")['mvp_count'].iloc[0] > 0
    assert select_df.query("table_name == 'player_mvp'")['full_name'].iloc[1] == 'Mathieu Herbaut'
    assert select_df.query("table_name == 'player_mvp'")['mvp_count'].iloc[1] > 0

