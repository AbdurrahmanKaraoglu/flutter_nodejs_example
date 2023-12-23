import 'package:flutter/material.dart';
import 'package:flutter_nodejs_example/api/controller/user_controller.dart';
import 'package:flutter_nodejs_example/pages/register/register_page.dart';
import 'package:flutter_nodejs_example/pages/user_list_page/user_list_page.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  UserController? userController;
  @override
  void initState() {
    userController = Get.find<UserController>(tag: "Main");

    debugPrint('serController!.userName.value : ${userController!.userName.value}');

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        leading: const SizedBox(),
      ),
      // Ekranın ortasında 2 tane conteiner dan yapılmış buton olacak ve bu butonlar yeni kayıt ekle ve kullanıcıları listeleme butonları olacak
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                Get.to(() => const RegisterPage());
              },
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                width: 200,
                height: 50,
                alignment: Alignment.center,
                child: const Text('Yeni Kayıt Ekle'),
              ),
            ),
            const SizedBox(height: 20),
            InkWell(
              onTap: () {
                Get.to(() => const UserListPage());
              },
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                width: 200,
                height: 50,
                alignment: Alignment.center,
                child: const Text('Kullanıcıları Listele'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
