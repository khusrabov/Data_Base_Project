import argparse
import os
import pandas as pd
import psycopg2 as pg
import sqlalchemy
from dataclasses import dataclass
from typing import NoReturn
from typing import Optional
from urllib.parse import quote


@dataclass
class Credentials:
    dbname: str = "postgres"
    host: str = "127.0.0.1"
    port: int = 5432
    user: str = "postgres"
    password: str = "password"


def _extract_credentials() -> Credentials:
    return Credentials(
        dbname=os.getenv("DBNAME", Credentials.dbname),
        host=os.getenv("DBHOST", Credentials.host),
        port=os.getenv("DBPORT", Credentials.port),
        user=os.getenv("DBUSER", Credentials.user),
        password=os.getenv("DBPASSWORD", Credentials.password)
    )


def psycopg2_conn_string(creds: Optional[Credentials] = None) -> str:
    if not creds:
        creds = _extract_credentials()
    return f"""
        dbname='{creds.dbname}' 
        user='{creds.user}' 
        host='{creds.host}' 
        port='{creds.port}' 
        password='{creds.password}'
    """


def psycopg2_conn(conn_string: Optional[str] = None):
    if not conn_string:
        conn_string = psycopg2_conn_string()
    return pg.connect(conn_string)


def psycopg2_execute_sql(sql: str, conn=None) -> NoReturn:
    if not conn:
        conn = psycopg2_conn()
    cursor = conn.cursor()
    cursor.execute(sql)
    conn.commit()


def sqlalchemy_conn_string(creds: Optional[Credentials] = None) -> str:
    if not creds:
        creds = _extract_credentials()
    return (
        "postgresql://"
        f"{creds.user}:{quote(creds.password)}@"
        f"{creds.host}:{creds.port}/{creds.dbname}"
    )


def sqlalchemy_conn(conn_string: Optional[str] = None):
    if not conn_string:
        conn_string = sqlalchemy_conn_string()
    return sqlalchemy.create_engine(conn_string)


def execute_sql_to_df(conn, sql: str) -> pd.DataFrame:
    return pd.read_sql(sql, con=conn)


def read_sql(filepath: str) -> str:
    with open(filepath, "r") as file:
        return file.read().rstrip()


def exec_sql(sql: str, verbose: bool) -> NoReturn:
    if verbose:
        sql = sql.replace("%", "%%")
        print(execute_sql_to_df(conn=sqlalchemy_conn(), sql=sql))
    else:
        psycopg2_execute_sql(sql=sql)


def exec_sql_file(path: str, cat: bool, verbose: bool) -> NoReturn:
    sql = read_sql(path)
    if cat:
        print(sql)
    exec_sql(sql, verbose)


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--file",
                        default="",
                        dest="file",
                        help="path to sql script to execute")
    parser.add_argument("--cat",
                        default=False,
                        dest="cat",
                        action="store_true",
                        help="output file content")
    parser.add_argument("--sql",
                        default="",
                        dest="sql",
                        help="sql script to execute")
    parser.add_argument("--verbose",
                        default=False,
                        dest="verbose",
                        action="store_true",
                        help="output execution result")
    args = parser.parse_args()

    if args.file:
        exec_sql_file(args.file, args.cat, args.verbose)

    if args.sql:
        exec_sql(args.sql, args.verbose)
