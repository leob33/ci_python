from sqlalchemy.engine import Engine


def get_all_users_from_table(engine: Engine, table_name: str):
    sql_request = 'select * from ' + table_name
    return engine.execute(sql_request)
