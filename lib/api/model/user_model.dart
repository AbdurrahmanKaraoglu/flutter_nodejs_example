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
    //  tcNo: json['TCNo'] != null ? EncryptService().decrypt(json['TCNo']) : "",
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

class SessionUserModel {
  int? userID;
  String? phoneNumber;
  String? userName;
  int? userType;
  String? userJwtToken;

  SessionUserModel({
    this.userID,
    this.phoneNumber,
    this.userName,
    this.userType,
    this.userJwtToken,
  });

  SessionUserModel.fromJson(Map<String, dynamic> json) {
    userID = json['UserID'];
    phoneNumber = json['PhoneNumber'];
    userName = json['UserName'];
    userType = json['UserType'];
    userJwtToken = json['UserJwtToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['UserID'] = userID;
    data['PhoneNumber'] = phoneNumber;
    data['UserName'] = userName;
    data['UserType'] = userType;
    data['UserJwtToken'] = userJwtToken;
    return data;
  }
}
