import pyodbc
import json
import time
import os
import pandas as pd
import logging

import utils

from utils import __format_nan, __float_none


logging.basicConfig(filename='cluster_log', level=logging.DEBUG,
                    format='%(asctime)s:%(levelname)s:%(message)s')

def connect_to(database):

    connection_string = utils.get_connection_string(database)
    print("Connection string:", connection_string)
    print("Connecting...", end = "\r")
    logging.info("Connecting to database")
    logging.info("Connection string: {}".format(connection_string))

    try:
        connection = pyodbc.connect(connection_string, autocommit = True)
        print("Connected    \n")
        logging.info("Connected to database")
        return connection

    except Exception as error:
        print("Failed to connect")
        logging.error("Failed to connect to database with error: {}".format(error))
        raise error

def load_query(query_name, directory = None):
    for script in os.listdir(directory):
        append = "" if directory is None else directory + "/"
        if query_name in script:
            with open(append + script, 'r') as script_file:
                sql_script = script_file.read()
            break
    return sql_script

def drop_database_if_exists(cursor):
    query = load_query("database_drop.sql")
    cursor.execute(query)
    print("Dropped databases")
    logging.info("Dropped databases")

def create_database(cursor):
    query = load_query("database_creation.sql")
    cursor.execute(query)
    print("Created databases")
    logging.info("Created databases")

def drop_constraints_if_exist(cursor, db, schema):
    query = load_query("drop_foreign_key_constraints.sql", "constraints").format(db = db, schema = schema)
    try:
        cursor.execute(query)
    except:
        pass

def drop_table_if_exists(cursor, table_name, db, schema):
    drop_table_script = load_query('drop_table', None).format(db=db, schema=schema, table=table_name)
    cursor.execute(drop_table_script)
    cursor.commit()
    print("The {schema}.{table_name} table from the database {db} has been dropped".format(db=db, schema=schema,
                                                                                       table_name=table_name))
    logging.info("The {schema}.{table_name} table from the database {db} has been dropped".format(db=db, schema=schema,
                                                                                                  table_name=table_name)) 

def create_table(cursor, table_name, db, schema):
    create_table_script = load_query('create_table_{}'.format(table_name), "create_table").format(db=db, schema=schema)

    cursor.execute(create_table_script)
    cursor.commit()
    print("The {schema}.{table_name} table from the database {db} has been created".format(db=db, schema=schema,
                                                                                           table_name=table_name))
    logging.info("The {schema}.{table_name} table from the database {db} has been created".format(db=db, schema=schema,
                                                                                                    table_name=table_name))

def insert_into_table(cursor, raw_data, table, db, schema):
    print(f"Inserting into {table}...")
    df = pd.read_excel(raw_data, sheet_name = table)

    insert_into_table_script = load_query('insert_into_{}'.format(table), "insert_into").format(db = db, schema = schema)

    for index, row in df.iterrows():
        params = list(row)
        params = __format_nan(params)
        
        cursor.execute(insert_into_table_script, params)
        cursor.commit()

    print(f"{len(df)} rows have been inserted into the {db}.{schema}.{table} table\n")

def set_constraints(cursor, db, schema):
    query = load_query("add_primary_key_constraints.sql", "constraints").format(db = db, schema = schema)
    cursor.execute(query)
    print("Added primary key constraints")
    logging.info("Added primary key constraints")

    query = load_query("add_foreign_key_constraints.sql", "constraints").format(db = db, schema = schema)
    cursor.execute(query)
    print("Added foriegn key constraints")
    logging.info("Added foriegn key constraints")

def create_dim_table(cursor, table_name, db, schema):
    create_table_script = load_query('create_table_dim_{}'.format(table_name), "dimensional/create_table_dim").format(db=db, schema=schema)
    cursor.execute(create_table_script)
    cursor.commit()
    print("The {schema}.{table_name} table from the database {db} has been created".format(db=db, schema=schema,
                                                                                           table_name=table_name))
    logging.info("The {schema}.{table_name} table from the database {db} has been created".format(db=db, schema=schema,
                                                                                                    table_name=table_name))
    

