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
    # mirage_wins
    assert select_df.query("table_name == 'mirage_wins'")['name'].iloc[0] == 'Team Liquid'
    assert select_df.query("table_name == 'mirage_wins'")['wins'].iloc[0] > 0
    assert select_df.query("table_name == 'mirage_wins'")['name'].iloc[1] == 'G2'
    assert select_df.query("table_name == 'mirage_wins'")['wins'].iloc[1] > 0
    assert select_df.query("table_name == 'mirage_wins'")['name'].iloc[2] == 'Heroic'
    assert select_df.query("table_name == 'mirage_wins'")['wins'].iloc[2] > 0
    assert select_df.query("table_name == 'mirage_wins'")['name'].iloc[3] == 'NIP'
    assert select_df.query("table_name == 'mirage_wins'")['wins'].iloc[3] > 0
    assert select_df.query("table_name == 'mirage_wins'")['name'].iloc[4] == 'Faze'
    assert select_df.query("table_name == 'mirage_wins'")['wins'].iloc[4] > 0

