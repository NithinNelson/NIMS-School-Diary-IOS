class AFLModel {
  AFLModel({this.status, this.data});

  Status? status;
  Data? data;

  factory AFLModel.fromJson(Map<String, dynamic> json) => AFLModel(
    status: Status.fromJson(json['status']),
    data: Data.fromJson(json['data'])
  );
}

class Data {
  Data({this.message, this.details});

  String? message;
  Details? details;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    message: json['message'],
    details: Details.fromJson(json['details']['response'])
  );
}

class Details {
  Details({
    this.studentAverageHighest,
    this.studentAndBatcAvgPerTheme,
    this.tmElapsed,
    this.allMCQ,
    this.typePie,
    this.stdScore
  });

  List<StudentData>? studentAverageHighest;
  List<StudentMark>? studentAndBatcAvgPerTheme;
  List<TMElapsed>? tmElapsed;
  List<getAllMCQ>? allMCQ;
  StdScore? stdScore;
  List<StudentData>? typePie;

  factory Details.fromJson(Map<String, dynamic> json) => Details(
    studentAverageHighest: List<StudentData>.from(json['studentAverageHighest'].map((x) => StudentData.fromJson(x)).toList()),
    studentAndBatcAvgPerTheme: List<StudentMark>.from(json['studentAndBatcAvgPerTheme'].map((x) => StudentMark.fromJson(x)).toList()),
    tmElapsed: List<TMElapsed>.from(json['tm_elapsed'].map((x) => TMElapsed.fromJson(x)).toList()),
    allMCQ: List<getAllMCQ>.from(json['getAllstudentMCQ'].map((x) => getAllMCQ.fromJson(x))),
    stdScore: StdScore.fromJson(json['studentScore']),
    typePie: List<StudentData>.from(json['type_pie'].map((x) => StudentData.fromJson(x)).toList())
  );
}

class StudentData {
  StudentData({this.element, this.score, this.style});

  String? element;
  dynamic score;
  dynamic style;

  factory StudentData.fromJson(List<dynamic> json) => StudentData(
    element: json[0] as String,
    score: json[1],
    style: json[2]
  );
}

class StudentMark {
  StudentMark({this.topic, this.stdAvg, this.classAvg});

  String? topic;
  dynamic stdAvg;
  dynamic classAvg;

  factory StudentMark.fromJson(List<dynamic> json) => StudentMark(
      topic: json[0] as String,
      stdAvg: json[1],
      classAvg: json[2]
  );
}

class TMElapsed {
  TMElapsed({this.question, this.totalTm, this.color, this.avgTm});

  String? question;
  dynamic totalTm;
  String? color;
  dynamic avgTm;

  factory TMElapsed.fromJson(List<dynamic> json) => TMElapsed(
      question: json[0] as String,
      totalTm: json[1],
      color: json[2].toString(),
      avgTm: json[3]
  );
}

class getAllMCQ {
  getAllMCQ({
    this.question,
    this.type,
    this.rightAnswer,
    this.sudentRes,
    this.correctAns,
    this.stdScorePers,
    this.questMark,
    this.actualScore,
    this.classPers
  });
  String? question;
  String? type;
  RightAns? rightAnswer;
  StdResp? sudentRes;
  CorrectAns? correctAns;
  StdScorePers? stdScorePers;
  int? questMark;
  String? actualScore;
  ClassPers? classPers;

  factory getAllMCQ.fromJson(Map<String, dynamic> json) => getAllMCQ(
    question: json['question'],
    type: json['type'],
    rightAnswer: RightAns.fromJson(json['right_answer']),
    sudentRes: StdResp.fromJson(json['student_response']),
    correctAns: CorrectAns.fromJson(json['correct_answer']),
    stdScorePers: StdScorePers.fromJson(json['student_score_percent']),
    questMark: json['question_mark'],
    actualScore: json['actual_score'],
    classPers: ClassPers.fromJson(json['class_percent'])
  );
}

class RightAns {
  RightAns({this.tag});
  String? tag;

  factory RightAns.fromJson(Map<String, dynamic> json) => RightAns(
    tag: json['tag']
  );
}

class StdResp {
  StdResp({this.score});
  String? score;

  factory StdResp.fromJson(Map<String, dynamic> json) => StdResp(
      score: json['score']
  );
}

class CorrectAns {
  CorrectAns({this.flag});
  bool? flag;

  factory CorrectAns.fromJson(Map<String, dynamic> json) => CorrectAns(
      flag: json['flag']
  );
}

class StdScorePers {
  StdScorePers({
    this.score,
    this.style,
  });

  int? score;
  Style? style;

  factory StdScorePers.fromJson(Map<String, dynamic> json) => StdScorePers(
      score: json['score'],
      style: Style.fromJson(json['style'])
  );
}

class ClassPers {
  ClassPers({this.score, this.style});

  String? score;
  Style? style;

  factory ClassPers.fromJson(Map<String, dynamic> json) => ClassPers(
      score: json['score'],
      style: Style.fromJson(json['style'])
  );
}

class Style {
  Style({this.background});
  String? background;

  factory Style.fromJson(Map<String, dynamic> json) => Style(
      background: json['background']
  );
}

class StdScore {
  StdScore({this.comment});
  String? comment;

  factory StdScore.fromJson(Map<String, dynamic> json) => StdScore(
    comment: json['comment'] ?? ""
  );
}

class Status {
  Status({this.code, this.message});

  int? code;
  String? message;

  factory Status.fromJson(Map<String, dynamic> json) => Status(
    code: json['code'],
    message: json['message']
  );
}
