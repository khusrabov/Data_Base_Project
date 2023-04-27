import os
from dataclasses import dataclass
from urllib.parse import quote

import psycopg2 as pg
import pytest
import sqlalchemy


@dataclass
class Credentials:
    dbname: str = "postgres"
    host: str = "127.0.0.1"
    port: int = 5432
    user: str = "postgres"
    password: str = "password"


@pytest.fixture(scope="function")
def creds():
    return Credentials(
        dbname=os.getenv("DBNAME", Credentials.dbname),
        host=os.getenv("DBHOST", Credentials.host),
        port=os.getenv("DBPORT", Credentials.port),
        user=os.getenv("DBUSER", Credentials.user),
        password=os.getenv("DBPASSWORD", Credentials.password)
    )


@pytest.fixture(scope="function")
def psycopg2_conn_string(creds):
    return f"""
        dbname='{creds.dbname}' 
        user='{creds.user}' 
        host='{creds.host}' 
        port='{creds.port}' 
        password='{creds.password}'
    """


@pytest.fixture(scope="function")
def psycopg2_conn(psycopg2_conn_string):
    return pg.connect(psycopg2_conn_string)


@pytest.fixture(scope="function")
def sqlalchemy_conn_string(creds):
    return (
        "postgresql://"
        f"{creds.user}:{quote(creds.password)}@"
        f"{creds.host}:{creds.port}/{creds.dbname}"
    )


@pytest.fixture(scope="function")
def sqlalchemy_conn(sqlalchemy_conn_string):
    return sqlalchemy.create_engine(sqlalchemy_conn_string)
