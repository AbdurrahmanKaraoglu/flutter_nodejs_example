import 'package:flutter/material.dart';
import 'package:flutter_nodejs_example/api/controller/user_controller.dart';
import 'package:flutter_nodejs_example/api/model/user_model.dart';
import 'package:get/get.dart';

class UserUpdatePage extends StatefulWidget {
  const UserUpdatePage({super.key});

  @override
  State<UserUpdatePage> createState() => _UserUpdatePageState();
}

class _UserUpdatePageState extends State<UserUpdatePage> {
  // Kullanıcı güncelleme sayfası
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
    dataLoad();
    super.initState();
  }

  Future<void> dataLoad() async {
    userNameController.text = userController!.userModel.value.userName!;
    userPasswordController.text = userController!.userModel.value.userPassword!;
    phoneNumberController.text = userController!.userModel.value.phoneNumber!;
    userTypeController.text = userController!.userModel.value.userType.toString();
    recordUserController.text = userController!.userModel.value.recordUser!;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kullanıcı Güncelle'),
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
                // Güncelle butonu
                ElevatedButton(
                  onPressed: () async {
                    // Form verilerini kontrol et
                    FormState? formState = formKey.currentState;
                    if (formState != null && !formState.validate()) {
                      return;
                    }
                    UserModel userModel = UserModel(
                      userID: userController!.sessionUser.value.userID,
                      userName: userNameController.text,
                      userPassword: userPasswordController.text,
                      phoneNumber: phoneNumberController.text,
                      userType: int.parse(userTypeController.text),
                      recordUser: recordUserController.text,
                    );
                    // Kullanıcıyı Güncelle
                    await userController!.addOrUpdateUser(userModel);
                    Get.back();
                  },
                  child: const Text('Güncelle'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
