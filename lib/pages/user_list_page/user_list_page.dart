import 'package:flutter/material.dart';
import 'package:flutter_nodejs_example/api/controller/user_controller.dart';
import 'package:flutter_nodejs_example/pages/user_update/user_update.dart';
import 'package:get/get.dart';

class UserListPage extends StatefulWidget {
  const UserListPage({super.key});

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  TextEditingController searchTextController = TextEditingController();

  UserController? userController;
  @override
  void initState() {
    userController = Get.find<UserController>(tag: "Main");
    dataLoad();
    super.initState();
  }

  Future<void> dataLoad() async {
    await userController!.getUserList('');
    await userController!.getUserListFromOtherApp('');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User List'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: searchTextController,
              decoration: InputDecoration(
                labelText: 'Search Text',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    final searchText = searchTextController.text;
                    userController!.getUserList(searchText);
                    userController!.getUserListFromOtherApp(searchText);
                  },
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: Obx(
                () => Padding(
                  padding: const EdgeInsets.only(left: 5, right: 5),
                  child: userController!.isLoading.value
                      ? const Center(child: CircularProgressIndicator())
                      : RefreshIndicator(
                          onRefresh: () async {
                            final searchText = searchTextController.text;
                            userController!.getUserList(searchText);
                          },
                          child: ListView.builder(
                            itemCount: userController!.userList.length,
                            itemBuilder: (context, index) {
                              final user = userController!.userList[index];
                              return ListTile(
                                title: Text(user.userName ?? 'Boş'),
                                subtitle: Text(user.phoneNumber ?? 'Boş'),
                                leading: CircleAvatar(
                                  backgroundColor: Colors.deepPurple,
                                  child: Text(
                                    user.userName!.substring(0, 1).toUpperCase(),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () async {
                                    // await userController!.deleteUser(user.userID!);
                                    // final searchText = searchTextController.text;
                                    // userController!.getUserList(searchText);
                                  },
                                ),
                                onTap: () async {
                                  userController!.userModel.value = user;
                                  Get.to(() => const UserUpdatePage());
                                },

                                // Diğer kullanıcı bilgileri eklenebilir
                              );
                            },
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
