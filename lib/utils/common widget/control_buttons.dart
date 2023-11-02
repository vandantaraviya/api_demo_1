import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:sizer/sizer.dart';

class ControlButtons extends StatelessWidget {
  final AudioPlayer player;
  final int initialIndex;
  ControlButtons(this.player, {Key? key,required this.initialIndex,}) : super(key: key);
  final RxBool isPlay = false.obs;

  @override
  Widget build(BuildContext context) {

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 6.w,
        ),
        StreamBuilder<SequenceState?>(
          stream: player.sequenceStateStream,
          builder: (context, snapshot) => IconButton(
            icon: const Icon(
              Icons.skip_previous,
              size: 35,
            ),
            onPressed: player.hasPrevious ? player.seekToPrevious : null,
          ),
        ),
        SizedBox(
          width: 14.w,
        ),
        StreamBuilder<PlayerState>(
          stream: player.playerStateStream,
          builder: (context, snapshot) {
            final playerState = snapshot.data;
            final processingState = playerState?.processingState;
            final playing = playerState?.playing;
            if (processingState == ProcessingState.loading ||
                processingState == ProcessingState.buffering) {
              return Container(
                margin: const EdgeInsets.all(8.0),
                width: 25.0,
                height: 25.0,
                child:  const CircularProgressIndicator(),
              );
            } else if (playing != true) {
              return Obx(() {
                return Container(
                  height: 60,
                  width: 60,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,),
                  child: IconButton(
                    icon: Icon(isPlay.isFalse ? Icons.play_arrow : Icons.pause),
                    iconSize: 30.0,
                    onPressed: player.play,
                  ),
                );
              });
            } else if (processingState != ProcessingState.completed || isPlay.isTrue) {
              return Container(
                height: 60,
                width: 60,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,),
                child: IconButton(
                  icon: const Icon(Icons.pause),
                  iconSize: 30.0,
                  onPressed: player.pause,
                ),
              );
            } else {
              return Container(
                height: 60,
                width: 60,
                decoration: const BoxDecoration(shape: BoxShape.circle,),
                child: IconButton(
                  icon: const Icon(Icons.replay),
                  iconSize: 30.0,
                  onPressed: () => player.seek(Duration.zero,
                      index: player.effectiveIndices!.first),
                ),
              );
            }
          },
        ),
        SizedBox(
          width: 14.w,
        ),
        StreamBuilder<SequenceState?>(
          stream: player.sequenceStateStream,
          builder: (context, snapshot) => IconButton(
            icon: const Icon(
              Icons.skip_next,
              size: 35,
            ),
            onPressed: player.hasNext ? player.seekToNext : null,
          ),
        ),
      ],
    );
  }
}