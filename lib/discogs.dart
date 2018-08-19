import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'dart:io';

class DiscogsClient{
  static const String TOKEN = "Discogs token=ZVFHgKVbmrKrayyNLUVcqftXqmFwLTafJTsdDaVO";

  Future<String> albumName(String barcode) async {
    final url = "https://api.discogs.com/database/search?q=$barcode&barcode";
    final response = await http.get(
      url,
      headers: {
        HttpHeaders.AUTHORIZATION: TOKEN,
        HttpHeaders.USER_AGENT: "FooBarApp/3.0"
      }
    );
    print(response.statusCode);
    print(response.body);
    if (response.statusCode != 200) throw "No Results";
    final Map<String, dynamic> data = jsonDecode(response.body);
    return data["results"][0]["title"];
  }
}
