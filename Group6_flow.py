import tasks
from utils import parse_config

if __name__ == "__main__":

    configuration = parse_config("config")

    raw_data = configuration["raw_data"]
    TABLES = configuration["TABLES"]
    SCD_types = configuration["SCD"]

    db_rel = configuration["db_rel"]
    db_dim = configuration["db_dim"]
    schema_rel = configuration["schema_rel"]
    schema_dim = configuration["schema_dim"]

    # Relational
    conn_ER = tasks.connect_to(db_rel)

    tasks.create_database(conn_ER)

    tasks.drop_constraints_if_exist(conn_ER, db_rel, schema_rel)

    for table in TABLES:
        tasks.drop_table_if_exists(conn_ER, table, db_rel, schema_rel)
        tasks.create_table(conn_ER, table, db_rel, schema_rel)
        tasks.insert_into_table(conn_ER, raw_data, table, db_rel, schema_rel)

    tasks.set_constraints(conn_ER, db_rel, schema_rel)

    conn_ER.close()


    # Dimensional
    conn_DW = tasks.connect_to(db_dim)

    for table, SCD_type in SCD_types.items():
        
        tasks.drop_dim_table_if_exists(conn_DW, table, SCD_type, db_dim, schema_dim)
        tasks.create_dim_table(conn_DW, table, SCD_type, db_dim, schema_dim)
        
        tasks.drop_procedure_if_exists(conn_DW, table, SCD_type)
        tasks.create_procedure(conn_DW, table, SCD_type, db_dim, db_rel, schema_dim, schema_rel)
        
        tasks.update_dim_table(conn_DW, table, SCD_type)


    conn_DW.close()
