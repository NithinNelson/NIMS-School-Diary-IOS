import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../Screens/AFL_Screen.dart';
import '../Screens/home_screen.dart';
import '../Util/color_util.dart';

class ExamWidget extends StatefulWidget {
  final String? studId;
  final String? schlId;
  final String? qpId;
  final String? date;
  final String? subName;
  final String? activityName;
  final List<dynamic>? themes;
  final String? markObt;
  final String? maxMark;
  final Color? color;
  final Function? aflOn;
  const ExamWidget(
      {Key? key,
        this.aflOn,
        this.color,
        this.date,
        this.maxMark,
        this.activityName,
        this.markObt,
        this.subName,
        this.themes,
        this.studId,
        this.qpId,
        this.schlId})
      : super(key: key);

  @override
  State<ExamWidget> createState() => _ExamWidgetState();
}

class _ExamWidgetState extends State<ExamWidget> with SingleTickerProviderStateMixin {
  var _isExpanded = false;
  AnimationController? _controller;
  Animation<Size>? _heightanimation;
  Animation<Size>? _markanim;
  double _fontSize = 0.0;

  void _animateFontSize() {
    setState(() {
      _fontSize = _fontSize == 0.0 ? 18.sp : 0.0;
    });
  }

  _setAnimation() {
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _heightanimation = _controller!.drive(
        Tween<Size>(
            begin: Size(double.infinity, (140+widget.themes!.length * 15)),end: Size(double.infinity, 190+(widget.themes!.length * 30))
        ));
    _markanim = _controller!.drive(
        Tween<Size>(
            begin: const Size(0, 0),end: Size(60, 1.sw - 150)
        ));
    _heightanimation!.addListener(()=>setState(() {

    }));
    _markanim!.addListener(()=>setState(() {

    }));
  }

