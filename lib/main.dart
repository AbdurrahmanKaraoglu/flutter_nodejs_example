import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_nodejs_example/api/controller/user_controller.dart';

import 'package:flutter_nodejs_example/pages/login/login_page.dart';
import 'package:get/get.dart';

import 'package:encrypt/encrypt.dart' as enc;

void main() {
  // final ivEncrypter = enc.IV.fromUtf8("1234567890abcdef");
  // final ivBase64 = base64Encode(ivEncrypter.bytes);

  enc.IV ivEncrypter = enc.IV.fromLength(32); // Her şifreleme için yeni bir IV üretin
  String ivBase64 = base64Encode(ivEncrypter.bytes);
  print('IV from Flutter: $ivBase64');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialBinding: HomeBindings(),
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}

class HomeBindings implements Bindings {
  @override
  void dependencies() {
    // ignore: unused_local_variable
    UserController userController = Get.put<UserController>(UserController(), tag: 'Main');
  }
}
