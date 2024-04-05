class MessageCount {
  MessageCount({this.status, this.data});

  Status? status;
  Data? data;

  factory MessageCount.fromJson(Map<String, dynamic> json) => MessageCount(
        status: Status.fromJson(json['status']),
        data: Data.fromJson(json['data']),
      );
}

class Status {
  Status({this.code, this.message});

  int? code;
  String? message;

  factory Status.fromJson(Map<String, dynamic> json) => Status(
        code: json['code'],
        message: json['message'],
      );
}

class Data {
  Data({this.message, this.count});

  String? message;
  List<CountList>? count;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        message: json['message'],
        count: List<CountList>.from(json['count'].map((x) => CountList.fromJson(x))),
      );
}

class CountList {
  CountList({this.studentId, this.unreadCount});

  String? studentId;
  int? unreadCount;

  factory CountList.fromJson(Map<String, dynamic> json) => CountList(
        studentId: json['student_id'],
        unreadCount: json['unread_count'],
      );
}
