import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:maxbonus_index/models/chart.dart';
import 'package:maxbonus_index/models/chart_details.dart';
import 'package:maxbonus_index/models/user.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';

class API {
  Map<String, String> headers = {};
  final storage = new FlutterSecureStorage();
  String baseUrl = "expert.maxbonus.ru";
  String apiStr = "/api/v1/";
  //App
  //String baseUrl = "10.0.2.2";
  //Web
  //String baseUrl = "127.0.0.1";
  //String apiStr = "/web/api/v1/";

  Future<bool> getJwt() async {
    String? jwt = await storage.read(key: "jwt");
    //clearJwt();
    //print(jwt);
    return jwt != null;
  }

  void clearJwt() async {
    await storage.write(key: "jwt", value: null);
  }

  Future<Response?> response(String params, String type, String body) async {
    Uri url;

    //url = Uri.http(baseUrl, "$apiStr$params");
    url = Uri.https(baseUrl, "$apiStr$params");

    String? jwt = await storage.read(key: "jwt");

    headers = {
      "Accept": "*/*",
      "Content-type": "application/json",
      'Authorization': 'Bearer $jwt',
    };

    if (type == "POST") {
      return await post(url, headers: headers, body: body);
    } else {
      return await get(url, headers: headers);
    }
  }

  Future<Map> loginApi(User user) async {
    Map<String, dynamic> data = {};
    String params = "login";

    Map jsonRequestData = user.toJson();
    String jsonRequestBody = json.encode(jsonRequestData);

    try {
      final res = await response(params, "POST", jsonRequestBody);
      final getData = json.decode(res?.body ?? "");

      data = getData;
      data["hasError"] = (res?.statusCode == 200) ? false : true;
      if (res?.statusCode == 200) {
        String token = getData["data"]["token"];

        await storage.write(key: "jwt", value: token);

        Hive.box('common').put("user", getData["data"]);
      }
    } catch (e) {
      print(e);
      clearJwt();
    }
    return data;
  }

  void logoutApi() {
    clearJwt();
    Hive.box('common').delete("user");
  }

  Future<Map> homeApi() async {
    Map<String, List> data = {};
    String params = "fact/factor/1";

    try {
      final res = await response(params, "POST", "");
      final getData = json.decode(res?.body ?? "");
      logoutApi();
      if (res?.statusCode == 200) {}
    } catch (e) {
      clearJwt();
    }
    return data;
  }

  Future<List<Chart>> chartApi(Chart chart) async {
    Hive.box('chart').put("periodDate", chart.periodDate);
    Hive.box('chart').put("compareDate", chart.compareDate);
    List<Chart> data = [];
    String params = "maxbonus-index/factors";

    Map jsonRequestData = chart.toJsonDate();
    String jsonRequestBody = json.encode(jsonRequestData);

    try {
      final res = await response(params, "POST", jsonRequestBody);
      final getData = json.decode(res?.body ?? "");
      if (res?.statusCode == 200) {
        var arrayObjsJson = getData['data']['dataModels'] as List;
        data = arrayObjsJson
            .map((chartJson) => Chart.fromJson(chartJson))
            .toList();
      }
    } catch (e) {
      clearJwt();
    }
    return data;
  }

  Future<ChartDetails> chartDetailsApi(ChartDetails chartDetails) async {
    ChartDetails data = chartDetails;
    String params = "maxbonus-index/factor-details/${chartDetails.chart.id}";

    Map jsonRequestData = chartDetails.toJsonDate();
    String jsonRequestBody = json.encode(jsonRequestData);

    try {
      final res = await response(params, "POST", jsonRequestBody);
      final getData = json.decode(res?.body ?? "");
      if (res?.statusCode == 200) {
        data = ChartDetails.fromJson(getData['data']['dataModels']);
      }
    } catch (e) {
      clearJwt();
    }
    return data;
  }
}
