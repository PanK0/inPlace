'''
    This module has to ber run in order to retrieve all the message locations from the database,
    calculate the k clusters and upload the cluster centers in the "clusters" collection of the database
'''

from audioop import avg
from distutils.command.config import config
import firebase_admin
import networkx as nx
from firebase_admin import credentials, firestore
from firebase_admin import db
from firebase_admin import firestore
from utils import *
from Point import *
import time



'''
    Fetch the service account key JSON file contents
    On the Firebase console go to Project Settings -> Service Accounts -> Generate new private key
'''
secret_key = "firebase_inplace_key.json"
cred = credentials.Certificate(secret_key)
# Initialize the app with a service account, granting admin privileges
firebase_admin.initialize_app(cred)
firestore_db = firestore.client()


'''
    Access the firestore collection called 'guestbook'
'''
guestbook_collection = firestore_db.collection(u'guestbook')


'''
    Each element e of the list guestbook_list is an object 'DocumentSnapshot',
    So in order to access it it's better to convert e as Dictionary.
    To convert use e.to_dict()    

    To access the geotag field of each message use 
    e.to_dict().get("geotag"). It will return a GeoPoint object g.
    To access coordinates call g.latitude and g.longitude.
'''
guestbook_list = list(guestbook_collection.get())


'''
    Generate the collection of Points, a simple list made of objects p of type Point.
    Make sure that there are no duplicates in the list.
    This function is declared in the file utils.py
'''
list_of_points = build_list(guestbook_list)
# for e in list_of_points : print (e)


'''
    Obtain k clusters.
    Using the library networkx @ https://networkx.org/documentation/latest/tutorial.html
    - build the graph
    - add edges to the graph. Each edge is a list [P1, P2, get_distance(P1, P2)]
    - obtain the minimum spanning tree mst
    - sort the mst in crescent order with key the weight of each edge
    - determine the number k of clusters we want
    - remove the last k-1 edges from the mst to separate the clusters
    - obtain the connected components
'''
# Build the graph
g = nx.Graph()

# Add edges to the graph
# NW: in order to add Point objects as edges, the class Point should implement an __hash__() method
for p1 in list_of_points :
    for p2 in list_of_points :
        if (p1 != p2) :
            d = get_distance(p1, p2)
            g.add_edge(p1, p2, weight=d)

# Obtain the MST
# Ref @ https://networkx.org/documentation/stable/reference/algorithms/generated/networkx.algorithms.tree.mst.minimum_spanning_tree.html
mst = nx.minimum_spanning_tree(g)

# Sort the MST
# Read @ https://www.programiz.com/python-programming/methods/built-in/sorted
# for the sorted() function
def sorter(item) :
    return item[2]['weight']
list = sorted(mst.edges(data=True), key=sorter)

# Determine the number k of clusters (k = 10 by default)
k = 10
if len(list) < k : k = len(list)

# Cut the last k-1 edges from the MST to separate the clusters
# RW : edge[0] and edge[1] are the two nodes od the edge
list = list[-k+1:]
for edge in list :
    mst.remove_edge(edge[0], edge[1])

# Print all the edges in the MST
#for e in mst.edges.data() : print (f"{e[0]}, {e[1]} - {e[2]['weight']}")

# Obtain the connected components
connected_comp = nx.connected_components(mst)

# Print the connected components
'''
print (f"We have {k} onnected components: \n")
for e in connected_comp :
    for k in e :
        print (k)
    center, avg_radius = get_cluster_center(e)
    print (f"Mean point: ({center.latitude}, {center.longitude}), with an average radius of {avg_radius}km")
    print ("###################")
'''


'''
    Access the firestore collection called 'clusters'
'''
clusters_collection = firestore_db.collection(u'clusters')


'''
    Calculate and upload the cluster centers as GeoPoint objects
'''
cluster_centers = []
for e in connected_comp :
    center, avg_radius = get_cluster_center(e)
    cluster_centers.append([center, avg_radius])


'''
    Upload the cluster centers on firebase
'''
for c in cluster_centers :
    geopoint = firestore.GeoPoint(c[0].latitude, c[0].longitude)
    ts = time.time()
    clusters_collection.add({'geotag': geopoint, 'avg_radius': c[1], 'timestamp': ts})




