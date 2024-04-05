import 'package:flutter/material.dart';
import '../Models/chat_message.dart';
import '../Models/message_model.dart';

class ChatProvider extends ChangeNotifier {
  // List<Message> _mesg = [];
  ChatField _field = ChatField.textField;
  String? _audioPath;
  String? _filePath;
  List<MessageList> _messageList = [];

  // List<Message> get msg => _mesg;
  ChatField get field => _field;
  String? get audioPath => _audioPath;
  String? get filePath => _filePath;
  List<MessageList>? get messageList => _messageList;

  void addMsg(MessageList msg) {
    _messageList.add(msg);

    notifyListeners();
  }

  void chatField(ChatField type) {
    _field = type;

    notifyListeners();
  }

  void setAudioPath({String? path}) {
    _audioPath = path;

    notifyListeners();
  }

  void setFilePath({String? path}) {
    _filePath = path;

    notifyListeners();
  }
}