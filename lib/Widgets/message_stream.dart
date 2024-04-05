import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:educare_dubai_v2/Widgets/chat_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../Models/chat_message.dart';
import '../Provider/user_provider.dart';
import '../Services/snack_bar.dart';
import 'audio_widget.dart';
import 'message_widget.dart';
import 'otherFiles_widget.dart';

class StreamedMessages extends StatefulWidget {
  final String? classs;
  final String? batch;
  final String? subId;
  final String? parentId;
  final String? teacherId;
  final String? studentId;
  const StreamedMessages(
      {super.key,
      this.classs,
      this.batch,
      this.parentId,
      this.teacherId,
      this.subId,
      this.studentId});

  @override
  State<StreamedMessages> createState() => _StreamedMessagesState();
}

class _StreamedMessagesState extends State<StreamedMessages> {
  final _streamController = StreamController<List<MessageList>?>();
  late Timer _timer;
  ChatMessage _chatMessage = const ChatMessage();
  List<MessageList>? _messageList = [];
  bool _flag = false;
  String _msgSendId = "";

  @override
  void initState() {
    _timer = Timer.periodic(const Duration(seconds: 1), _getMsgList);
    super.initState();
  }

  void _getMsgList(Timer timer) async {
    try {
      var resp =
          await Provider.of<UserProvider>(context, listen: false).getMsgList(
        classs: widget.classs.toString(),
        batch: widget.batch.toString(),
        subId: widget.subId.toString(),
        parentId: widget.parentId.toString(),
        teacherId: widget.teacherId.toString(),
        studentId: widget.studentId.toString(),
      );
      if (resp['status']['code'] == 200) {
        _chatMessage = ChatMessage.fromJson(resp);
        _messageList = _chatMessage.data!.list!;
        _streamController.add(_messageList);
      }
    } catch (e) {}
  }

  Future<dynamic> _deleteMsg({int? msgId, String? parentId}) async {
    try {
      var resp = await Provider.of<UserProvider>(context, listen: false)
          .deleteSenderMsg(msgId: msgId!, parentId: parentId!);
      if (resp['status']['code'] == 200) {
        print("-----resp-----$resp");
        snackBar(context: context, message: resp['data']['message'], color: Colors.green);
      }
    } catch (e) {}
  }

