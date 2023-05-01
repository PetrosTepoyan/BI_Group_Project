import pyodbc
import json
import time
import os
import pandas as pd

from utils import __format_nan, __float_none

TABLES = [
    "Categories",
    "Customers", 
    "Employees", 
    "Suppliers", 
    "Products", 
    "Region", 
    "Shippers", 
    "Territories",
    "Orders",
    "OrderDetails"
]

def connect():
    
    with open('connection_config.json', 'r') as f:
        config = json.load(f)
    
    DRVIER = f"DRIVER=" + config.get("driver")
    SERVER = f"SERVER=" + config.get("server")
    DATABASE = f"DATABASE=" + config.get("database")
    UID = f"UID=" + config.get("username")
    PWD = f"PWD=" + config.get("password")
    ENCRYPT = "ENCRYPT=yes"
    TRUST = "TrustServerCertificate=yes"

    connection_params = [DRVIER, SERVER, DATABASE, ENCRYPT, TRUST, UID, PWD]
    connection_string = ";".join(connection_params)
    
    connection = pyodbc.connect(connection_string, autocommit = True)
    
    return connection

def load_query(query_name, directory = None):
    for script in os.listdir(directory):
        append = "" if directory is None else directory + "/"
        if query_name in script:
            with open(append + script, 'r') as script_file:
                sql_script = script_file.read()
            break
    return sql_script

def create_database(cursor, db):
    query = load_query("database_creation.sql")
    cursor.execute(query)

def drop_constraints(cursor, db, schema):
    query = load_query("add_primary_key_constraints.sql", "constraints").format(db = db, schema = schema)
    try:
        cursor.execute(query)
    except Exception:
        pass

def drop_table(cursor, table_name, db, schema):
    drop_table_script = load_query('drop_table', None).format(db=db, schema=schema, table=table_name)
    cursor.execute(drop_table_script)
    cursor.commit()
    print("The {schema}.{table_name} table from the database {db} has been dropped".format(db=db, schema=schema,
                                                                                       table_name=table_name))

def create_table(cursor, table_name, db, schema):
    create_table_script = load_query('create_table_{}'.format(table_name), "create_table").format(db=db, schema=schema)
    cursor.execute(create_table_script)
    cursor.commit()
    print("The {schema}.{table_name} table from the database {db} has been created".format(db=db, schema=schema,
                                                                                           table_name=table_name))

def insert_into_table(cursor, raw_data, table, db, schema):
    print(f"Inserting into {table}...")
    df = pd.read_excel(raw_data, sheet_name = table)

    insert_into_table_script = load_query('insert_into_{}'.format(table), "insert_into").format(db = db, schema = schema)

    for index, row in df.iterrows():
        params = list(row)
        params = __format_nan(params)
        try:
            cursor.execute(insert_into_table_script, params)
            cursor.commit()
        except Exception as err:
            print(index, err)

    print(f"{len(df)} rows have been inserted into the {db}.{schema}.{table} table\n")

def set_constraints(cursor, db, schema):
    query = load_query("add_primary_key_constraints.sql", "constraints").format(db = db, schema = schema)
    cursor.execute(query)
    print("Added primary key constraints")

    query = load_query("add_foreign_key_constraints.sql", "constraints").format(db = db, schema = schema)
    cursor.execute(query)
    print("Added foriegn key constraints")