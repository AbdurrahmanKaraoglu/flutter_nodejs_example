import 'package:flutter/material.dart';
import 'package:flutter_nodejs_example/api/controller/user_controller.dart';
import 'package:flutter_nodejs_example/pages/home/home_page.dart';
import 'package:get/get.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Giriş yapma sayfası
  UserController? userController;

  TextEditingController userPasswordController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    userController = Get.find<UserController>(tag: "Main");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Giriş Yap'),
        leading: const SizedBox(),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            shadowColor: Colors.black.withOpacity(0.2),
            elevation: 5.0,
            child: Column(
              children: [
                // Telefon numarası girişi
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Telefon Numarası',
                    prefixIcon: Icon(Icons.phone),
                  ),
                  controller: phoneNumberController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Lütfen telefon numarası girin.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Şifre girişi
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Şifre',
                    prefixIcon: Icon(Icons.lock),
                  ),
                  controller: userPasswordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Lütfen şifre girin.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Giriş butonu
                ElevatedButton(
                  onPressed: () async {
                    // userController!.getSysModulList();
                    await userController!.getSysModulSubListFromOtherAppV2(1);
                    // // Form verilerini kontrol et
                    // FormState? formState = formKey.currentState;
                    // if (formState != null && !formState.validate()) {
                    //   return;
                    // }

                    // userController!.userName.value = "Abddurrahman";

                    // // Kullanıcıyı Giriş Yapma

                    // await userController!.loginUser(phoneNumberController.text, userPasswordController.text).then((value) {
                    //   if (value.userID! > 0) {
                    //     Get.offAll(() => const HomePage());
                    //     Get.snackbar(
                    //       'Giriş Başarılı',
                    //       'Giriş başarılı.',
                    //       snackPosition: SnackPosition.BOTTOM,
                    //       backgroundColor: Colors.green,
                    //       colorText: Colors.white,
                    //     );
                    //   } else {
                    //     Get.snackbar(
                    //       'Giriş Başarısız',
                    //       'Giriş başarısız.',
                    //       snackPosition: SnackPosition.BOTTOM,
                    //       backgroundColor: Colors.red,
                    //       colorText: Colors.white,
                    //     );
                    //   }
                    // });

                    // // userController!.addOrUpdateUser(userData).then((resP) {
                    // //   if (resP) {
                    // //     // Giriş başarılı mesajı göster
                    // // Get.offAll(() => const HomePage());
                    // //     Get.snackbar(
                    // //       'Kayıt Başarılı',
                    // //       'Kayıt başarılı.',
                    // //       snackPosition: SnackPosition.BOTTOM,
                    // //       backgroundColor: Colors.green,
                    // //       colorText: Colors.white,
                    // //     );
                    // //   } else {
                    // //     Get.snackbar(
                    // //       'Kayıt Başarısız',
                    // //       'Kayıt başarısız.',
                    // //       snackPosition: SnackPosition.BOTTOM,
                    // //       backgroundColor: Colors.red,
                    // //       colorText: Colors.white,
                    // //     );
                    // //   }
                    // // });
                  },
                  child: const Text('Giriş'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
