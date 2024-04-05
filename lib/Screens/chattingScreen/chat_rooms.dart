import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:educare_dubai_v2/Models/chat_rooms.dart';
import 'package:educare_dubai_v2/Provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Util/color_util.dart';
import '../../Util/spinkit.dart';
import 'chattingPage.dart';

class ChatRooms extends StatefulWidget {
  final String? studId;
  final String? studentName;
  final String? parentId;
  const ChatRooms({super.key, this.studId, this.parentId, this.studentName});

  @override
  State<ChatRooms> createState() => _ChatRoomsState();
}

class _ChatRoomsState extends State<ChatRooms> {
  ChatRoomModel _apiResp = const ChatRoomModel();
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<RoomList> _roomList = [];
  List<RoomList> _newList = [];
  bool _loader = false;
  bool _isKeyboardEnabled = false;
  Timer? timer;
  Timer? _value;

  @override
  void initState() {
    _saveKeyboard();
    super.initState();
  }

  @override
  void dispose() {
    _removeKeyboard();
    _searchController.clear();
    _searchController.dispose();
    timer!.cancel();
    _value!.cancel();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant ChatRooms oldWidget) {
    initialize();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    initialize();
    super.didChangeDependencies();
  }

  Future<dynamic> initialize() async {
    await clearList();
    await _getChatRooms();
    _getChatRoomsPeriodically();
  }

  Future<dynamic> clearList() async {
    if(_roomList.isNotEmpty && _newList.isNotEmpty) {
      _roomList.clear();
      _newList.clear();
    }
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

  Future<dynamic> _getChatRooms() async {
      _loader = true;
      // _roomList.clear();
      // _newList.clear();
      _searchController.clear();
      // timer = Timer.periodic(const Duration(seconds: 3), (timer) async {
        try {
          var resp = await Provider.of<UserProvider>(context, listen: false)
              .chattingRooms(studentId: widget.studId.toString());
          if (resp['status']['code'] == 200) {
            _apiResp = ChatRoomModel.fromJson(resp);
            _roomList = _apiResp.data!.list!;
            if (_searchController.text.isEmpty) {
              _newList = _roomList;
            }
          }
          // setState(() => _loader = false);
        } catch (e) {
          // setState(() => _loader = false);
        } finally {
          _loader = false;
          // _getChatRoomsPeriodically();
        }
      // });
  }

  Future<dynamic> _getChatRoomsPeriodically() async {
    // _loader = true;
    // _roomList.clear();
    // _newList.clear();
    try {
      if (timer!.isActive) {
        timer!.cancel();
      }
    } catch(e) {
      print("---------------${e.toString()}");
    }
    // _searchController.clear();
    timer = Timer.periodic(const Duration(seconds: 3), (timer) async {
    try {
      var resp = await Provider.of<UserProvider>(context, listen: false)
          .chattingRooms(studentId: widget.studId.toString());
      if (resp['status']['code'] == 200) {
        _apiResp = ChatRoomModel.fromJson(resp);
        _roomList = _apiResp.data!.list!;
        if (_searchController.text.isEmpty) {
          _newList = _roomList;
        }
      } else {
        // _roomList.clear();
        // _newList.clear();
      }
      // setState(() => _loader = false);
    } catch (e) {
      // setState(() => _loader = false);
    } finally {
      // _loader = false;
    }
    });
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    return Container(
      color: ColorUtil.white,
      height: 1.sh - 130,
      child: _loader
          ? ListView.builder(itemCount: 10, itemBuilder: (ctx, _) => skeleton)
          : Column(
              children: [
                Container(
                  height: 50,
                  padding: const EdgeInsets.only(left: 8.0, right:  8.0),
                  child: Center(
                    child: TextFormField(
                      focusNode: _focusNode,
                      controller: _searchController,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                            width: 2,
                            color: Colors.grey
                          )
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                            width: 2,
                            color: Colors.grey
                          )
                        ),
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: _searchController.text.isEmpty
                            ? null
                            : IconButton(
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() => _newList = _roomList);
                                },
                                icon: const Icon(Icons.cancel),
                        ),
                        hintText: "Search Subject",
                        contentPadding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
                      ),
                      onTap: () {
                        if (_focusNode.hasFocus) {
                          _focusNode.unfocus();
                        }
                      },
                      onChanged: (value) {
                        setState(() {
                          _newList = _roomList
                              .where((element) => element.subject!
                              .toLowerCase()
                              .contains(value.toLowerCase()))
                              .toList();
                        });
                      },
                    ),
                  ),
                ),
                Container(
                  height: 1.sh - 230,
                  child: _newList.isNotEmpty
                      ? RefreshIndicator(
                          onRefresh: _getChatRooms,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Scrollbar(
                              thumbVisibility: true,
                              controller: _scrollController,
                              radius: const Radius.circular(10),
                              interactive: true,
                              thickness: 2,
                              child: ListView.separated(
                                physics: const BouncingScrollPhysics(),
                                padding:
                                    const EdgeInsets.only(top: 10, bottom: 50),
                                itemCount: _newList.length,
                                controller: _scrollController,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 10),
                                    title: Text(
                                      "${_newList[index].subject} - ${_newList[index].teacherName}",
                                      style: const TextStyle(
                                          fontSize: 15, fontFamily: "SegoeUI"),
                                    ),
                                    // subtitle: Text(
                                    //   index == 0
                                    //       ? "Hii..."
                                    //       : index == 1
                                    //           ? "physics note..."
                                    //           : index == 2
                                    //               ? "where..."
                                    //               : "last message...",
                                    // ),
                                    onTap: () {
                                      // print("$index");
                                      Navigator.of(context).push(
                                          MaterialPageRoute(builder: (context) {
                                        return ChattingPage(
                                          room: _newList[index],
                                          studentId: "${widget.studId}",
                                          parentId: "${widget.parentId}",
                                          studentName: "${widget.studentName}",
                                        );
                                      }));
                                    },
                                    leading: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.purple),
                                        shape: BoxShape.circle
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(100),
                                        child: CachedNetworkImage(
                                          imageUrl: "${_newList[index].teacherImage}",
                                          width: 39,
                                          height: 39,
                                          fit: BoxFit.cover,
                                          placeholder:
                                              (context, url) =>
                                              Icon(Icons.person),
                                          errorWidget: (context,
                                              url, error) =>
                                              Icon(Icons.person),
                                        ),
                                      ),
                                    ),
                                    trailing: _newList[index].unreadCount == 0
                                        ? const Text("")
                                        : CircleAvatar(
                                            backgroundColor: Colors.green,
                                            radius: 12,
                                            child: Text(
                                                _newList[index]
                                                    .unreadCount
                                                    .toString(),
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    color: ColorUtil.white)),
                                          ),
                                  );
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return const Divider();
                                },
                              ),
                            ),
                          ),
                        )
                      : const Center(
                          child: Text("No data"),
                        ),
                ),
              ],
            ),
    );
  }
}
