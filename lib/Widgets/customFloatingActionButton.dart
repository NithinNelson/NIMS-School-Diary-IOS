import 'package:cached_network_image/cached_network_image.dart';
import 'package:educare_dubai_v2/Util/color_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../Models/message_unread_count.dart';
import '../Models/user_model.dart';
import '../Util/api_constants.dart';
import 'dart:math' show pi;

class CustomFloatingActionButton extends StatefulWidget {
  final int seletedPageIndex;
  final String dashChildId;
  final List<StudentDetail>? studentList;
  final MessageCount? unreadMsg;
  final Function(bool) callback;
  final Function(int) pageUpdate;
  final Function(int) pageSwitch;
  const CustomFloatingActionButton({
    super.key,
    required this.seletedPageIndex,
    this.studentList,
    required this.callback,
    required this.pageUpdate,
    required this.pageSwitch,
    this.unreadMsg,
    required this.dashChildId,
  });

  @override
  State<CustomFloatingActionButton> createState() => _CustomFloatingActionButtonState();
}

class _CustomFloatingActionButtonState extends State<CustomFloatingActionButton> with TickerProviderStateMixin {
  AnimationController? controller;
  Animation<Size>? _animation;
  AnimationController? textController;
  AnimationController? rotationController;
  Animation<Size>? _textAnimation;
  Animation<Size>? _rotationAnimation;
  Animation<Size>? _dashFloatButton;
  bool _floatExpand = false;
  bool _countFlag = false;
  int _dashCount = 0;

