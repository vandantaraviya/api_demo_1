import 'package:api_demo_1/Model/data_model.dart';
import 'package:api_demo_1/utils/common%20widget/common_seekBar.dart';
import 'package:api_demo_1/utils/common%20widget/control_buttons.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sizer/sizer.dart';
import 'package:audio_session/audio_session.dart';

class AudioScreen extends StatefulWidget {
  const AudioScreen({
    super.key,
    this.ayahs,
    this.index,
  });

  final List<Ayahs>? ayahs;
  final int? index;

  @override
  State<AudioScreen> createState() => _AudioScreenState();
}

class _AudioScreenState extends State<AudioScreen> {
  var audioList = <AudioSource>[].obs;
  final player = AudioPlayer();
  RxInt currentIndex = 0.obs;

  @override
  void initState() {
    super.initState();
    currentIndex.value = widget.index!;
    widget.ayahs?.forEach(
      (element) async {
        audioList.add(
          AudioSource.uri(
            Uri.parse(element.audio.toString()),
            tag: MediaItem(
              id: '1',
              title: element.text.toString(),
              artUri: Uri.parse(
                  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ5d2dnA0eXwRocpX4yM1pxSc4_jAT7kAKuEw&usqp=CAU"),
            ),
          ),
        );
      },
    );
    init();
  }

  Future<void> init() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());
    await player.setAudioSource(ConcatenatingAudioSource(children: audioList),
        initialIndex: currentIndex.value,
        preload: kIsWeb || defaultTargetPlatform != TargetPlatform.linux);
  }

  @override
  void dispose() {
    super.dispose();
    player.dispose();
  }

  static Stream<T> combineLatest3<A, B, C, T>(
          Stream<A> streamA,
          Stream<B> streamB,
          Stream<C> streamC,
          T Function(A a, B b, C c) combiner) =>
      CombineLatestStream.combine3(streamA, streamB, streamC, combiner);

  Stream<PositionData> get positionDataStream =>
      combineLatest3<Duration, Duration, Duration?, PositionData>(
          player.positionStream,
          player.bufferedPositionStream,
          player.durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: texttitle(),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 12, right: 12, left: 12),
            child: Container(
              height: 45.h,
              width: 150.w,
              decoration: BoxDecoration(
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black,
                    blurStyle: BlurStyle.solid,
                    blurRadius: 10,
                  )
                ],
                borderRadius: BorderRadius.circular(50),
                image: const DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage('Assets/quran.jpeg'),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 4.h,
          ),
          texttitle(),
          SizedBox(
            height: 3.h,
          ),
          StreamBuilder<PositionData>(
            stream: positionDataStream,
            builder: (context, snapshot) {
              final positionData = snapshot.data;
              return SeekBar(
                duration: positionData?.duration ?? Duration.zero,
                position: positionData?.position ?? Duration.zero,
                bufferedPosition:
                    positionData?.bufferedPosition ?? Duration.zero,
                onChangeEnd: (position) {
                  player.seek(position);
                },
              );
            },
          ),
          SizedBox(
            height: 4.h,
          ),
          ControlButtons(player, initialIndex: currentIndex.value),
        ],
      ),
    );
  }

  Widget texttitle() {
    return StreamBuilder<SequenceState?>(
      stream: player.sequenceStateStream,
      builder: (context, snapshot) {
        final state = snapshot.data;
        if (state?.sequence.isEmpty ?? true) {
          return const SizedBox();
        }
        final metadata = state!.currentSource!.tag as MediaItem;
        return Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            metadata.title,
            overflow: TextOverflow.ellipsis,
          ),
        );
      },
    );
  }
}
