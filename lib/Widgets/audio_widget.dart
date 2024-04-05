import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import '../Util/color_util.dart';


class AudioWidget extends StatefulWidget {
  final String content;
  const AudioWidget({super.key, required this.content});

  @override
  State<AudioWidget> createState() => _AudioWidgetState();
}

class _AudioWidgetState extends State<AudioWidget> {
  final player = AudioPlayer();
  Duration _audioPosition = Duration.zero;
  Duration _audioDuration = Duration.zero;
  bool _isPlaying = false;

  @override
  void initState() {
    _initAudioPlayer();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant AudioWidget oldWidget) {
    if (widget.content != oldWidget.content) {
      _audioPosition = Duration.zero;
      _audioDuration = Duration.zero;
    }
    _initAudioPlayer();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  void _initAudioPlayer() async {
    player.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() => _isPlaying = state == PlayerState.playing);
      }
    });

    player.onDurationChanged.listen((Duration duration) {
      if (mounted) {
        setState(() => _audioDuration = duration);
      }
    });

    player.onPositionChanged.listen((Duration duration) {
      if (mounted) {
        setState(() => _audioPosition = duration);
      }
    });

    player.onPlayerComplete.listen((event) {
      if (mounted) {
        setState(() => _audioPosition = Duration.zero);
      }
    });

    await player.setSourceUrl(widget.content);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 5),
      child: Container(
        width: 230,
        height: 70,
        decoration: BoxDecoration(
            color: ColorUtil.white, borderRadius: BorderRadius.circular(15)),
        child: Row(
          children: [
            SizedBox(
              width: 180,
              height: 40,
              child: SliderTheme(
                data: const SliderThemeData(
                  thumbShape: RoundSliderThumbShape(
                    enabledThumbRadius: 8,
                    disabledThumbRadius: 8
                  )
                ),
                child: Slider(
                  min: 0,
                  max: _audioDuration.inSeconds.toDouble(),
                  value: _audioPosition.inSeconds.toDouble(),
                  onChanged: (value) async {
                    final position = Duration(seconds: value.toInt());
                    await player.seek(position);
                    await player.resume();
                  },
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (_audioDuration != Duration.zero)
                  IconButton(
                    onPressed: () => _playAudio(widget.content),
                    icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                  ),
                if (_audioDuration == Duration.zero)
                  Padding(
                    padding: const EdgeInsets.all(13.0),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(),
                    ),
                  ),
                Text(
                  formatDuration(_audioDuration - _audioPosition),
                  style: const TextStyle(fontSize: 10),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> _playAudio(String content) async {
    if (_isPlaying) {
      await player.pause();
    } else {
      await player.play(UrlSource(content));
    }
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String threeDigits(int n) => n.toString().padLeft(3, '0');

    String hours = twoDigits(duration.inHours);
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    String milliseconds = threeDigits(duration.inMilliseconds.remainder(1000));

    if (hours == "00") {
      return '$minutes:$seconds';
    } else {
      return '$hours:$minutes:$seconds';
    }
  }
}
