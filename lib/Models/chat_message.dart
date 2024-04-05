

class ChatMessage {
  final Status? status;
  final Data? data;

  const ChatMessage({this.status, this.data});
  
  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
    status: Status.fromJson(json['status']),
    data: Data.fromJson(json['data']),
  );
}

class Status {
  final int? code;
  final String? message;

  const Status({this.code, this.message});

  factory Status.fromJson(Map<String, dynamic> json) => Status(
    code: json['code'],
    message: json['message']
  );
}

class Data {
  final String? message;
  final int? count;
  final List<MessageList>? list;

  const Data({this.message, this.count, this.list});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    message: json['message'],
    count: json['count'],
    list: List<MessageList>.from(json['data'].map((x) => MessageList.fromJson(x)))
  );
}

class MessageList {
  final String? mesgId;
  final String? message;
  final String? mesgFile;
  final String? msgAudio;
  final String? fileName;
  final String? mesgFromId;
  final String? mesgFromName;
  final String? sendAt;

  const MessageList({
    this.message,
    this.mesgFile,
    this.msgAudio,
    this.fileName,
    this.mesgFromId,
    this.mesgFromName,
    this.sendAt,
    this.mesgId,
  });

  factory MessageList.fromJson(Map<String, dynamic> json) => MessageList(
    mesgId: json['message_id'],
    message: json['message'],
    mesgFile: json['message_file'],
    msgAudio: json['message_audio'],
    fileName: json['file_name'],
    mesgFromId: json['message_from_id'],
    mesgFromName: json['message_from'],
    sendAt: json['sand_at']
  );
}