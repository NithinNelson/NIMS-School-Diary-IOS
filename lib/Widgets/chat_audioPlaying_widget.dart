
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Provider/chat_provider.dart';

class ChatAudioPlayingWidget extends StatefulWidget {
  final Function(bool) removeAudioPath;
  const ChatAudioPlayingWidget({
    super.key,
    required this.removeAudioPath,
  });

  @override
  State<ChatAudioPlayingWidget> createState() => _ChatAudioPlayingWidgetState();
}

class _ChatAudioPlayingWidgetState extends State<ChatAudioPlayingWidget> {
  final player = AudioPlayer();
  Duration _audioPosition = Duration.zero;
  Duration _audioDuration = Duration.zero;
  bool _isPlaying = false;
  String? _audioPath;
  String userId = "";
  String schoolId = "";

  @override
  void initState() {
    _initialize();
    _initAudioPlayer();
    super.initState();
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  _initialize() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var school_Id = preferences.getString('school_id');
    var fromId = preferences.getString('userID');
    setState(() => userId = fromId!);
    setState(() => schoolId = school_Id!);
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

    // player.onPlayerComplete.listen((event) {
    //   if (mounted) {
    //     setState(() => _audioPosition = Duration.zero);
    //   }
    // });

    _audioPath = Provider.of<ChatProvider>(context, listen: false).audioPath;
    await player.setSourceDeviceFile(_audioPath!);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
                side: BorderSide(color: Colors.grey.shade300),
              ),
              child: SizedBox(
                height: 50.h,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: 25,
                        child: IconButton(
                          onPressed: () {
                            Provider.of<ChatProvider>(context, listen: false).setAudioPath(path: null);
                            widget.removeAudioPath(true);
                          },
                          icon: const Icon(Icons.delete, color: Colors.red,),
                        ),
                      ),
                      Expanded(
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
                      Text(
                        formatDuration(_audioDuration - _audioPosition),
                        style: const TextStyle(fontSize: 10),
                      ),
                      IconButton(
                        onPressed: () => _playAudio(_audioPath!),
                        icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _playAudio(String content) async {
    if (_isPlaying) {
      await player.pause();
    } else {
      await player.play(DeviceFileSource(_audioPath!));
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
