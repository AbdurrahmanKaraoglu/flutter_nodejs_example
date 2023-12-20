import 'dart:convert';

import 'package:get/get.dart';

RxList<UserModel> userModelFromJson(String str) => RxList<UserModel>.from(json.decode(str).map((x) => UserModel.fromJson(x)));

class UserModel {
  int? userID;
  String? userName;
  String? userPassword;
  String? phoneNumber;
  int? userType;
  bool? isPassive;
  String? recordUser;

  UserModel({
    this.userID,
    this.userName,
    this.userPassword,
    this.phoneNumber,
    this.userType,
    this.isPassive,
    this.recordUser,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    userID = json['UserID'];
    userName = json['UserName'];
    userPassword = json['UserPassword'];
    phoneNumber = json['PhoneNumber'];
    userType = json['UserType'];
    isPassive = json['isPassive'];
    recordUser = json['RecordUser'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['UserID'] = userID;
    data['UserName'] = userName;
    data['UserPassword'] = userPassword;
    data['PhoneNumber'] = phoneNumber;
    data['UserType'] = userType;
    data['isPassive'] = isPassive;
    data['RecordUser'] = recordUser;
    return data;
  }
}

class RespMessage {
  int? messageID;
  String? messageDescription;

  RespMessage({
    this.messageID,
    this.messageDescription,
  });

  RespMessage.fromJson(Map<String, dynamic> json) {
    messageID = json['MessageID'];
    messageDescription = json['MessageDescription'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['MessageID'] = messageID;
    data['MessageDescription'] = messageDescription;
    return data;
  }
}
