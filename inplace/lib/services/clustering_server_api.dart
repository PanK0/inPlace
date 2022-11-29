import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:inplace/utils/clustersList.dart';

getData(String url) async {
  http.Response response = await http.get(Uri.parse(url));
  return response.body;
}

Future<List<ClustersList>> getClustersFromDB() async {
  List<ClustersList> clusters = [];
  String url = 'https://kewee.pythonanywhere.com/clusters';
  var response = await getData(url);

  try {
    var decoded = await jsonDecode(response);
    for (var c in decoded.values) {
      ClustersList cluster = ClustersList(
          lat: (c['latitude']).toString(),
          lng: (c['longitude']).toString(),
          avg_radius: (c['avg_radius']).toString());
      clusters.add(cluster);
    }
  } catch (e) {
    print(e);
  }
  return clusters;
}

Future<String> testDB() async {
  var ret = "";
  String url = 'https://kewee.pythonanywhere.com/clusters';
  var response = await getData(url);

  ret = response;
  return ret;
}
