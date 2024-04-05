class AllAppliedLeaves {
  Status? status;
  Data? data;

  AllAppliedLeaves({this.status, this.data});

  factory AllAppliedLeaves.fromJson(Map<String, dynamic> json) => AllAppliedLeaves(
        data: Data.fromJson(json['data']),
        status: Status.fromJson(json['status']),
      );
}

class Status {
  int? code;
  String? message;

  Status({this.code, this.message});

  factory Status.fromJson(Map<String, dynamic> json) =>
      Status(code: json['code'], message: json['message']);
}

class Data {
  String? message;
  List<Details>? details;

  Data({this.message, this.details});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        message: json['message'],
        details:
            List<Details>.from(json["details"].map((x) => Details.fromJson(x))),
      );
}

class Details {
  String? sId;
  String? updatedOn;
  String? startDate;
  String? endDate;
  String? applyDate;
  String? days;
  String? schoolId;
  String? sessionId;
  String? curriculumId;
  String? classId;
  String? batchId;
  String? academicYear;
  String? reason;
  String? submittedBy;
  String? submittedRoleId;
  String? studentId;
  String? stdClass;
  String? batch;
  String? studentName;
  String? documentPath;
  String? status;
  String? updatedBy;
  String? admissionNumber;
  String? approvedBy;

  Details(
      {this.sId,
      this.updatedOn,
      this.startDate,
      this.endDate,
      this.applyDate,
      this.days,
      this.schoolId,
      this.sessionId,
      this.curriculumId,
      this.classId,
      this.batchId,
      this.academicYear,
      this.reason,
      this.submittedBy,
      this.submittedRoleId,
      this.studentId,
      this.stdClass,
      this.batch,
      this.studentName,
      this.documentPath,
      this.status,
      this.updatedBy,
      this.admissionNumber,
      this.approvedBy});

  factory Details.fromJson(Map<String, dynamic> json) => Details(
      sId: json['_id'],
      updatedOn: json['updated_on'],
      startDate: json['startDate'],
      endDate: json['endDate'],
      applyDate: json['applyDate'],
      days: json['days'],
      schoolId: json['school_id'],
      sessionId: json['session_id'],
      curriculumId: json['curriculum_id'],
      classId: json['class_id'],
      batchId: json['batch_id'],
      academicYear: json['academic_year'],
      reason: json['reason'],
      submittedBy: json['submittedBy'],
      submittedRoleId: json['submittedRoleId'],
      studentId: json['studentId'],
      stdClass: json['class'],
      batch: json['batch'],
      studentName: json['studentName'],
      documentPath: json['documentPath'],
      status: json['status'],
      updatedBy: json['updated_by'],
      admissionNumber: json['admission_number'],
      approvedBy: json['approvedBy']);
}
