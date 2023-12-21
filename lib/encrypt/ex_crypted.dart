import 'package:encrypt/encrypt.dart' as enc;
import 'dart:convert';

import 'package:flutter/material.dart';

class EncryptService {
  // enc.Key keyEncrypter = enc.Key.fromUtf8("fSBgedpOWy3C4C/mE3TfMJi/0IIclcfMwDxuoL5fxvQ=");
  enc.Key keyEncrypter = enc.Key.fromBase64("fSBgedpOWy3C4C/mE3TfMJi/0IIclcfMwDxuoL5fxvQ=");
  enc.IV ivEncrypter = enc.IV.fromUtf8("TMY9CPr84wgbUik6");

  // ExCrypted()
  //     : keyEncrypter = enc.Key.fromLength(32),
  //       ivEncrypter = enc.IV.fromLength(16);

  String encrypt(String text) {
    try {
      if (text.isEmpty || text == null) {
        return "";
      }
      enc.Encrypter encrypter = enc.Encrypter(enc.AES(
        keyEncrypter,
        mode: enc.AESMode.cbc,
      ));

      final encrypted = encrypter.encrypt(text, iv: ivEncrypter);
      return base64Encode(encrypted.bytes);
    } on Exception catch (e) {
      debugPrint("encrypt Hata: $e");
      return "";
    }
  }

  String decrypt(String encryptedBase64) {
    try {
      if (encryptedBase64.isEmpty || encryptedBase64 == null) {
        return "";
      }
      enc.Encrypter encrypter = enc.Encrypter(enc.AES(
        keyEncrypter,
        mode: enc.AESMode.cbc,
      ));

      final encryptedBytes = base64Decode(encryptedBase64);
      final encrypted = enc.Encrypted(encryptedBytes);
      final decrypted = encrypter.decrypt(encrypted, iv: ivEncrypter);

      return decrypted;
    } on Exception catch (e) {
      debugPrint("decrypt Hata: $e");
      return "";
    }
  }
}


// import 'package:encrypt/encrypt.dart' as enc;


// class ExCrypted {
//   enc.Key keyEncrypter = enc.Key.fromUtf8("11ae0859e6454aa178ea5475ff24764d");
//   enc.IV ivEncrypter = enc.IV.fromUtf8("1234567890abcdef");
//   String encrypt(String text) {
//     enc.Encrypter encrypter = enc.Encrypter(enc.AES(
//       keyEncrypter,
//       mode: enc.AESMode.cbc,
//     ));

//     // final iv = IV.fromLength(16);
//     final encrypted = encrypter.encrypt(text, iv: ivEncrypter);
//     return encrypted.base64;
//   }

//   String decrypt(String text) {
//     enc.Encrypter encrypter = enc.Encrypter(enc.AES(
//       keyEncrypter,
//       mode: enc.AESMode.cbc,
//     ));

//     // final iv = IV.fromLength(16);
//     final decrypted = encrypter.decrypt64(text, iv: ivEncrypter);
//     return decrypted;
//   }
// }

// Şifreleme
      // String encrypted = ExCrypted().encrypt("$userID");

// Şifre çözme
      // String decrypted = ExCrypted().decrypt(encrypted);
      // print("decrypted: $decrypted");

//       class WebUserPushTokenListModel {
//   String? userID;
//   String? pushToken;

//   WebUserPushTokenListModel({this.userID, this.pushToken});

//   WebUserPushTokenListModel.fromJson(Map<String, dynamic> json) {
//     userID = json['userID'] != null ? ExCrypted().decrypt(json['userID']) : "";

//     pushToken = json['pushToken'] != null ? ExCrypted().decrypt(json['pushToken']) : "";
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['userID'] = userID;
//     data['pushToken'] = pushToken;
//     return data;
//   }
// }
