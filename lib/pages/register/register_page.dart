import 'package:flutter/material.dart';
import 'package:flutter_nodejs_example/api/controller/user_controller.dart';
import 'package:flutter_nodejs_example/api/model/user_model.dart';
import 'package:get/get.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Yeni kayıt ekleme sayfası
  UserController? userController;
  TextEditingController userNameController = TextEditingController();
  TextEditingController userPasswordController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController userTypeController = TextEditingController();
  TextEditingController recordUserController = TextEditingController();
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
        title: const Text('Yeni Kayıt Ekle'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
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
                // Kullanıcı adı girişi
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Kullanıcı Adı',
                    prefixIcon: Icon(Icons.person),
                  ),
                  controller: userNameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Lütfen kullanıcı adı girin.';
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

                // Kullanıcı tipi girişi
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Kullanıcı Tipi',
                    prefixIcon: Icon(Icons.person),
                  ),
                  controller: userTypeController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Lütfen kullanıcı tipi girin.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Kayıt eden girişi

                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Kayıt Eden',
                    prefixIcon: Icon(Icons.person),
                  ),
                  controller: recordUserController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Lütfen kullanıcı tipi girin.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Kaydet butonu
                ElevatedButton(
                  onPressed: () async {
                    // Form verilerini kontrol et
                    FormState? formState = formKey.currentState;
                    if (formState != null && !formState.validate()) {
                      return;
                    }

                    // Kullanıcıyı kaydet
                    UserModel userData = UserModel(
                      userID: -1,
                      userName: userNameController.text,
                      userPassword: userPasswordController.text,
                      phoneNumber: phoneNumberController.text,
                      userType: int.parse(userTypeController.text),
                      isPassive: false,
                      recordUser: recordUserController.text,
                    );
                    await userController!.addOrUpdateUser(userData).then((resP) {
                      if (resP) {
                        // Sayfayı kapat
                        Get.back();
                        // Kayıt başarılı mesajı göster
                        Get.snackbar(
                          'Kayıt Başarılı',
                          'Kayıt başarılı.',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.green,
                          colorText: Colors.white,
                        );
                      } else {
                        Get.snackbar(
                          'Kayıt Başarısız',
                          'Kayıt başarısız.',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                      }
                    });
                  },
                  child: const Text('Kaydet'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
