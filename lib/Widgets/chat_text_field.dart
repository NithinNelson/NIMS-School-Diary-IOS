import 'package:educare_dubai_v2/Models/message_model.dart';
import 'package:educare_dubai_v2/Provider/chat_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'chat_audioPlaying_widget.dart';
import 'chat_audioRecording_widget.dart';
import 'chat_textField_widget.dart';

class ChatTextField extends StatefulWidget {
  final String? classs;
  final String? batch;
  final String? parentId;
  final String? studentId;
  final String? studentName;
  final String? teacherId;
  final String? subId;
  final String? sub;
  const ChatTextField({super.key, this.classs, this.batch, this.parentId, this.teacherId, this.subId, this.sub, this.studentId, this.studentName});

  @override
  State<ChatTextField> createState() => _ChatTextFieldState();
}

class _ChatTextFieldState extends State<ChatTextField> {
  ChatField? field;

  @override
  void initState() {
    field = ChatField.textField;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    setState(() => field = context.watch<ChatProvider>().field);
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant ChatTextField oldWidget) {
    setState(() => field = context.watch<ChatProvider>().field);
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: chatWidget(),
    );
  }

  Widget chatWidget() {
    switch (field) {
      case ChatField.textField:
        return ChatTextFieldWidget(
          classs: widget.classs,
          batch: widget.batch,
          parentId: widget.parentId,
          sub: widget.sub,
          subId: widget.subId,
          teacherId: widget.teacherId,
          studentId: widget.studentId,
          studentName: widget.studentName,
        );
      case ChatField.audioRecording:
        return const ChatAudioRecordingWidget();
      // case ChatField.audioPlaying:
      //   return ChatAudioPlayingWidget(
      //     classs: widget.classs,
      //     batch: widget.batch,
      //     parentId: widget.parentId,
      //     sub: widget.sub,
      //     subId: widget.subId,
      //     teacherId: widget.teacherId,
      //     studentId: widget.studentId,
      //     studentName: widget.studentName,
      //   );
      default:
        return Container();
    }
  }
}
