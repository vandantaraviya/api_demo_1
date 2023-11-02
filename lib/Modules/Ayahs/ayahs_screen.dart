import 'package:api_demo_1/Model/data_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

import '../AudioScreen/audio_screen.dart';

class AyahsScreen extends StatefulWidget {
  const AyahsScreen({
    super.key, this.title,});
  final String? title;

  @override
  State<AyahsScreen> createState() => _AyahsScreenState();
}

class _AyahsScreenState extends State<AyahsScreen> {
  Surahs? surahs;
  final player = AudioPlayer();


  @override
  void initState() {
    surahs = Get.arguments;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    player.stop();
    for (var element in surahs!.ayahs!) {
      element.isPlaying!.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title!),
      ),
      body: ListView.builder(
          itemExtent: 80,
          itemCount: surahs!.ayahs!.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Card(
              shadowColor: Colors.indigo,
              elevation: 5,
              child: ListTile(
                leading: Text('${1 + index}'),
                title: Text(surahs!.ayahs![index].text.toString(),
                    overflow: TextOverflow.ellipsis),
                trailing: CircleAvatar(
                  child: IconButton(
                    onPressed: () {
                      Get.to(AudioScreen(ayahs: surahs!.ayahs,index: index,));
                    },
                    icon: const Icon(Icons.play_arrow),
                  ),
                ),
              ),
            );
          }),
    );
  }
}
