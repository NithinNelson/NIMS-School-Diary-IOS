
class ChatRoomModel {
  final Status? status;
  final Data? data;

  const ChatRoomModel({this.status, this.data});

  factory ChatRoomModel.fromJson(Map<String, dynamic> json) => ChatRoomModel(
    status: Status.fromJson(json['status']),
    data: Data.fromJson(json['data']),
  );
}

class Data {
  final String? message;
  final List<RoomList>? list;

  const Data({this.message, this.list});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    message: json['message'],
    list: List<RoomList>.from(json['chat_rooms'].map((x) => RoomList.fromJson(x)))
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

// class ChatRooms {
//   final List<RoomList>? list;
//
//   const ChatRooms({this.list});
//
//   factory ChatRooms.fromJson(Map<String, dynamic> json) => ChatRooms(
//     list: List<RoomList>.from(json['chat_rooms'].map((x) => RoomList.fromJson(x))),
//   );
// }

class RoomList {
  final String? classs;
  final String? batch;
  final String? subjectId;
  final String? subject;
  final String? teacherName;
  final String? teacherId;
  final String? teacherEmail;
  final String? teacherImage;
  final int? unreadCount;

  const RoomList({
    this.classs,
    this.batch,
    this.subjectId,
    this.subject,
    this.teacherName,
    this.teacherId,
    this.teacherEmail,
    this.teacherImage,
    this.unreadCount
  });

  factory RoomList.fromJson(Map<String, dynamic> json) => RoomList(
    classs: json['class'],
    batch: json['batch'],
    subjectId: json['subject_id'],
    subject: json['subject'],
    teacherName: json['teacher_name'],
    teacherId: json['teacher_id'],
    teacherEmail: json['teacher_email'],
    teacherImage: json['teacher_image'],
    unreadCount: json['unread_count']
  );
}