import 'dart:async';
import 'dart:io';
import 'package:educare_dubai_v2/Models/chat_message.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../Models/chat_rooms.dart';
import '../../Models/message_model.dart';
import '../../Provider/chat_provider.dart';
import '../../Services/check_connectivity.dart';
import '../../Services/snack_bar.dart';
import '../../Widgets/chat_text_field.dart';
import '../../Widgets/message_stream.dart';

class ChattingPage extends StatefulWidget {
  final String? studentId;
  final String? studentName;
  final String? parentId;
  final RoomList room;
  const ChattingPage(
      {super.key,
      this.studentId,
      this.parentId,
        this.studentName,
        required this.room});

  @override
  State<ChattingPage> createState() => _ChattingPageState();
}

class _ChattingPageState extends State<ChattingPage>
    with SingleTickerProviderStateMixin {
  final _streamController = StreamController<List<MessageList>?>();
  File? wallpaper;
  RoomList? room;
  @override
  void initState() {
    _getWallpaper();
    _initialize();
    super.initState();
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  _initialize() async {
    room = widget.room;
    final provider = Provider.of<ChatProvider>(context, listen: false);
    provider.chatField(ChatField.textField);
    provider.setFilePath(path: null);
    provider.setAudioPath(path: null);
    bool connection = await CheckConnectivity().check();
    if (!connection) {
      snackBar(context: context, message: "No Internet Connection.", color: Colors.red);
    }
  }

  _pickWallpaper() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png'],
    );

    if (result != null) {
      await prefs.setString("wallpaper", "${result.files.single.path}");
      setState(() => wallpaper = File("${result.files.single.path}"));
    }
  }

  _deleteWallpaper() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('wallpaper');
    setState(() => wallpaper = null);
  }

  _getWallpaper() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? image = prefs.getString("wallpaper");
    if (image != null) {
      File file = File(image);
      if (file.existsSync()) {
        setState(() => wallpaper = File(image));
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text("${room!.teacherName}"),
        centerTitle: true,
        elevation: 1,
        flexibleSpace: ClipRRect(
          child: Image.asset(
            "assets/images/appbar.png",
            fit: BoxFit.cover,
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            elevation: 1,
            position: PopupMenuPosition.under,
            onSelected: (String choice) {
              // Handle menu item selection here
              if (choice == 'Option 1') {
                // Handle Option 1
                _pickWallpaper();
              }
              if (choice == 'Option 2') {
                // Handle Option 1
                _deleteWallpaper();
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<String>(
                  value: 'Option 1',
                  child: Text(
                    'Wallpaper',
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'Option 2',
                  child: Text(
                    'Default Wallpaper',
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: Container(
        height: 1.sh,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            wallpaper != null
                ? Image.file(
                    wallpaper!,
                    fit: BoxFit.cover,
                    width: _width,
                    height: _height,
                  )
                : Image.asset(
                    "assets/images/splash_bg.png",
                    fit: BoxFit.cover,
                    width: _width,
                    height: _height,
                  ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: StreamedMessages(
                    parentId: widget.parentId,
                    subId: room!.subjectId,
                    batch: room!.batch,
                    classs: room!.classs,
                    teacherId: room!.teacherId,
                    studentId: widget.studentId,
                  ),
                ),
                ChatTextField(
                  teacherId: room!.teacherId,
                  subId: room!.subjectId,
                  sub: room!.subject,
                  parentId: widget.parentId,
                  batch: room!.batch,
                  classs: room!.classs,
                  studentId: widget.studentId,
                  studentName: widget.studentName,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
