from typing import NoReturn

import pandas as pd


def psycopg2_execute_sql(sql, conn) -> NoReturn:
    cursor = conn.cursor()
    cursor.execute(sql)
    conn.commit()


def execute_sql_to_df(conn, sql) -> pd.DataFrame:
    return pd.read_sql(sql, con=conn)


def read_sql(filepath):
    with open(filepath, "r") as file:
        return file.read().rstrip()