  @override
  void initState() {
    controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 100));
    textController = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    rotationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 100));
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _setAnimation();
    _initializeChatCount();
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant CustomFloatingActionButton oldWidget) {
    _initializeChatCount();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    controller!.dispose();
    textController!.dispose();

    super.dispose();
  }

  _setAnimation() {
    _animation = controller!.drive(
      Tween<Size>(
        begin: Size(MediaQuery.of(context).size.width, 0),
        end: Size(MediaQuery.of(context).size.width, widget.studentList!.length * 50),
      ),
    );
    _dashFloatButton = controller!.drive(
      Tween<Size>(
        begin: Size(MediaQuery.of(context).size.width, 0),
        end: Size(MediaQuery.of(context).size.width, 100),
      ),
    );
    _textAnimation = textController!.drive(
      Tween<Size>(
        begin: const Size(0, 0),
        end: Size(MediaQuery.of(context).size.width * 0.5, 0),
      ),
    );
    _rotationAnimation = rotationController!.drive(
      Tween<Size>(
        begin: const Size(0 * (pi/180), 0),
        end: const Size(90 * (pi/180), 0),
      ),
    );
    _animation!.addListener(() => setState(() {}));
    _textAnimation!.addListener(() => setState(() {}));
    _dashFloatButton!.addListener(() => setState(() {}));
    _rotationAnimation!.addListener(() => setState(() {}));
  }

  Future<void> _callAnimation() async {
    setState(() {
      _floatExpand = !_floatExpand;
      widget.callback(_floatExpand);
    });
    if (_floatExpand) {
      controller!.forward();
      textController!.forward();
      rotationController!.forward();
    } else {
      controller!.reverse();
      textController!.reverse();
      rotationController!.reverse();
      await Future.delayed(const Duration(milliseconds: 100));
    }
  }

  _initializeChatCount() {
    setState(() {
      _dashCount = 0;
      _countFlag = false;
    });

    if (widget.unreadMsg!.data != null) {
      widget.unreadMsg!.data!.count!.forEach((element) {
        if(element.unreadCount != 0) {
          setState(() => _countFlag = true);
          if (widget.dashChildId == element.studentId) {
            setState(() => _dashCount = element.unreadCount!);
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.seletedPageIndex == 0) {
      return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Positioned(
              bottom: 40,
              right: 0,
              child: Container(
                width: _dashFloatButton!.value.width,
                height: _dashFloatButton!.value.height,
                child: ListView(
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(right: 5),
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if(_floatExpand)
                          Card(
                            color: Colors.deepPurple.shade50,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 5, right: 5),
                              child: Container(
                                constraints: BoxConstraints(
                                    maxWidth: _textAnimation!.value.width
                                ),
                                child: Text(
                                  "Chat",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ),
                        Container(
                          width: 40,
                          height: 40,
                          child: Stack(
                            children: [
                              FloatingActionButton(
                                backgroundColor: Colors.deepPurple.shade300,
                                onPressed: () async {
                                  await _callAnimation();
                                  setState(() {
                                    widget.pageUpdate(13);
                                  });
                                },
                                child: SvgPicture.asset(
                                  "assets/images/Chat-Icon.svg",
                                  width: 20,
                                  colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                                ),
                              ),
                              if(_dashCount != 0)
                                Align(
                                  alignment: Alignment.topRight,
                                  child: CircleAvatar(
                                    radius: 8,
                                    child: Text(
                                      _dashCount.toString(),
                                      style: const TextStyle(
                                        fontSize: 7,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if(_floatExpand)
                          Card(
                            color: Colors.deepPurple.shade50,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 5, right: 5),
                              child: Container(
                                constraints: BoxConstraints(
                                    maxWidth: _textAnimation!.value.width
                                ),
                                child: Text(
                                  "Leave",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ),
                        Container(
                          width: 40,
                          height: 40,
                          child: FloatingActionButton(
                            backgroundColor: Colors.red,
                            onPressed: () async {
                              await _callAnimation();
                              setState(() {
                                widget.pageUpdate(12);
                              });
                            },
                            child: SvgPicture.asset(
                              "assets/images/leave-request.svg",
                              width: 20,
                              colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 50,
                height: 50,
                child: FloatingActionButton(
                  backgroundColor: ColorUtil.deepPurple,
                  onPressed: _callAnimation,
                  child: Transform.rotate(
                    angle: _rotationAnimation!.value.width,
                    child: Icon(_floatExpand ? Icons.close : Icons.menu, color: Colors.white,),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    } else if (0 < widget.seletedPageIndex && widget.seletedPageIndex < 13) {
      return Container(
        width: MediaQuery.of(context).size.width,
        height: 50 + _animation!.value.height,
        child: Stack(
          children: [
            Positioned(
              bottom: widget.studentList!.length == 1 ? 50 : 40,
              left: 0,
              right: 0,
              child: Container(
                width: _animation!.value.width,
                height: _animation!.value.height,
                child: ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(right: 5),
                  itemCount: widget.studentList!.length,
                  itemBuilder: (context, index) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if(_floatExpand)
                          Card(
                            color: Colors.deepPurple.shade50,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 5, right: 5),
                              child: Container(
                                constraints: BoxConstraints(
                                    maxWidth: _textAnimation!.value.width
                                ),
                                child: Text(
                                  "${widget.studentList![index].name}",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ),
                        Container(
                          width: 40,
                          height: 40,
                          child: Stack(
                            children: [
                              FloatingActionButton(
                                onPressed: () {
                                  print("------br----___${widget.studentList!.length}");
                                  print("-------br---___$index");
                                  widget.pageUpdate(13);
                                  widget.callback(false);
                                  widget.pageSwitch(index);
                                },
                                child: ClipRRect(
                                  borderRadius:
                                  const BorderRadius.all(
                                      Radius.circular(
                                          60)),
                                  child: CachedNetworkImage(
                                    imageUrl: "${ApiConstants.downloadUrl}${widget.studentList![index].photo}",
                                    width: 39,
                                    height: 39,
                                    fit: BoxFit.cover,
                                    placeholder:
                                        (context, url) =>
                                        Image.asset(
                                          'assets/images/userImage.png',
                                          width: 35,
                                          height: 35,
                                        ),
                                    errorWidget: (context,
                                        url, error) =>
                                        Image.asset(
                                          'assets/images/userImage.png',
                                          width: 35,
                                          height: 35,
                                        ),
                                  ),
                                ),
                              ),
                              if (widget.unreadMsg!.data!.count![index].unreadCount != 0)
                                Align(
                                    alignment: Alignment.topRight,
                                    child: CircleAvatar(
                                        radius: 8,
                                      child: Text(
                                          widget.unreadMsg!.data!.count![index].unreadCount.toString(),
                                        style: const TextStyle(
                                          fontSize: 7,
                                        ),
                                      ),
                                    ),
                                  ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 5),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 50,
                height: 50,
                child: Stack(
                  children: [
                    FloatingActionButton(
                      onPressed: _callAnimation,
                      backgroundColor: _floatExpand ? Colors.deepPurple.shade500 : Colors.deepPurple.shade300,
                      child: SvgPicture.asset(
                        "assets/images/Chat-Icon.svg",
                        width: 20,
                        colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                      ),
                    ),
                    if(_countFlag)
                      Align(
                        alignment: Alignment.topRight,
                        child: CircleAvatar(
                          radius: 8,
                          backgroundColor: Colors.red,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Container();
    }
  }
}
