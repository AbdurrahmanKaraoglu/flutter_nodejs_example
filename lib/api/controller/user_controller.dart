import 'package:flutter/material.dart';
import 'package:flutter_nodejs_example/api/model/user_model.dart';
import 'package:flutter_nodejs_example/api/services/base_client.dart';
import 'package:flutter_nodejs_example/encrypt/ex_crypted.dart';
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
  Rx<UserModel> userModel = UserModel().obs;

  RxString userName = ''.obs;

  Future<void> getSysModulList() async {
    try {
      setLoading(true);

      final response = await http.get(
        Uri.parse('https://portakil-master-db-09fe3ef6ad55.herokuapp.com/system/sysModulSubList?upModulID=1'),
        // headers: <String, String>{
        //   'Content-Type': 'application/json; charset=UTF-8',
        //   'Access-Control-Allow-Origin': '*',
        // },
      );

      if (response.statusCode == 200) {
        debugPrint('response.body: ${response.body}');
      } else {
        // Handle error
        debugPrint('HTTP isteği başarısız: ${response.statusCode}');
      }

      setLoading(false);
    } on Exception catch (e) {
      debugPrint('Hata: $e');
      setLoading(false);
    }
  }

  Rx<SessionUserModel> sessionUser = SessionUserModel().obs;

  Future<SessionUserModel> loginUser(String phoneNumber, String userPassword) async {
    String apiUrl = 'https://app-sence-sql-b5f497e5247d.herokuapp.com/login'; // API URL'nizi buraya ekleyin

    //   if (dataStudent.isNotEmpty && dataStudent.first.tcNo!.isNotEmpty) {
    //   dataStudent.first.tcNo = EncryptService().encrypt(dataStudent.first.tcNo!);
    // }

    try {
      sessionUser = SessionUserModel(
        userID: -1,
        userName: '',
        phoneNumber: '',
        userJwtToken: '',
        userType: -1,
      ).obs;

      if (phoneNumber.isNotEmpty || userPassword.isNotEmpty) {
        phoneNumber = EncryptService().encrypt(phoneNumber);
        userPassword = EncryptService().encrypt(userPassword);
      } else {
        debugPrint('Telefon numarası veya şifre boş olamaz.');
        return sessionUser.value;
      }

      final http.Response response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'phoneNumber': phoneNumber,
          'userPassword': userPassword,
        }),
      );

      if (response.statusCode == 200) {
        // Başarılı bir şekilde giriş yapıldı

        sessionUser.value = SessionUserModel.fromJson(jsonDecode(response.body));

        debugPrint('sessionUser phoneNumber: ${sessionUser.value.phoneNumber}');
        return sessionUser.value;
      } else if (response.statusCode == 401) {
        // Kimlik doğrulama başarısız
        debugPrint('Kimlik doğrulama başarısız');
        return sessionUser.value;
      } else {
        // Diğer durumlar için hata mesajını al
        debugPrint('HTTP isteği başarısız: ${response.statusCode}');
        return sessionUser.value;
      }
    } catch (error) {
      // Hata durumunda
      return sessionUser.value;
    }
  }

  Future<void> getUserList(String searchText) async {
    try {
      setLoading(true);

      if (sessionUser.value.userJwtToken == '') {
        debugPrint('JWT alınamadı. Kullanıcı listesi alınamaz.');
        setLoading(false);
        return;
      }

      // Kullanıcı listesi isteği için JWT'yi ve UserID'yi kullan
      final response = await http.get(
        Uri.parse('https://app-sence-sql-b5f497e5247d.herokuapp.com/users/listUsers?searchText=$searchText'),
        headers: {
          'Authorization': sessionUser.value.userJwtToken!,
          'UserID': sessionUser.value.userID.toString(), // Kullanıcı kimliği buraya eklenecek
        },
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

  //   if (dataStudent.isNotEmpty && dataStudent.first.tcNo!.isNotEmpty) {
  //   dataStudent.first.tcNo = EncryptService().encrypt(dataStudent.first.tcNo!);
  // }

  Future<bool> addOrUpdateUser(UserModel userData) async {
    try {
      RespMessage respMessage = RespMessage();
      String apiUrl = "https://app-sence-sql-b5f497e5247d.herokuapp.com/users/addOrUpdateUser"; // API URL'sini ve endpoint'i buraya ekleyin

      if (userData.userPassword!.isNotEmpty) {
        userData.userPassword = EncryptService().encrypt(userData.userPassword!);
      } else {
        debugPrint('Şifre boş olamaz.');
        Get.snackbar(
          'Şifre Boş Olamaz',
          'Şifre boş olamaz.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }

      var response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': sessionUser.value.userJwtToken!,
          'UserID': sessionUser.value.userID.toString(), // Kullanıcı kimliği buraya eklenecek
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

  Future<void> getUserListFromOtherApp(String searchText) async {
    try {
      if (sessionUser.value.userJwtToken == '') {
        debugPrint('JWT alınamadı. Kullanıcı listesi alınamaz.');
        setLoading(false);
        return;
      }
      // Diğer Node.js uygulamasının URL'sini buraya ekleyin
      String otherAppUrl = 'https://api-sence-account-ba8802befff0.herokuapp.com';

      final response = await http.get(
        Uri.parse('$otherAppUrl/users/listUsersFromOtherApp'),
        headers: {
          'searchText': searchText,
          'jwtToken': sessionUser.value.userJwtToken!,
          'userID': sessionUser.value.userID.toString(),
        },
      );

      if (response.statusCode == 200) {
        // Başarılı ise JSON verisini parse et ve kullanıcı listesini döndür
        debugPrint('response.body: ${response.body}');
      } else {
        // Başarısız ise hata mesajını yazdır
        debugPrint('HTTP isteği başarısız getUserListFromOtherApp: ${response.statusCode}');
      }
    } catch (error) {
      // Hata durumunda hata mesajını yazdır
      debugPrint('Hata: $error');
    }
  }

  Future<bool> sysModulAdd(UserModel userData) async {
    try {
      RespMessage respMessage = RespMessage();
      String apiUrl = "https://portakil-master-db-09fe3ef6ad55.herokuapp.com/system/sysModulAdd"; // API URL'sini ve endpoint'i buraya ekleyin

      Map<String, dynamic> params = {
        "modulID": userData.userID,
        "modulName": userData.userName,
      };

      var response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(params),
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

//---------------------------------------------------------------------------------------
  Future<RespMessage> sysModulAddV2(UserModel userData) async {
    RespMessage respMessage = RespMessage();
    try {
      Map<String, dynamic> params = {
        "modulID": userData.userID,
        "modulName": userData.userName,
      };

      var response = await BaseClient.post('/system/sysModulAdd', params);

      if (response.statusCode == 200) {
        respMessage = RespMessage.fromJson(json.decode(response.body));

        return respMessage;
      } else {
        return respMessage;
      }
    } on Exception catch (e) {
      debugPrint("Hata sendPayment $e");
      return respMessage;
    }
  }

  Future<void> getSysModulSubListV2() async {
    try {
      setLoading(true);

      Map<String, dynamic> queryParameters = {
        'upModulID': "1",
        //  'param2': "param2",
        // 'param3': "param3",
      };

      // https://portakil-master-db-09fe3ef6ad55.herokuapp.com/system/sysModulList

      var response = await BaseClient.get('/system/sysModulSubList', queryParameters);

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

  Future<void> getSysModulListV2() async {
    try {
      setLoading(true);

      Map<String, dynamic> queryParameters = {
        // 'upModulID': "1",
        //  'param2': "param2",
        // 'param3': "param3",
      };

      // https://portakil-master-db-09fe3ef6ad55.herokuapp.com/system/sysModulList

      var response = await BaseClient.get('/system/sysModulList', queryParameters);

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
  //---------------------------------------------------------------------------------------
}
