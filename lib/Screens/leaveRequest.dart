import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:educare_dubai_v2/Util/snackBar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Provider/user_provider.dart';
import '../Util/api_constants.dart';
import '../Util/color_util.dart';

class LeaveRequest extends StatefulWidget {
  final String? imageUrl;
  final String? stdName;
  final String? sessionId;
  final String? sessionName;
  final String? classId;
  final String? className;
  final String? curriculumId;
  final String? curriculumName;
  final String? batchId;
  final String? batchName;
  final String? studentId;
  final String? studentName;
  final String? academicYear;
  final String? schoolId;
  final String? userId;
  final Function(int) pageUpdate;
  const LeaveRequest(
      {super.key,
      this.imageUrl,
      this.stdName,
      this.sessionId,
      this.sessionName,
      this.classId,
      this.className,
      this.curriculumId,
      this.curriculumName,
      this.batchId,
      this.batchName,
      this.studentId,
      this.studentName,
      this.academicYear,
      this.schoolId,
      this.userId,
      required this.pageUpdate});

  @override
  State<LeaveRequest> createState() => _LeaveRequestState();
}

class _LeaveRequestState extends State<LeaveRequest> {
  final DateTime _initialDate = DateTime.now();
  DateTime _fromDate = DateTime.now();
  bool _isKeyboardEnabled = false;
  String _from = "__ /__ /____";
  String _to = "__ /__ /____";
  String _fileName = "";
  String _filePath = "";
  bool _buttonLoader = false;
  final FocusNode _focusNode = FocusNode();
  Timer? _value;
  final TextEditingController _leveReasonController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _saveKeyboard();
  }

  @override
  void didUpdateWidget(covariant LeaveRequest oldWidget) {
    _initData();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _value!.cancel();
    _leveReasonController.dispose();
    super.dispose();
  }

  _initData() {
    _from = "__ /__ /____";
    _to = "__ /__ /____";
    _leveReasonController.text = "";
    _fileName = "";
  }

  _saveKeyboard() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _focusNode.addListener(() async {
      await prefs.setBool("keyboard", true);
    });
    _value = Timer.periodic(
        const Duration(microseconds: 1),
        (_) => View.of(context).viewInsets.bottom != 0.0
            ? setState(() => _isKeyboardEnabled = true)
            : setState(() => _isKeyboardEnabled = false));
  }

  _removeKeyboard() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("keyboard");
  }

  Future<void> _startDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      context: context,
      initialDate: _initialDate,
      firstDate: _initialDate,
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (picked != null && picked != _initialDate) {
      setState(() {
        _from =
            '${picked.day.toString().padLeft(2, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.year}';
        _fromDate = picked;
      });
    }
  }

  Future<void> _endDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      context: context,
      initialDate: _fromDate,
      firstDate: _fromDate,
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (picked != null && picked != _initialDate) {
      setState(() {
        _to =
            '${picked.day.toString().padLeft(2, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.year}';
      });
    }
  }

  Future<dynamic> _selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png', 'docx', 'doc', 'csv'],
    );

    if (result != null) {


      File file = File("${result.files.single.path}");
      setState(() => _fileName = result.files.single.path!.split('/').last);
      // var fileContent = await file.readAsBytes();
      setState(() => _filePath = result.files.single.path!);
      print("-----filepath---------${"${result.files.single.path}"}");
      return _filePath;
    } else {
      return null;
    }
  }

  Future<dynamic> _leaveApplying() async {
    bool haveReason = containsLetters(_leveReasonController.text);
    if (_from != "__ /__ /____" && _to != "__ /__ /____") {
      if (haveReason) {
        try {
          var resp = await Provider.of<UserProvider>(context, listen: false).
          sendLeaveAttachment(baseUrl: "${widget.userId}/leaveDocs/", filePath: _filePath, fileName: _fileName);


          var response = await Provider.of<UserProvider>(context, listen: false)
              .applyForLeave(
                  sessionID: widget.sessionId!,
                  sessionName: widget.sessionName!,
                  curriculumId: widget.curriculumId!,
                  curriculumName: widget.curriculumName!,
                  classId: widget.classId!,
                  className: widget.className!,
                  batchId: widget.batchId!,
                  batchName: widget.batchName!,
                  studentId: widget.studentId!,
                  studentName: widget.studentName!,
                  leaveReason: _leveReasonController.text,
                  academicYr: widget.academicYear!,
                  startDate: _from,
                  endDate: _to,
                  schoolId: widget.schoolId!,
                  userId: widget.userId!,
                  docPath: resp ?? "");
          print(response);
          print('staus code-------------->${response['data']['message']}');
          if (response['status']['code'] == 200) {
            String message = response['data']['message'];
            if(response['data']['status'] == 'success') {
              showSnackBar(context, message, Colors.green);
            } else{
              showSnackBar(context, message, Colors.red);
            }
            _initData();
          } else {
            String message = "Server Issue";
            showSnackBar(context, message, Colors.red);
          }
        } catch (e) {
          print(e);
        }
      } else {
        showSnackBar(context, "Please specify reason", Colors.red);
      }
    } else {
      showSnackBar(context, "Please select dates", Colors.red);
    }
  }

  bool containsLetters(String input) {
    RegExp regex = RegExp(r'[a-zA-Z]');
    return regex.hasMatch(input);
  }

  @override
  Widget build(BuildContext context) {
    double width = 1.sw;
    double height = 1.sh - 100;

    return GestureDetector(
      onTap: () => _focusNode.unfocus(),
      child: SizedBox(
        width: width,
        height: height,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Container(
                height: 100.h,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(width: 10),
                          Container(
                            height: 40,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.deepPurple.shade50),
                            child: TextButton(
                              onPressed: () => widget.pageUpdate(14),
                              style: TextButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10))),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.history,
                                    size: 20,
                                  ),
                                  SizedBox(width: 10),
                                  Text("View All"),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30)
                  ],
                ),
              ),
              CircleAvatar(
                radius: 50,
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(60)),
                  child: CachedNetworkImage(
                    imageUrl: '${ApiConstants.downloadUrl}${widget.imageUrl}',
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Image.asset(
                      'assets/images/userImage.png',
                      width: 50,
                      height: 50,
                    ),
                    errorWidget: (context, url, error) => Image.asset(
                      'assets/images/userImage.png',
                      width: 50,
                      height: 50,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                "${widget.stdName}",
                style: const TextStyle(fontFamily: 'Gotham'),
              ),
              SizedBox(height: 40.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "From : ",
                    style: TextStyle(fontSize: 16, fontFamily: 'GothamBook'),
                  ),
                  Container(
                    height: 40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.deepPurple.shade50),
                    child: TextButton(
                      onPressed: () => _startDate(context),
                      style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      child: Text(_from),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    "To : ",
                    style: TextStyle(fontSize: 16, fontFamily: 'GothamBook'),
                  ),
                  Container(
                    height: 40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.deepPurple.shade50),
                    child: TextButton(
                      onPressed: () => _endDate(context),
                      style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      child: Text(_to),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30.h),
              SizedBox(
                width: width - 30,
                child: TextField(
                  controller: _leveReasonController,
                  maxLines: 3,
                  cursorColor: Colors.grey,
                  focusNode: _focusNode,
                  autofocus: false,
                  style: const TextStyle(
                    fontSize: 15,
                    fontFamily: 'EducareIcons',
                  ),
                  decoration: InputDecoration(
                      hintText: "Reason",
                      fillColor: Colors.deepPurple.shade50,
                      filled: true,
                      hintStyle: const TextStyle(
                        fontFamily: 'EducareIcons',
                        fontSize: 15,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      suffixIcon: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Material(
                            color: Colors.white,
                            child: InkWell(
                              splashColor: Colors.deepPurple.shade300,
                              onTap: () => _selectFile(),
                              child: const RotatedBox(
                                quarterTurns: 5,
                                child: Icon(Icons.attach_file,
                                    color: Colors.purple),
                              ),
                            ),
                          ),
                        ),
                      ),
                      suffixIconConstraints:
                          BoxConstraints(minWidth: 70, minHeight: 70)),
                ),
              ),
              if (_fileName != "")
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: Row(
                    children: [
                      Container(
                        constraints: BoxConstraints(
                          maxWidth: width - 80.h,
                        ),
                        child: Text(
                          _fileName,
                          style: const TextStyle(
                              fontFamily: 'GothamBook', fontSize: 13),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        onPressed: () => setState(() => _fileName = ""),
                        icon: const Icon(Icons.close),
                      )
                    ],
                  ),
                ),
              SizedBox(height: 40.h),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Material(
                  child: InkWell(
                    onTap: () async {
                      setState(() {
                        _buttonLoader = true;
                      });
                      await _leaveApplying();
                      setState(() {
                        _buttonLoader = false;
                      });
                    },
                    splashColor: Colors.deepPurple.shade300,
                    child: Ink(
                      width: width - 100,
                      height: 40.h,
                      decoration: BoxDecoration(
                          color: Colors.deepPurple,
                          borderRadius: BorderRadius.circular(20)),
                      child: Center(
                        child: _buttonLoader
                            ? SizedBox(
                                width: 10,
                                height: 10,
                                child: CircularProgressIndicator(
                                  color: ColorUtil.white,
                                ))
                            : Text(
                                "Submit",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontFamily: 'Gotham'),
                              ),
                      ),
                    ),
                  ),
                ),
              ),
              if(_isKeyboardEnabled)
                SizedBox(height: 250.h),
            ],
          ),
        ),
      ),
    );
  }
}
