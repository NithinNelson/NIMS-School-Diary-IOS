import 'package:educare_dubai_v2/Util/color_util.dart';
import 'package:educare_dubai_v2/Widgets/leave_delete_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../Models/appliedLeaves_model.dart';
import '../Provider/user_provider.dart';
import '../Util/snackBar.dart';
import '../Util/spinkit.dart';
import '../Widgets/leave_float_button.dart';

class AllLeave extends StatefulWidget {
  final String? schoolId;
  final String? studentId;
  final String? academicYr;
  final Function(int) pageUpdate;
  const AllLeave(
      {super.key,
      this.schoolId,
      this.studentId,
      this.academicYr,
      required this.pageUpdate});

  @override
  State<AllLeave> createState() => _AllLeaveState();
}

class _AllLeaveState extends State<AllLeave> with TickerProviderStateMixin {
  AllAppliedLeaves _allLeaves = AllAppliedLeaves();
  List<Details> _leaveList = [];
  bool _loader = false;
  AnimationController? _buttonController;
  Animation<Size>? _heightanimation;
  Animation<Size>? _buttonText;
  final ScrollController _scrollController = ScrollController();
  bool _isButtonExpand = true;

  Future<dynamic> getLeaveData() async {
    setState(() => _loader = true);
    try {
      var resp = await Provider.of<UserProvider>(context, listen: false)
          .getAppliedLeaves(
        schoolId: widget.schoolId.toString(),
        studentId: widget.studentId.toString(),
        academicYr: widget.academicYr.toString(),
      );
      print(resp.runtimeType);
      print('staus code-------------->${resp['status']['code']}');
      if (resp['status']['code'] == 200) {
        _allLeaves = AllAppliedLeaves.fromJson(resp);
        setState(() => _leaveList = _allLeaves.data!.details!);
      }
    } catch (e) {
      showSnackBar(context, "Something went wrong", Colors.red);
      print(e);
    }
    setState(() => _loader = false);
  }

