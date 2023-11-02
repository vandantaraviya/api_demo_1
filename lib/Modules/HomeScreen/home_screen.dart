import 'package:api_demo_1/Modules/HomeScreen/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Ayahs/ayahs_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Homecontroller homecontroller = Get.put(Homecontroller());

  @override
  void initState() {
    // TODO: implement initState
    homecontroller.getDataApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
        centerTitle: true,
      ),
      body: Obx(() {
        return homecontroller.dataList.isEmpty
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemExtent: 80,
                itemCount: homecontroller.dataList.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Card(
                    shadowColor: Colors.indigo,
                    elevation: 5,
                    child: ListTile(
                      onTap: () {
                        Get.to(
                          AyahsScreen(title: homecontroller.dataList[index].englishName.toString(),),
                          arguments:  homecontroller.dataList[index],
                        );
                      },
                      leading: Text('${1 + index}'),
                      title: Text(homecontroller.dataList[index].englishName
                          .toString()),
                      subtitle:
                          Text(homecontroller.dataList[index].name.toString()),
                    ),
                  );
                });
      }),
    );
  }
}
