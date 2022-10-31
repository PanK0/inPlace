'''
    Class to build a fake geopoint object
'''
class Point:
    def __init__(self, latitude, longitude) :
        self.latitude = latitude
        self.longitude = longitude

    def __str__(self) :
        return f"({self.latitude}, {self.longitude})"

    def __eq__(self, other) :
        if isinstance(other, Point) :
            return self.latitude == other.latitude and self.longitude == other.longitude
        return False

    # This is needed in order to use Point objects with the Networkx library for graphs
    def __hash__(self):
        return hash(hash(str(self.latitude)) + hash(str(self.longitude)))