  bool _canChatDelete({DateTime? date, String? id}) {
    DateTime now = DateTime.now();
    DateTime fifteenMinuteAgo = now.subtract(const Duration(minutes: 15));
    if (date!.isAfter(fifteenMinuteAgo) && date.isBefore(now)) {
      setState(() => _flag = true);
      setState(() => _msgSendId = id!);
      return _flag;
    } else {
      return _flag;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() => _flag = false);
      },
      child: StreamBuilder<List<MessageList>?>(
        stream: _streamController.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                physics: const BouncingScrollPhysics(),
                // padding: EdgeInsets.only(bottom: 90.h, top: 20.h),
                reverse: true,
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) => Align(
                      alignment:
                          widget.parentId == snapshot.data![index].mesgFromId
                              ? Alignment.topRight
                              : Alignment.topLeft,
                      child: Stack(
                        children: [
                          GestureDetector(
                            onLongPress: () {
                              _canChatDelete(
                                date: DateTime.parse(
                                    snapshot.data![index].sendAt!),
                                id: snapshot.data![index].mesgId,
                              );
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                // if (widget.subId == "class_group")
                                //   if (widget.parentId !=
                                //       snapshot.data![index].mesgFromId)
                                //     Padding(
                                //       padding: const EdgeInsets.only(left: 5),
                                //       child: Container(
                                //         decoration: BoxDecoration(
                                //             border: Border.all(color: Colors.purple),
                                //             shape: BoxShape.circle,
                                //           color: Colors.white
                                //         ),
                                //         child: ClipRRect(
                                //           borderRadius: BorderRadius.circular(100),
                                //           child: CachedNetworkImage(
                                //             imageUrl: snapshot.data![index].mesgFromName!,
                                //             width: 30,
                                //             height: 30,
                                //             fit: BoxFit.cover,
                                //             placeholder:
                                //                 (context, url) =>
                                //                 Icon(Icons.person),
                                //             errorWidget: (context,
                                //                 url, error) =>
                                //                 Icon(Icons.person),
                                //           ),
                                //         ),
                                //       ),
                                //     ),
                                Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: widget.parentId ==
                                        snapshot.data![index].mesgFromId
                                        ? const BorderRadius.only(
                                      topRight: Radius.circular(20),
                                      bottomLeft: Radius.circular(20),
                                      topLeft: Radius.circular(20),
                                    )
                                        : const BorderRadius.only(
                                      topRight: Radius.circular(20),
                                      bottomRight: Radius.circular(20),
                                      topLeft: Radius.circular(20),
                                    ),
                                  ),
                                  color: widget.parentId ==
                                      snapshot.data![index].mesgFromId
                                      ? const Color.fromRGBO(239, 179, 89, 1.0)
                                      : const Color.fromRGBO(41, 203, 180, 1.0),
                                  margin: const EdgeInsets.only(
                                      top: 10, right: 10, left: 10),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: widget.parentId ==
                                              snapshot.data![index].mesgFromId
                                          ? CrossAxisAlignment.end
                                          : CrossAxisAlignment.start,
                                      children: [
                                        if (widget.subId == "class_group")
                                          if (widget.parentId !=
                                              snapshot.data![index].mesgFromId)
                                            Container(
                                              padding: EdgeInsets.only(
                                                  left: 5, right: 5),
                                              decoration: const BoxDecoration(
                                                  border: Border(
                                                      bottom: BorderSide(
                                                          color: Colors.purple,
                                                          width: 1))),
                                              constraints: const BoxConstraints(
                                                  maxWidth: 200),
                                              child: Text(
                                                snapshot.data![index].mesgFromName
                                                    .toString(),
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  color: Colors.black87,
                                                ),
                                              ),
                                            ),
                                        if (snapshot.data![index].message != null)
                                          Container(
                                            constraints: BoxConstraints(
                                              maxWidth: 230
                                            ),
                                            child: MessageWidget(
                                                content:
                                                    snapshot.data![index].message!),
                                          ),
                                        if (snapshot.data![index].msgAudio !=
                                            null)
                                          AudioWidget(
                                              content: snapshot
                                                  .data![index].msgAudio!),
                                        if (snapshot.data![index].mesgFile != null)
                                          if(_checkImage(snapshot.data![index].mesgFile!.split(".").last))
                                            Column(
                                              crossAxisAlignment: widget.parentId ==
                                                  snapshot.data![index].mesgFromId ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                                              children: [
                                                ImageWidget(
                                                    fileUrl: snapshot.data![index].mesgFile!,
                                                ),
                                                Container(
                                                  constraints: BoxConstraints(
                                                    maxWidth: 230
                                                  ),
                                                  child: Text(
                                                      snapshot.data![index].fileName.toString(),
                                                    style: TextStyle(
                                                      color: Colors.purple,
                                                      fontSize: 12
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                        if (snapshot.data![index].mesgFile !=
                                            null)
                                          if(!_checkImage(snapshot.data![index].mesgFile!.split(".").last))
                                          OtherFiles(
                                              content: snapshot
                                                  .data![index].mesgFile!, fileName: snapshot
                                              .data![index].fileName!,),
                                        const SizedBox(height: 5),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10, right: 10),
                                          child: Text(
                                            timeago.format(DateTime.parse(
                                                snapshot.data![index].sendAt!)),
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (widget.parentId ==
                              snapshot.data![index].mesgFromId)
                            if (_flag &&
                                _msgSendId == snapshot.data![index].mesgId)
                              GestureDetector(
                                onTap: () {
                                  _deleteMsg(
                                      msgId: int.parse(snapshot
                                          .data![index].mesgId
                                          .toString()),
                                      parentId:
                                          snapshot.data![index].mesgFromId);
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: Colors.white,
                                    border: Border.all(color: Colors.purple)
                                  ),
                                  child: const Icon(Icons.delete,
                                      color: Colors.purple),
                                ),
                              ),
                        ],
                      ),
                    ));
          } else if (snapshot.hasError) {
            // Handle errors
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            // Show a loading indicator
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  bool _checkImage(type) {
    if (type == 'jpg' || type == 'jpeg' || type == 'png') {
      return true;
    } else {
      return false;
    }
  }
}
