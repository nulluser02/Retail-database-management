import pandas as pd
import mysql.connector
from mysql.connector import Error

def load_csv_to_mysql(csv_file_path, mysql_host, mysql_user, mysql_password, mysql_db, table_name):
    try:
        # Connect to MySQL
        connection = mysql.connector.connect(
            host=mysql_host,
            user=mysql_user,
            password=mysql_password,
            database=mysql_db
        )

        if connection.is_connected():
            print("Connected to MySQL database")
            
            # Read the CSV file into a pandas DataFrame
            df = pd.read_csv(csv_file_path)
            
            # Create a cursor to execute SQL queries
            cursor = connection.cursor()
            
            # Create a SQL query to insert the data into the table
            for i, row in df.iterrows():
                sql_query = f"INSERT INTO {table_name} ({', '.join(df.columns)}) VALUES ({', '.join(['%s']*len(row))})"
                cursor.execute(sql_query, tuple(row))
            
            # Commit the transaction
            connection.commit()
            print(f"Data successfully loaded into {table_name} table.")
            
    except Error as e:
        print(f"Error: {e}")
    finally:
        if connection.is_connected():
            cursor.close()
            connection.close()
            print("MySQL connection is closed.")

# Usage Example:
csv_file_path = '/users/download/data/'
mysql_host = 'localhost'
mysql_user = 'User'
mysql_password = '*******'
mysql_db = 'retail_db'
table_name = ['Bill','Customer','Employee','Orders','Payment','Product Details', 'Product group', 'Product','Reviews','Voucher','Zipcode','address','order','Supplier']

load_csv_to_mysql(csv_file_path, mysql_host, mysql_user, mysql_password, mysql_db, table_name)
