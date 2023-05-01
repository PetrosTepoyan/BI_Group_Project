import tasks

if __name__ == "__main__":

    db = "Orders_RELATIONAL_DB"
    schema = "dbo"
    raw_data = "raw_data_source.xlsx"

    conn_ER = tasks.connect()

    tasks.create_database(conn_ER, db)

    for table in tasks.TABLES:
        tasks.drop_constraints(conn_ER, db, schema)
        tasks.drop_table(conn_ER, table, db, schema)
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


