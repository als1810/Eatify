import mysql.connector

def get_connection():
    return mysql.connector.connect(
        host="localhost",
        user="username",  # change this         
        password="password",  # change this
        database="Eatify"
    )
