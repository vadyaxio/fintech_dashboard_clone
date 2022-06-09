import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:maxbonus_index/models/chart.dart';
import 'package:maxbonus_index/models/chart_details.dart';
import 'package:maxbonus_index/models/user.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:maxbonus_index/models/user_factor.dart';

bool isDev = false;
bool isWeb = true;

class API {
  Map<String, String> headers = {};
  final storage = const FlutterSecureStorage();
  //String baseUrl = "expert.maxbonus.ru";
  //String apiStr = "/api/v1/";
  //App
  //String baseUrl = "10.0.2.2";
  //Web
  String baseUrl = isDev
      ? isWeb
          ? "127.0.0.1"
          : "10.0.2.2"
      : "expert.maxbonus.ru";
  String apiStr = isDev ? "/web/api/v1/" : "/api/v1/";

  Future<bool> getJwt() async {
    String? jwt;
    try {
      jwt = await storage.read(key: "jwt");
    } catch (e) {
      jwt = null;
    }
    //clearJwt();
    //print(jwt);
    return jwt != null;
  }

  void clearJwt() async {
    await storage.write(key: "jwt", value: null);
  }

  Future<Response?> response(String params, String type, String body) async {
    Uri url;

    url = isDev
        ? Uri.http(baseUrl, "$apiStr$params")
        : Uri.https(baseUrl, "$apiStr$params");

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
      //print(e);
      clearJwt();
    }
    return data;
  }

  void logoutApi(context) {
    clearJwt();
    Hive.box('common').delete("user");
    Future(() {
      Navigator.of(context).popAndPushNamed('login');
    });
  }

  Future<Map> homeApi(context) async {
    Map<String, List> data = {};
    String params = "fact/factor/1";

    try {
      final res = await response(params, "POST", "");
      //final getData = json.decode(res?.body ?? "");
      logoutApi(context);
      if (res?.statusCode == 200) {}
    } catch (e) {
      clearJwt();
    }
    return data;
  }

  Future<List<UserFactor>> userFactorsApi(context) async {
    String params = "maxbonus-index/user-factors";

    List<UserFactor> data = [];

    try {
      //print('debug');
      final res = await response(params, "GET", "");
      final getData = json.decode(res?.body ?? "");
      if (res?.statusCode == 200) {
        var arrayObjsJson = getData['data']['dataModels'] as List;
        data = arrayObjsJson
            .map((userFactor) => UserFactor.fromJson(userFactor))
            .toList();
      } else if (res?.statusCode == 401) {
        logoutApi(context);
      }
    } catch (e) {
      logoutApi(context);
    }
    return data;
  }

  Future<bool> userUpdateFactorApi(context, UserFactor userFactor) async {
    String params = "maxbonus-index/user-factors";

    bool data = false;

    Map jsonRequestData = userFactor.toJsonDate();
    String jsonRequestBody = json.encode(jsonRequestData);
    try {
      //print('debug');
      final res = await response(params, "POST", jsonRequestBody);
      if (res?.statusCode == 200) {
        data = true;
      } else if (res?.statusCode == 401) {
        logoutApi(context);
      }
    } catch (e) {
      logoutApi(context);
    }
    return data;
  }

  Future<List<Chart>> chartApi(context, Chart chart) async {
    Hive.box('chart').put("periodDate", chart.periodDate);
    Hive.box('chart').put("compareDate", chart.compareDate);
    List<Chart> data = [];
    String params = "maxbonus-index/factors";

    Map jsonRequestData = chart.toJsonDate();
    String jsonRequestBody = json.encode(jsonRequestData);

    try {
      //print('debug');
      final res = await response(params, "POST", jsonRequestBody);
      final getData = json.decode(res?.body ?? "");
      if (res?.statusCode == 200) {
        var arrayObjsJson = getData['data']['dataModels'] as List;
        data = arrayObjsJson
            .map((chartJson) => Chart.fromJson(chartJson))
            .toList();
      } else if (res?.statusCode == 401) {
        logoutApi(context);
      }
    } catch (e) {
      logoutApi(context);
    }
    return data;
  }

  Future<ChartDetails> chartDetailsApi(
      context, ChartDetails chartDetails) async {
    ChartDetails data = chartDetails;
    String params = "maxbonus-index/factor-details/${chartDetails.chart.id}";

    Map jsonRequestData = chartDetails.toJsonDate();
    String jsonRequestBody = json.encode(jsonRequestData);

    try {
      final res = await response(params, "POST", jsonRequestBody);
      final getData = json.decode(res?.body ?? "");
      if (res?.statusCode == 200) {
        data = ChartDetails.fromJson(getData['data']['dataModels']);
      } else if (res?.statusCode == 401) {
        logoutApi(context);
      }
    } catch (e) {
      logoutApi(context);
    }
    return data;
  }
}
