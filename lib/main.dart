import 'dart:async';
import 'package:api_demo_1/Modules/HomeScreen/home_screen.dart';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:sizer/sizer.dart';

late AudioHandler audioHandler;

Future<void> main() async {
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Audio Service Demo',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
        ),
        home:  const HomeScreen(),
      ),
    );
  }
}