def create_dim_table(cursor, table_name, scd_type, db, schema):
    create_table_script = load_query('create_table_dim_{}_{}'.format(table_name, scd_type), "dimensional/create_table_dim").format(db=db, schema=schema)
    cursor.execute(create_table_script)
    cursor.commit()

    print("The {schema}.dim_{table_name}_{scd_type} table from the database {db} has been created\n".format(db=db, schema=schema, scd_type = scd_type, table_name=table_name))
    logging.info("The {schema}.dim_{table_name}_{scd_type} table from the database {db} has been created\n".format(db=db, schema=schema, scd_type = scd_type, table_name=table_name))

def drop_dim_table_if_exists(cursor, table_name, scd_type, db, schema):
    table_name_full = "dim_" + table_name + "_" + scd_type
    drop_table_script = load_query('drop_table', None).format(db=db, schema=schema, table=table_name_full)
    cursor.execute(drop_table_script)
    cursor.commit()
    print("The {schema}.{table_name_full} table from the database {db} has been dropped".format(db=db, schema=schema, table_name_full=table_name_full))
    logging.info("The {schema}.{table_name_full} table from the database {db} has been dropped".format(db=db, schema=schema, table_name_full=table_name_full))

def update_dim_table(cursor, table_name, scd_type, db_dim, db_rel, schema_dim, schema_rel):
    update_dim_table_script = load_query(
        'update_table_dim_{table_name}_{scd_type}'.format(table_name = table_name, scd_type = scd_type), "dimensional/update_dim"
    ).format(db_dim = db_dim, db_rel = db_rel, schema_dim = schema_dim, schema_rel = schema_rel)
    
    print(f"Executing {table_name}_{scd_type}...")
    cursor.execute(update_dim_table_script)
    cursor.commit()

    print(f"Updated dim table {table_name}_{scd_type}\n")
    logging.info(f"Updated dim table {table_name}_{scd_type}\n")

def create_fact_table(cursor, table_name, db, schema):
    create_fact_table_script = load_query(
        'create_table_fact_{table_name}'.format(table_name = table_name), "dimensional"
    ).format(db = db, schema = schema)
    
    cursor.execute(create_fact_table_script)
    cursor.commit()

    print("The {schema}.{table_name} table from the database {db} has been created".format(db=db, schema=schema, table_name=table_name))
    logging.info("The {schema}.{table_name} table from the database {db} has been created".format(db=db, schema=schema, table_name=table_name))


def update_fact_table(cursor, table_name, db_dim, db_rel, schema_dim, schema_rel):
    udpate_fact_table_script = load_query(
        'update_table_fact_{table_name}'.format(table_name = table_name), "dimensional"
    ).format(db_dim = db_dim, db_rel = db_rel, schema_dim = schema_dim, schema_rel = schema_rel)
    
    cursor.execute(udpate_fact_table_script)
    cursor.commit()

    print("The {schema_dim}.{table_name} table from the database {db_dim} has been updated".format(db_dim=db_dim, schema_dim=schema_dim, table_name=table_name))
    logging.info("The {schema_dim}.{table_name} table from the database {db_dim} has been updated".format(db_dim=db_dim, schema_dim=schema_dim, table_name=table_name))

def drop_fact_table_if_exists(cursor, table_name, db, schema):
    table_name_full = "fact_" + table_name
    drop_table_script = load_query('drop_table', None).format(db=db, schema=schema, table=table_name_full)
    cursor.execute(drop_table_script)
    cursor.commit()
    print("The {schema}.{table_name_full} table from the database {db} has been dropped".format(db=db, schema=schema, table_name_full=table_name_full))
    logging.info("The {schema}.{table_name_full} table from the database {db} has been dropped".format(db=db, schema=schema, table_name_full=table_name_full))
