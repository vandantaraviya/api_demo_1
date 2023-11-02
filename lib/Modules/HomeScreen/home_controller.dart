import 'dart:convert';
import 'package:api_demo_1/Model/data_model.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class Homecontroller extends GetxController {
  var dataList = <Surahs>[].obs;

  getDataApi() async {
    try {
      final response = await http.get(Uri.parse('https://api.alquran.cloud/v1/quran/ar.alafasy'));
      Datamodel datamodel = Datamodel.fromJson(jsonDecode(response.body));
      dataList.value = datamodel.data!.surahs!;
    } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      rethrow;
    }
  }
}