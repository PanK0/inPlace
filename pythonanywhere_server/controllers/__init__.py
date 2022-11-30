from flask import Blueprint, request
from models import *

#############################################
## USE THIS FILE TO DEFINE ANY Routes
## Create Sub Blueprints as needed
#############################################

home = Blueprint("home", __name__)

@home.get("/")
def home_home():
    return {"home": "Hello World"}

# Cluster Index Route
#   ret = cursor.fetchall()
#   returns a list of rows as tuples.
#   for r in rows: r[0] is the first attribute, r[1] is the second and so on
@home.get("/clusters")
def home_clusters():
    # map over array of posts converting to tuple of dictionaries
    db_connection.ping(reconnect=True)
    cursor.execute('SELECT * FROM cluster')
    rows = cursor.fetchall()
    db_connection.commit()
    clusters = {}
    dict_attr = ["id", "latitude", "longitude", "avg_radius", "timestamp"]
    for r in rows:
        c = {dict_attr[i] : r[i] for i, _ in enumerate(r)}
        l = c['id']
        clusters[f"{l}"] = c
    print(f"[*] all clusters were given")
    return clusters


# Cluster Show Route
@home.get("/clusters/<id>")
def home_cluster_id(id):
    id = int(id)
    # Retrieve from DATABASE
    cursor.execute('SELECT * FROM cluster')
    rows = cursor.fetchall()
    db_connection.commit()
    # Convert tuple into a dictionary
    dict_attr = ["id", "latitude", "longitude", "avg_radius", "timestamp"]
    return {dict_attr[i] : (rows[id])[i] for i, _ in enumerate(rows[id])}


'''
# Cluster Create
@home.post("/clusters")
def home_cluster_create():
    #get dictionary of request body
    body = request.json
    # create new cluster
    new_cluster = Cluster(body["latitude"], body["longitude"], body["avg_radius"], body["timestamp"])
    # append new Cluster object to clusters array/database

    # Insert cluster into a DATABASE
    sql = "INSERT INTO cluster (latitude, longitude, avg_radius, timestamp) VALUES (%s, %s, %s, %s)"
    val = (new_cluster.lat, new_cluster.lng, new_cluster.avg_radius, new_cluster.timestamp)
    cursor.execute(sql, val)
    print(f"[+] inserted the cluster with average radius: {new_cluster.avg_radius}")
    db_connection.commit()

    # return the new cluster as JSON
    return new_cluster.__dict__
'''