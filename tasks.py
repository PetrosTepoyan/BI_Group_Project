import pyodbc
import json
import time

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

def load_query(query_name):
    for script in os.listdir(config.input_dir):
        if query_name in script:
            with open(script, 'r') as script_file:
                sql_script = script_file.read()
            break
    return sql_script

def execute(filename, cursor, by_line = False, ignore_errors = False, log = False):
    with open(filename, "r") as file:
        if by_line:
            lines = file.readlines()
            for ind, line in enumerate(lines):
                try:
                    cursor.execute(line)
                    if log:
                        print(line)
                except ProgrammingError as error:
                    if not ignore_errors:
                        print("ERROR ON LINE", ind, line)
                        raise error
        else:
            content = file.read()
            try:
                cursor.execute(content)
            except ProgrammingError as error:
                if ignore_errors:
                    pass
                else:
                    print(content)
                    raise error

def drop_table(cursor, table_name, db, schema):
    drop_table_script = load_query('drop_table').format(db=db, schema=schema, table=table_name)
    cursor.execute(drop_table_script)
    cursor.commit()
    print("The {schema}.{table_name} table from the database {db} has been dropped".format(db=db, schema=schema,
                                                                                       table_name=table_name))

def create_table(cursor, table_name, db, schema):
    create_table_script = load_query('create_table_{}'.format(table_name)).format(db=db, schema=schema)
    cursor.execute(create_table_script)
    cursor.commit()
    print("The {schema}.{table_name} table from the database {db} has been created".format(db=db, schema=schema,
                                                                                           table_name=table_name))

def insert_into_table(cursor, table_name, db, schema, source_data):
    # Read the excel table
    df = pd.read_csv(source_data, header=0)

    insert_into_table_script = load_query('insert_into_{}'.format(table_name)).format(db=db, schema=schema)

    # Populate a table in sql server
    for index, row in df.iterrows():
        cursor.execute(insert_into_table_script, row['BusinessEntityID'], row['FirstName'], row['LastName'])
        cursor.commit()

    print(f"{len(df)} rows have been inserted into the {db}.{schema}.{table_name} table")