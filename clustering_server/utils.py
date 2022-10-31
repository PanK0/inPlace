from cmath import asin, sqrt
import math
import networkx as nx
from Point import *
import matplotlib.pyplot as plt

'''
    Earth's radius
'''
radius = 6371.0

'''
    Function to build a list of tuples indicating the geopoints.
    Given in input a firestore_db.collection object, returns a list of Point objects.
    Each tuple is composed by a longitude and a latitude.
    Point = (longitude, latitude)
    Input example: list(guestbook_collection.get())

    Each element e of the list guestbook_list is an object 'DocumentSnapshot',
    So in order to access it it's better to convert e as Dictionary.
    To convert use e.to_dict()    

    To access the geotag field of each message use 
    e.to_dict().get("geotag"). It will return a GeoPoint object g.
    To access coordinates call g.latitude and g.longitude.
'''
def build_list(collection) :
    l = []
    for e in collection :
        p = Point(e.to_dict().get("geotag").latitude, e.to_dict().get("geotag").longitude)
        if p not in l : l.append(p)
    return l


'''
    Function to calculate the distance between two points A and B Earth.
    Coordinates are first converted to radians and then calculations are done.
'''
def get_distance(point_a, point_b) :

    # Convert coordinates from degrees to radians
    lat_a = point_a.latitude
    lng_a = point_a.longitude
    lat_b = point_b.latitude
    lng_b = point_b.longitude

    lat_a, lng_a, lat_b, lng_b = map(math.radians, [lat_a, lng_a, lat_b, lng_b])

    d_lat = lat_a - lat_b
    d_lng = lng_a - lng_b

    temp = (
        math.sin(d_lat / 2) ** 2 +
        math.cos(lat_a) *
        math.cos(lat_b) *
        math.sin(d_lng / 2) ** 2
    )

    # 6371 km is the radius of planet Earth
    return round(radius * (2 * math.atan2(math.sqrt(temp), math.sqrt(1-temp))), 2)


'''
    Function to find the center of a cluster.
    Assume to operate on a flat surface.
'''
def get_cluster_center(cluster) :
    l = len(cluster)
    lat = 0.0
    lng = 0.0
    i = 0
    for p in cluster :
        lat += p.latitude
        lng += p.longitude
        i += 1
    center = Point(round(lat/i, 6), round(lng/i, 6))

    # radius of the average of the distances of the points from the center
    # expressed in km
    avg_radius = 0.0
    i = 0
    for p in cluster :
        avg_radius += get_distance(center, p)
        i += 1
    avg_radius = round(avg_radius / i, 2)

    return center, avg_radius

