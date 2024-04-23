import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class Type {
  int? totalCount;
  List<Collections>? collections;

  Type({this.totalCount, this.collections});

  factory Type.fromJson(Map<String, dynamic> json) {
    final List<dynamic>? collectionsJson = json['collections'];
    return Type(
      totalCount: json['totalCount'],
      collections: collectionsJson != null
          ? collectionsJson.map((e) => Collections.fromJson(e)).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['totalCount'] = totalCount;
    if (collections != null) {
      data['collections'] = collections!.map((e) => e.toJson()).toList();
    }
    return data;
  }
}

class Collections {
  int? id;
  String? libelle;

  Collections({this.id, this.libelle});

  factory Collections.fromJson(Map<String, dynamic> json) {
    return Collections(
      id: json['id'],
      libelle: json['libelle'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['libelle'] = libelle;
    return data;
  }
}

class TypeService {
  final box = GetStorage();

  Future<List<Object>> typeList() async {
  final box = GetStorage();
  final _token = box.read('token') ?? '';

  final configData = await rootBundle.loadString('assets/config/config.json');
  final configJson = json.decode(configData);

  final gestionBaseUrl = configJson['gestion_baseUrl'];
  final gestionApiKey = configJson['gestion_apiKey'];

  final gestionRegisterUrl = gestionBaseUrl + "api/liste/type/client";

  var headers = {
    'x-api-key': '$gestionApiKey',
    'Authorization': 'Bearer ' + _token
  };

  var request = http.Request('GET', Uri.parse(gestionRegisterUrl));

  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    final responseBody = await response.stream.bytesToString();
    final apiData = jsonDecode(responseBody);

    if (apiData.containsKey("collections")) {
      final List<dynamic> typeData = apiData["collections"];
      List<Type> typeList = typeData.map((item) => Type.fromJson(item)).toList();
      box.write('type', typeList);
      return typeList;
    }
  } else {
    print(response.reasonPhrase);
  }
  return [];
}
}