  @override
  void initState() {
    _setAnimation();
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded;
        });
        if(_isExpanded){
          _controller!.forward();
        }else{
          _controller!.reverse();
        }
        _animateFontSize();
      },
      child: Container(
        width: 1.sw,
        // height: _heightanimation!.value.height,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),

        //color: Colors.red,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 80,
              height: (142 + widget.themes!.length * 15),
              margin: EdgeInsets.symmetric(horizontal: 10),
              // color: Colors.green,
              decoration: BoxDecoration(
                  color: widget.color, borderRadius: BorderRadius.circular(20)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                      child: Text(
                        '${DateFormat('dd MMM').format(DateTime.parse(widget.date!.split(' ')[0])).split(' ')[0]}',
                        textScaleFactor: 1.0,
                        style: TextStyle(
                            color: ColorUtil.white,
                            fontWeight: FontWeight.w700,
                            fontFamily: "Montserrat",
                            //fontStyle:  FontStyle.normal,
                            fontSize: 20.sp),
                      )),
                  Center(
                      child: Text(
                        '${DateFormat('dd MMM').format(DateTime.parse(widget.date!.split(' ')[0])).split(' ')[1].toUpperCase()}',
                        textScaleFactor: 1.0,
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          color: ColorUtil.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          letterSpacing: 0,
                        ),
                      )),
                  Center(child: Text('${DateFormat('dd MMM yyyy').format(DateTime.parse(widget.date!.split(' ')[0])).split(' ')[2].toUpperCase()}', textScaleFactor:1.0,style: TextStyle(
                    fontFamily: 'Montserrat',
                    color: ColorUtil.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    letterSpacing: 0,
                  ),)),
                ],
              ),
            ),
            Column(
              children: [
                Container(
                  width: 1.sw - 130,
                  //height: 140,
                  height: _heightanimation!.value.height ,
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),

                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(
                            color: const Color(0x24161616),
                            offset: Offset(0, 7),
                            blurRadius: 24,
                            spreadRadius: 0)
                      ],
                      color: Colors.white),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 100.w,
                              child: Text(
                                widget.subName!,
                                textScaleFactor: 1.0,
                                maxLines: 2,
                                style: TextStyle(
                                    color: widget.color,
                                    overflow: TextOverflow.ellipsis,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: "OpenSans",
                                    fontStyle: FontStyle.normal,
                                    fontSize: 15.sp),
                              ),
                            ),
                            (widget.markObt.toString() == 'null')
                                ? Row(
                              children: [
                                Container(
                                  // width: 80,
                                  height: 20,
                                  padding: const EdgeInsets.symmetric(horizontal: 15),
                                  decoration: BoxDecoration(
                                      color: ColorUtil.circularRed,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Center(
                                    child: Text(
                                      'Absent',
                                      textScaleFactor: 1.0,
                                      style: TextStyle(
                                        fontFamily: 'Axiforma',
                                        color: Colors.white,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w400,
                                        //fontStyle: FontStyle.normal,
                                        letterSpacing: 0,
                                      ),
                                    ),
                                  ),
                                ),
                                _isExpanded? Icon(Icons.arrow_drop_up):Icon(Icons.arrow_drop_down)
                              ],
                            )
                                : GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (ctx) => AFLReport(
                                          qpId: widget.qpId,
                                          studId: widget.studId,
                                          schlId: widget.schlId,
                                          nos: widget.maxMark,
                                          score: widget.markObt,
                                        )));
                              },
                              child: Row(
                                children: [
                                  Container(
                                    width: 65,
                                    height: 20,
                                    decoration: BoxDecoration(
                                        color: ColorUtil.subBlue,
                                        borderRadius:
                                        BorderRadius.circular(20)),
                                    child: Center(
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                          children: [
                                            Icon(
                                              Icons.remove_red_eye_outlined,
                                              size: 14,
                                              color: ColorUtil.white,
                                            ),
                                            Text(
                                              'View',
                                              textScaleFactor: 1.0,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w400,
                                                  fontFamily: "OpenSans",
                                                  fontStyle: FontStyle.normal,
                                                  fontSize: 13.sp),
                                            ),
                                          ],
                                        )),
                                  ),
                                  _isExpanded
                                      ? Icon(Icons.arrow_drop_up)
                                      : Icon(Icons.arrow_drop_down)
                                ],
                              ),
                            ),
                          ],
                        ),
                        Divider(),
                        AnimatedCrossFade(
                          duration: const Duration(milliseconds: 300),
                          crossFadeState: _isExpanded
                              ? CrossFadeState.showFirst
                              : CrossFadeState.showSecond,
                          firstChild: Column(
                            // mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.activityName!,textScaleFactor: 1.0,),
                              // (_heightanimation!.value.height == 190+(widget.themes!.length * 30)) ? Divider() : SizedBox(),
                              Divider(),
                              // (_heightanimation!.value.height == 190+(widget.themes!.length * 25)) ? Divider() : SizedBox(),
                              Container(
                                width: 1.sw,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: _markanim!.value.height,
                                      height: _markanim!.value.width,
                                      // color: ,
                                      decoration: BoxDecoration(
                                          color: (widget.markObt.toString() == 'null')? ColorUtil.absentIndiColor: ColorUtil.green,
                                          borderRadius: BorderRadius.all(Radius.circular(15))
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          AnimatedDefaultTextStyle(
                                            style: TextStyle(
                                              fontSize: _fontSize,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700,
                                              fontFamily: "Axiforma",
                                              fontStyle: FontStyle.normal,
                                            ),
                                            duration: const Duration(milliseconds: 300),
                                            child: Text(
                                              (widget.markObt.toString() == 'null')
                                                  ? 'NA'
                                                  : '${widget.markObt!}',
                                              textScaleFactor: 1.0,
                                              // style: TextStyle(
                                              //     color: Colors.white,
                                              //     fontWeight: FontWeight.w700,
                                              //     fontFamily: "Axiforma",
                                              //     fontStyle: FontStyle.normal,
                                              //     fontSize: 18.sp),
                                            ),
                                          ),
                                          AnimatedDefaultTextStyle(
                                            style: TextStyle(
                                              fontSize: _fontSize,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700,
                                              fontFamily: "Axiforma",
                                              fontStyle: FontStyle.normal,
                                            ),
                                            duration: const Duration(milliseconds: 300),
                                            child: Text(
                                              '/',
                                              // style: TextStyle(
                                              //     color: Colors.white,
                                              //     fontWeight: FontWeight.w700,
                                              //     fontFamily: "Axiforma",
                                              //     fontStyle: FontStyle.normal,
                                              //     fontSize: 18.sp),
                                            ),
                                          ),
                                          AnimatedDefaultTextStyle(
                                            style: TextStyle(
                                              fontSize: _fontSize,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700,
                                              fontFamily: "Axiforma",
                                              fontStyle: FontStyle.normal,
                                            ),
                                            duration: const Duration(milliseconds: 300),
                                            child: Text(
                                              widget.maxMark!,
                                              textScaleFactor: 1.0,

                                              // style: TextStyle(
                                              //     color: Colors.white,
                                              //     fontWeight: FontWeight.w700,
                                              //     fontFamily: "Axiforma",
                                              //     fontStyle: FontStyle.normal,
                                              //     fontSize: 18.sp),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              (_heightanimation!.value.height == 190+(widget.themes!.length * 30))
                                  ? Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Topic',
                                    textScaleFactor: 1.0,
                                    style: TextStyle(
                                        color: const Color(0xff4b4b4b),
                                        fontWeight: FontWeight.w600,
                                        fontFamily: "OpenSans",
                                        fontStyle: FontStyle.normal,
                                        fontSize: 15.sp),
                                  ),
                                  Column(
                                    children: [
                                      ...widget.themes!
                                          .map((e) =>
                                          Container(width: 150, child: Text(e,textScaleFactor: 1.0,)))
                                          .toList(),
                                    ],
                                  )

                                ],
                              )
                                  : SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                          secondChild: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                width: 1.sw - 220,
                                  // color: Colors.green,
                                  child: Text(
                                    widget.activityName!,
                                    textScaleFactor: 1.0,
                                  ),
                              ),
                              Container(
                                width: 60,
                                height: 60,
                                // color: Colors.red,
                                decoration: BoxDecoration(
                                    color: (widget.markObt.toString() == 'null')? ColorUtil.absentIndiColor: ColorUtil.green,
                                    borderRadius: BorderRadius.all(Radius.circular(15))
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      (widget.markObt.toString() == 'null')
                                          ? 'NA'
                                          : '${widget.markObt!}',
                                      textScaleFactor: 1.0,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontFamily: "Axiforma",
                                          fontStyle: FontStyle.normal,
                                          fontSize: 15.sp),
                                    ),
                                    Text(
                                      '/',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontFamily: "Axiforma",
                                          fontStyle: FontStyle.normal,
                                          fontSize: 15.sp),
                                    ),
                                    Text(
                                      widget.maxMark!,
                                      textScaleFactor: 1.0,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontFamily: "Axiforma",
                                          fontStyle: FontStyle.normal,
                                          fontSize: 15.sp),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        // if (!_isExpanded)
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        //   children: [
                        //     Text(widget.activityName!,textScaleFactor: 1.0,),
                        //     Container(
                        //       width: 60,
                        //       height: 60,
                        //       // color: ,
                        //       decoration: BoxDecoration(
                        //           color: (widget.markObt.toString() == 'null')? ColorUtil.absentIndiColor: ColorUtil.green,
                        //           borderRadius: BorderRadius.all(Radius.circular(15))
                        //       ),
                        //       child: Row(
                        //         mainAxisAlignment:
                        //         MainAxisAlignment.center,
                        //         children: [
                        //           Text(
                        //             (widget.markObt.toString() == 'null')
                        //                 ? 'NA'
                        //                 : '${widget.markObt!}',
                        //             textScaleFactor: 1.0,
                        //             style: TextStyle(
                        //                 color: Colors.white,
                        //                 fontWeight: FontWeight.w700,
                        //                 fontFamily: "Axiforma",
                        //                 fontStyle: FontStyle.normal,
                        //                 fontSize: 18.sp),
                        //           ),
                        //           Text(
                        //             '/',
                        //             style: TextStyle(fontSize: 18.sp),
                        //           ),
                        //           Center(child: Text(widget.maxMark!,textScaleFactor: 1.0,))
                        //         ],
                        //       ),
                        //     )
                        //   ],
                        // ),
                        // if (_isExpanded)
                        // Column(
                        //   // mainAxisAlignment: MainAxisAlignment.start,
                        //   crossAxisAlignment: CrossAxisAlignment.start,
                        //   children: [
                        //     Text(widget.activityName!,textScaleFactor: 1.0,),
                        //     // (_heightanimation!.value.height == 190+(widget.themes!.length * 30)) ? Divider() : SizedBox(),
                        //     Divider(),
                        //     // (_heightanimation!.value.height == 190+(widget.themes!.length * 25)) ? Divider() : SizedBox(),
                        //     Container(
                        //       width: 1.sw,
                        //       child: Row(
                        //         mainAxisAlignment: _isExpanded ? MainAxisAlignment.center : MainAxisAlignment.end,
                        //         children: [
                        //           Container(
                        //             width: _markanim!.value.height,
                        //             height: 60,
                        //             // color: ,
                        //             decoration: BoxDecoration(
                        //                 color: (widget.markObt.toString() == 'null')? ColorUtil.absentIndiColor: ColorUtil.green,
                        //                 borderRadius: BorderRadius.all(Radius.circular(15))
                        //             ),
                        //             child: Row(
                        //               mainAxisAlignment:
                        //               MainAxisAlignment.center,
                        //               children: [
                        //                 Text(
                        //                   (widget.markObt.toString() == 'null')
                        //                       ? 'NA'
                        //                       : '${widget.markObt!}',
                        //                   textScaleFactor: 1.0,
                        //                   style: TextStyle(
                        //                       color: Colors.white,
                        //                       fontWeight: FontWeight.w700,
                        //                       fontFamily: "Axiforma",
                        //                       fontStyle: FontStyle.normal,
                        //                       fontSize: 18.sp),
                        //                 ),
                        //                 Text(
                        //                   '/',
                        //                   style: TextStyle(fontSize: 18.sp),
                        //                 ),
                        //                 Center(child: Text(widget.maxMark!,textScaleFactor: 1.0,))
                        //               ],
                        //             ),
                        //           )
                        //         ],
                        //       ),
                        //     ),
                        //     const SizedBox(height: 10),
                        //     (_heightanimation!.value.height == 190+(widget.themes!.length * 30))
                        //         ? Row(
                        //       crossAxisAlignment: CrossAxisAlignment.start,
                        //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //       children: [
                        //         Text(
                        //           'Topic',
                        //           textScaleFactor: 1.0,
                        //           style: TextStyle(
                        //               color: const Color(0xff4b4b4b),
                        //               fontWeight: FontWeight.w600,
                        //               fontFamily: "OpenSans",
                        //               fontStyle: FontStyle.normal,
                        //               fontSize: 15.sp),
                        //         ),
                        //         Column(
                        //           children: [
                        //             ...widget.themes!
                        //                 .map((e) =>
                        //                 Container(width: 150, child: Text(e,textScaleFactor: 1.0,)))
                        //                 .toList(),
                        //           ],
                        //         )
                        //
                        //       ],
                        //     )
                        //         : SizedBox(
                        //       height: 10,
                        //     ),
                        //   ],
                        // )
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
