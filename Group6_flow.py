import tasks
from utils import parse_config

if __name__ == "__main__":

    config = parse_config("config")

    db = config.get("db")
    schema = config.get("schema")
    raw_data = config.get("raw_data")
    TABLES = config.get("TABLES")

    conn_ER = tasks.connect()

    tasks.create_database(conn_ER, db)

    tasks.drop_constraints_if_exist(conn_ER, db, schema)

    for table in TABLES:
        tasks.drop_table_if_exists(conn_ER, table, db, schema)
        tasks.create_table(conn_ER, table, db, schema)
        tasks.insert_into_table(conn_ER, raw_data, table, db, schema)

    tasks.set_constraints(conn_ER, db, schema)

    conn_ER.close()

    #     conn_Dim = tasks.connect_db_create_cursor("Database2")
    #     tasks.drop_table(conn_Dim, 'dim_people_scd1', 'Orders_DW', 'dbo')
    #     tasks.create_table(conn_Dim, 'dim_people_scd1', 'Orders_DW', 'dbo')
    #     tasks.update_dim_table(conn_Dim, 'dim_people_scd1', 'Orders_DW', 'dbo',
    #                            'people', 'Orders_ER', 'dbo')

    #     conn_ER.close()
    #     conn_Dim.close()