  @override
  void initState() {
    _buttonController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _heightanimation = _buttonController!
        .drive(Tween<Size>(begin: Size(120.w, 50.h), end: Size(60.w, 50.h)));
    _buttonText = _buttonController!
        .drive(Tween<Size>(begin: Size(50.w, 0), end: const Size(0, 0)));
    _heightanimation!.addListener(() => setState(() {}));
    _buttonText!.addListener(() => setState(() {}));
    _scrollController.addListener(() {
      if (0.0 < _scrollController.offset) {
        if (_buttonController!.status != AnimationStatus.forward) {
          setState(() => _isButtonExpand = false);
          _buttonController!.forward();
        }
      } else if (0.0 > _scrollController.offset) {
        if (_buttonController!.status != AnimationStatus.forward) {
          setState(() => _isButtonExpand = true);
          _buttonController!.reverse();
        }
      }
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    getLeaveData();
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant AllLeave oldWidget) {
    getLeaveData();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _buttonController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = 1.sw;
    double height = 1.sh - 150;

    return Stack(
      children: [
        SizedBox(
          width: width,
          height: height,
          child: _loader
              ? ListView.builder(
                  itemCount: 10, itemBuilder: (ctx, _) => skeleton)
              : _leaveList.isEmpty
                  ? Center(child: Text("Empty"))
                  : ListView.builder(
                      controller: _scrollController,
                      padding: EdgeInsets.only(bottom: 120.h),
                      physics: const BouncingScrollPhysics(),
                      itemCount: _leaveList.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            Container(
                              width: width - 20.w,
                              // height: 100,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
                              decoration: BoxDecoration(
                                  color: ColorUtil.white,
                                  borderRadius: BorderRadius.circular(10),
                                  // border: Border.all(color: Colors.grey),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey,
                                        // blurRadius: 10,
                                        offset: Offset(0, 0),
                                        spreadRadius: 2,
                                        blurRadius: 10)
                                  ]),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 5),
                                          decoration: BoxDecoration(
                                              color: _status(""),
                                              borderRadius: BorderRadius.only(
                                                  bottomLeft:
                                                      Radius.circular(10),
                                                  topLeft:
                                                      Radius.circular(10))),
                                          child: Text(
                                            "${_leaveList[index].reason}",
                                            style: TextStyle(
                                                color: _status("white"),
                                                overflow:
                                                    TextOverflow.ellipsis),
                                            maxLines: 1,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                        decoration: BoxDecoration(
                                            color: _status(_leaveList[index]
                                                .status
                                                .toString()),
                                            borderRadius: BorderRadius.only(
                                                bottomRight:
                                                    Radius.circular(10),
                                                topRight: Radius.circular(10))),
                                        child: Text(
                                          "${_leaveList[index].status}",
                                          style: TextStyle(
                                              color: _status("white")),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Reason : ",
                                          style: TextStyle(
                                              color: _status("title"),
                                              fontFamily: "Gotham"),
                                        ),
                                        Expanded(
                                          child: Text(
                                            _leaveList[index].reason.toString(),
                                            style: TextStyle(
                                                fontFamily: "GothamBook"),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    child: Row(
                                      children: [
                                        Text(
                                          "No.of days : ",
                                          style: TextStyle(
                                              color: _status("title"),
                                              fontFamily: "Gotham"),
                                        ),
                                        Text(
                                          _leaveList[index].days.toString(),
                                          style: TextStyle(
                                              fontFamily: "GothamBook"),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    child: Row(
                                      children: [
                                        Text(
                                          "Date : ",
                                          style: TextStyle(
                                              color: _status("title"),
                                              fontFamily: "Gotham"),
                                        ),
                                        Text(
                                          DateFormat("dd/MM/yyyy").format(
                                              DateTime.parse(_leaveList[index]
                                                      .startDate
                                                      .toString())
                                                  .toLocal()),
                                          style: TextStyle(
                                              fontFamily: "GothamBook"),
                                        ),
                                        const SizedBox(
                                          width: 20,
                                          child: Center(
                                            child: Text(
                                              "-",
                                              style: TextStyle(
                                                  fontFamily: "GothamBook"),
                                            ),
                                          ),
                                        ),
                                        Text(
                                          "${DateFormat("dd/MM/yyyy").format(DateTime.parse(_leaveList[index].endDate.toString()).toLocal())}",
                                          style: TextStyle(
                                              fontFamily: "GothamBook"),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    child: Row(
                                      children: [
                                        Text(
                                          "Status : ",
                                          style: TextStyle(
                                              color: _status("title"),
                                              fontFamily: "Gotham"),
                                        ),
                                        Text(
                                          "${_leaveList[index].status}",
                                          style: TextStyle(
                                              color: _status(_leaveList[index]
                                                  .status
                                                  .toString()),
                                              fontFamily: "Gotham"),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(left: 10),
                                        child: Container(
                                          height: 40,
                                          child: Row(
                                            children: [
                                              Text(
                                                "Applied on : ",
                                                style: GoogleFonts.lato(
                                                    fontSize: 12,
                                                    fontStyle:
                                                        FontStyle.italic),
                                              ),
                                              Text(
                                                DateFormat("dd-MM-yyyy").format(
                                                    DateTime.parse(
                                                            _leaveList[index]
                                                                .applyDate
                                                                .toString())
                                                        .toLocal()),
                                                style: GoogleFonts.lato(
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      _leaveList[index].status == "pending"
                                          ? LeaveDeleteButton(
                                              details: _leaveList[index],
                                              reloadData: (bool reload) {
                                                if (reload) {
                                                  getLeaveData();
                                                }
                                              },
                                            )
                                          : Container(),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10)
                          ],
                        );
                      },
                    ),
        ),
        Positioned(
          bottom: 80,
          right: 10,
          child: ApplyLeaveFloatButton(
            pageUpdate: widget.pageUpdate,
            heightanimation: _heightanimation,
            buttonText: _buttonText,
            isButtonExpand: _isButtonExpand,
          ),
        ),
      ],
    );
  }

  Color _status(String status) {
    switch (status) {
      case "Approved":
        return Colors.green;
      case "Rejected":
        return Colors.red;
      case "pending":
        return Colors.blue;
      case "title":
        return Colors.grey.shade700;
      case "white":
        return Colors.white;
      default:
        return Colors.orange.shade600;
    }
  }
}
