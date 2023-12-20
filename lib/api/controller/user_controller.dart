import 'package:flutter/material.dart';
import 'package:flutter_nodejs_example/api/model/user_model.dart';
import 'package:get/get.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

class UserController extends GetxController {
  Rx<bool> isLoading = false.obs;
  void setLoading(bool value) {
    isLoading.value = value;

    update();
  }

  RxList<UserModel> userList = RxList<UserModel>();

  RxString userName = ''.obs;

  Future<void> getUserList(String searchText) async {
    try {
      setLoading(true);
      userList.clear();
      final response = await http.get(
        Uri.parse('https://app-sence-sql-b5f497e5247d.herokuapp.com/users/listUsers?searchText=$searchText'),
      );

      if (response.statusCode == 200) {
        userList.value = userModelFromJson(response.body);
      } else {
        userList.clear();
        // Handle error
        debugPrint('HTTP isteği başarısız: ${response.statusCode}');
      }

      userList.refresh();

      setLoading(false);
    } on Exception catch (e) {
      debugPrint('Hata: $e');
      setLoading(false);
    }
  }

  Future<bool> addOrUpdateUser(UserModel userData) async {
    try {
      RespMessage respMessage = RespMessage();
      String apiUrl = "https://app-sence-sql-b5f497e5247d.herokuapp.com/users/addOrUpdateUser"; // API URL'sini ve endpoint'i buraya ekleyin

      var response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'userID': userData.userID,
          'userName': userData.userName,
          'userPassword': userData.userPassword,
          'phoneNumber': userData.phoneNumber,
          'userType': userData.userType,
          'isPassive': userData.isPassive,
          'recordUser': userData.recordUser,
        }),
      );

      if (response.statusCode == 200) {
        // Başarılı bir şekilde cevap alındı
        respMessage = RespMessage.fromJson(json.decode(response.body));

        return true;
      } else {
        // Başarısız bir HTTP isteği durumunda buraya düşer
        debugPrint("HTTP isteği başarısız: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      // Hata durumunda buraya düşer
      debugPrint("Hata: $e");
      return false;
    }
  }
}
