import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:practical_exam/controller/homeScreenController.dart';

import '../controller/dbHelper.dart';
import '../model/modals.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    DbHelper db = DbHelper();
    homePageController.quote.value = await db.readData();
  }

  TextEditingController addName = TextEditingController();
  TextEditingController sdsAdd = TextEditingController();
  TextEditingController tSdsName = TextEditingController();
  TextEditingController tSdsAdd = TextEditingController();

  HomeScreenController homePageController = Get.put(HomeScreenController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: Drawer(),
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text("Quotes App"),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                homePageController.view.value = true;
              },
              icon: const Icon(Icons.restart_alt_outlined),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          onPressed: () {
            Get.defaultDialog(
              content: Column(
                children: [
                  TextField(
                    controller: addName,
                    decoration: const InputDecoration(hintText: "Name"),
                  ),
                  TextField(
                    controller: sdsAdd,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      hintText: "Add Name",
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                    ),
                    onPressed: () {
                      DbHelper db = DbHelper();
                      db.insertData(addName.text, sdsAdd.text);
                      getData();
                      addName.clear();
                      sdsAdd.clear();
                      Get.back();
                    },
                    child: const Text("Submit"),
                  ),
                ],
              ),
            );
          },
          child: const Icon(Icons.add),
        ),
        body: Obx(
          () => AnimatedOpacity(
            duration: const Duration(seconds: 10),
            opacity: homePageController.view.value == true ? 1.0 : 0.0,
            child: ListView.builder(
              itemCount: homePageController.quote.value.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    homePageController.view.value = true;
                    homePageController.modelClass = Randomly(
                        name: homePageController.quote.value[index]["name"],
                        add: homePageController.quote.value[index]["addName"]);
                    homePageController.dataList
                        .add(homePageController.modelClass!);
                  },
                  child: ListTile(
                    title:
                        Text("${homePageController.quote.value[index]["id"]}"),
                    subtitle: Text(
                        "${homePageController.quote.value[index]["name"]}"),
                    trailing: SizedBox(
                      width: 120,
                      child: Row(
                        children: [
                          Text(
                              "${homePageController.quote.value[index]["addName"]}"),
                          IconButton(
                            onPressed: () {
                              tSdsName = TextEditingController(
                                  text:
                                      "${homePageController.quote.value[index]["name"]}");
                              tSdsAdd = TextEditingController(
                                  text:
                                      "${homePageController.quote.value[index]["addName"]}");
                              Get.defaultDialog(
                                content: Column(
                                  children: [
                                    TextField(
                                      controller: tSdsName,
                                      decoration: const InputDecoration(
                                          hintText: "Name"),
                                    ),
                                    TextField(
                                      controller: tSdsAdd,
                                      decoration: const InputDecoration(
                                          hintText: "Add Name"),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        DbHelper db = DbHelper();
                                        db.updateData(
                                          "${homePageController.quote.value[index]["id"]}",
                                          tSdsName.text,
                                          tSdsAdd.text,
                                        );
                                        getData();
                                        Get.back();
                                      },
                                      child: const Text("Update"),
                                    ),
                                  ],
                                ),
                              );
                            },
                            icon: const Icon(Icons.edit),
                          ),
                          IconButton(
                            onPressed: () {
                              DbHelper db = DbHelper();
                              db.deleteData(
                                  "${homePageController.quote.value[index]["id"]}");
                              getData();
                            },
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
