import pandas as pd
import numpy as np
import math
import json
import platform

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

def get_connection_string():
    running_system = platform.system()
    if running_system == "Darwin" or running_system == "Linux":
        config = parse_config("connection_configs/posix_connection_config")

        DRVIER = f"DRIVER=" + config.get("driver")
        SERVER = f"SERVER=" + config.get("server")
        DATABASE = f"DATABASE=" + config.get("database")
        UID = f"UID=" + config.get("username")
        PWD = f"PWD=" + config.get("password")
        ENCRYPT = "ENCRYPT=yes"
        TRUST = "TrustServerCertificate=yes"

        connection_params = [DRVIER, SERVER, DATABASE, TRUST, UID, PWD]
        connection_string = ";".join(connection_params)
        return connection_string

    elif running_system == "Windows":
        config = parse_config("connection_configs/windows_connection_config")

        DRVIER = f"DRIVER=" + config.get("driver")
        SERVER = f"SERVER=" + config.get("server")
        DATABASE = f"DATABASE=" + config.get("database")
        TRUSTED_CONNECTION = "Trusted_Connection=" + config.get("trusted_connection") 

        connection_params = [DRVIER, SERVER, DATABASE, TRUSTED_CONNECTION, UID, PWD]
        connection_string = ";".join(connection_params)
        return connection_string

    else:
        print("Unknown running system:", running_system)
        return None
    

    


def generate_insert_files(data_xlsx, sheet_name):
    df = pd.read_excel(data_xlsx, sheet_name = sheet_name)
    insert = __dataframe_to_sql_insert(df, sheet_name)
    with open(f"insert_into_{sheet_name}.sql", "w") as f:
        f.write(insert)

def parse_config(config_file):
    with open(f"{config_file}.json", "r") as file:
        data = json.load(file)
        return data
    return None


def __format_value(value):
    if value is None or value == np.nan:
        return "NULL"
    
    elif isinstance(value, str):
        value_ = value.replace("'", "''")
        return f"'{value_}'"
    
    elif ":" in str(value) and "-" in str(value):
        return f"'{value}'"
    
    elif isinstance(value, bool):
        return f"{1 if value else 0}"
    
    else:
        s = str(value)
        s = s.replace("'", "''")
        return s

def __dataframe_to_sql_insert(dataframe, table_name):
    insert_statements = []

    for index, row in dataframe.iterrows():
        values = ', '.join([__format_value(value) for value in row])
        insert_statement = f"INSERT INTO {table_name} VALUES ({values});"
        insert_statement = insert_statement.replace("nan", "NULL")
        insert_statement = insert_statement.replace("NaT", "NULL")
        insert_statements.append(insert_statement)
    
    return '\n'.join(insert_statements)

def __format_nan(array):
    return [__float_none(a) for a in array]

def __float_none(x):
    if isinstance(x, float) and math.isnan(x):
        return None
    else:
        return x