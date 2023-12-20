import 'package:flutter/material.dart';
import 'package:flutter_nodejs_example/api/controller/user_controller.dart';
import 'package:flutter_nodejs_example/pages/home/home_page.dart';
import 'package:get/get.dart';

void main() {
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
      home: const HomePage(),
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
