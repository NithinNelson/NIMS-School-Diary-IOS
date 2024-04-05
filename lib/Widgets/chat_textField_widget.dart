import 'dart:io';

import 'package:educare_dubai_v2/Models/message_model.dart';
import 'package:educare_dubai_v2/Provider/chat_provider.dart';
import 'package:educare_dubai_v2/Provider/user_provider.dart';
import 'package:educare_dubai_v2/Widgets/camera_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Services/check_connectivity.dart';
import '../Services/dialog_box.dart';
import '../Services/snack_bar.dart';
import '../Util/color_util.dart';
import 'chat_audioPlaying_widget.dart';

class ChatTextFieldWidget extends StatefulWidget {
  final String? classs;
  final String? batch;
  final String? parentId;
  final String? teacherId;
  final String? studentId;
  final String? studentName;
  final String? subId;
  final String? sub;

  const ChatTextFieldWidget(
      {super.key,
      this.classs,
      this.batch,
      this.parentId,
      this.teacherId,
      this.subId,
      this.sub,
      this.studentId,
      this.studentName});

  @override
  State<ChatTextFieldWidget> createState() => _ChatTextFieldWidgetState();
}

class _ChatTextFieldWidgetState extends State<ChatTextFieldWidget> {
  late TextEditingController _messageController;
  final FocusNode _focusNode = FocusNode();
  bool _ismessageIconEnabled = false;
  String? _selectedFile;
  bool _iconLoader = false;
  String? _audioPath;

  @override
  void initState() {
    _messageController = TextEditingController();
    _audioPath = Provider.of<ChatProvider>(context, listen: false).audioPath;
    _selectedFile = Provider.of<ChatProvider>(context, listen: false).filePath;
    if (_audioPath != null || _selectedFile != null) {
      _ismessageIconEnabled = true;
    }
    _saveKeyboard();
    super.initState();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _focusNode.dispose();
    _removeKeyboard();
    super.dispose();
  }

  _saveKeyboard() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _focusNode.addListener(() async {
      await prefs.setBool("keyboard", true);
    });
  }

  _removeKeyboard() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("keyboard");
  }

  Future<dynamic> _sendAttach(filePath, {String? message}) async {
    try {
      var resp = await Provider.of<UserProvider>(context, listen: false).sendAttachment(filePath: filePath);

      print("---------respdata------------$resp");

      if (resp['status']['code'] == 200) {
        await _sendAttachMsg(
          fileName: resp['data']['file_data']['name'],
          orgName: resp['data']['file_data']['org_name'],
          extension: resp['data']['file_data']['extension'],
          msgText: message,
        );
      }
    } catch (e) {
      snackBar(context: context, message: "Something went wrong.", color: Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Visibility(
          visible: _audioPath != null,
          child: ChatAudioPlayingWidget(
            removeAudioPath: (bool isClear) {
              if (isClear) {
                setState(() {
                  _audioPath = null;
                  if (_messageController.text.isEmpty) {
                    _ismessageIconEnabled = false;
                  }
                });
              }
            },
          ),
        ),
        Visibility(
          visible: _selectedFile != null,
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                      side: BorderSide(color: Colors.grey.shade300,
                      ),
                    ),
                    child: SizedBox(
                      height: 50.h,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width: 25,
                                    child: _attchIcon(_selectedFile?.split("/").last.split(".").last ?? ""),
                                  ),
                                  SizedBox(width: 10),
                                  SizedBox(
                                    width: 200.w,
                                    child: Text(
                                      _selectedFile?.split("/").last ?? "",
                                      overflow: TextOverflow.ellipsis,
                                      // style: const TextStyle(fontSize: 10),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 25,
                                child: IconButton(
                                  onPressed: () {
                                    final provider = Provider.of<ChatProvider>(context, listen: false);
                                    setState(() {
                                      _selectedFile = null;
                                      if (_messageController.text.isEmpty) {
                                        _ismessageIconEnabled = false;
                                      }
                                    });
                                    provider.setFilePath(path: null);
                                  },
                                  icon: const Icon(Icons.close, color: Colors.red,),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            Expanded(
              child: Card(
                elevation: 4,
                shape:
                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(15), side: BorderSide(color: ColorUtil.greenDark.withOpacity(0.5))),
                child: SizedBox(
                  height: 50.h,
                  child: Center(
                    child: TextFormField(
                      controller: _messageController,
                      focusNode: _focusNode,
                      maxLines: 4,
                      minLines: 1,
                      autofocus: false,
                      onChanged: (value) {
                        if (_audioPath == null && _selectedFile == null) {
                          value.isEmpty
                              ? setState(() => _ismessageIconEnabled = false)
                              : setState(() => _ismessageIconEnabled = true);
                        }
                      },
                      decoration: InputDecoration(
                        hintText: 'Type a message',
                        hintStyle: const TextStyle(
                            color: ColorUtil.greybg,
                        ),
                        contentPadding: const EdgeInsets.only(top: 10, bottom: 10, left: 20),
                        filled: true,
                        fillColor: ColorUtil.white,
                        isDense: true,
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(
                            style: BorderStyle.none,
                            width: 0,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        suffixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Visibility(
                              visible: _audioPath == null,
                              child: RotatedBox(
                                quarterTurns: 45,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  child: IconButton(
                                    onPressed: () => _selectAttachment(),
                                    icon: Icon(
                                      Icons.attach_file,
                                      color: ColorUtil.greybg,
                                      size: 25.h,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // if (!_ismessageIconEnabled)
                              Container(
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child: Visibility(
                                  visible: _audioPath == null,
                                  child: IconButton(
                                    onPressed: () async {
                                      _focusNode.unfocus();
                                      bool permission = await permissionCheck(context);
                                      if (permission) {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return CameraScreen(
                                                setImgPath: (String image) {
                                                  setState(() {
                                                    _selectedFile = image;
                                                    _ismessageIconEnabled = true;
                                                  });
                                                },
                                              );
                                            },
                                          ),
                                        );
                                      }
                                    },
                                    icon: Icon(
                                      Icons.camera_alt,
                                      color: ColorUtil.greybg,
                                      size: 25.h,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 5),
            GestureDetector(
              onLongPress: () async {
                await Permission.microphone.request();

                if (await Permission.microphone.status.isGranted) {
                  if(!_ismessageIconEnabled) {
                    final provider = Provider.of<ChatProvider>(context, listen: false);
                    HapticFeedback.vibrate();
                    provider.chatField(ChatField.audioRecording);
                  }
                } else {
                  ShowWarnDialog().showWarn(context: context, message: "Enable microphone permission.", iconData: Icons.mic_none);
                }
              },
              child: Card(
                elevation: 4,
                shape:
                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                child: Container(
                  decoration: const BoxDecoration(
                    color: ColorUtil.greenDark,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: () async {
                      if (!_iconLoader && _ismessageIconEnabled) {
                        setState(() => _iconLoader = true);
                        try {
                          bool connected = await CheckConnectivity().check();
                          bool isConnectionGood = await CheckConnectivity().goodConnection();
                          if (connected) {
                            if (isConnectionGood) {
                              if (_audioPath != null || _selectedFile != null) {
                                await _sendAttach(
                                  _audioPath ?? _selectedFile,
                                  message: _messageController.text.isNotEmpty
                                      ? _messageController.text
                                      : null,
                                );
                              } else {
                                if (_messageController.text.isNotEmpty) {
                                  await _sendAttachMsg(
                                    fileName: null,
                                    orgName: null,
                                    extension: null,
                                    msgText: _messageController.text,
                                  );
                                }
                              }
                            } else {
                              snackBar(context: context, message: "Something went wrong.", color: Colors.red);
                            }
                          } else {
                            snackBar(context: context, message: "No Internet Connection.", color: Colors.red);
                          }
                        } catch (e) {
                          print("---------message send error--------${e.toString()}");
                        } finally {
                          setState(() => _iconLoader = false);
                        }
                      }
                    },
                    icon: _iconLoader ? const SizedBox(
                      width: 10,
                      height: 10,
                      child: CircularProgressIndicator(color: Colors.white),
                    ) :  Icon(
                      _ismessageIconEnabled
                          ? Icons.send_outlined
                          : Icons.mic_none_outlined,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  _selectAttachment() async {
    bool connected = await CheckConnectivity().check();

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        // allowedExtensions: [
        //   'pdf',
        //   'jpg',
        //   'jpeg',
        //   'png',
        //   'mp4',
        //   'mov',
        //   'avi',
        //   'mkv',
        //   'mp3',
        //   'wav',
        //   'opus',
        //   'm4a',
        // ],
      ).whenComplete(() {
        if (!connected) {
          snackBar(context: context, message: "No Internet Connection.", color: Colors.red);
        }
      });

      if (result != null) {
        File file = File(result.files.single.path!);

        int fileSizeInBytes = await file.length();

        final provider = Provider.of<ChatProvider>(context, listen: false);

        if (fileSizeInBytes < 30 * 1024 * 1024) {
          provider.setFilePath(path: result.files.single.path);
          setState(() {
            _selectedFile = provider.filePath;
            _ismessageIconEnabled = true;
          });
        } else {
          if (_selectedFile != null) {
            setState(() => _selectedFile = null);
            provider.setFilePath(path: null);
          }
          snackBar(context: context, message: "The selected file is above 30 MB", color: Colors.red);
        }
      }
    } catch (e) {
      if (await Permission.storage.status.isDenied || await Permission.storage.status.isPermanentlyDenied) {
        await ShowWarnDialog().showWarn(context: context, message: "Enable storage permission.");
      }
      print("--------_selectAttachment---------${e.toString()}");
    }
  }

  Future<dynamic> _sendAttachMsg({
    required String? fileName,
    required String? orgName,
    required String? extension,
    required String? msgText,
  }) async {
    try {
      var resp = await Provider.of<UserProvider>(context, listen: false).sendMsg(
          classs: widget.classs.toString(),
          batch: widget.batch.toString(),
          subId: widget.subId.toString(),
          sub: widget.sub.toString(),
          fromId: widget.parentId.toString(),
          studentId: widget.studentId.toString(),
          studentName: widget.studentName.toString(),
          toId: widget.teacherId.toString(),
          message: msgText,
          fileName: fileName,
          orgName: orgName,
          extension: extension);

      if (resp['status']['code'] == 200) {
        _messageController.clear();
        final provider = Provider.of<ChatProvider>(context, listen: false);
        provider.setFilePath(path: null);
        provider.setAudioPath(path: null);
        setState(() {
          // _iconLoader = false;
          _ismessageIconEnabled = false;
          _audioPath = null;
          _selectedFile = null;
        });
      }

      print("------msg-------$resp");
    } catch (e) {
      snackBar(context: context, message: "Something went wrong.", color: Colors.red);
    }
  }

  Widget _attchIcon(type) {
    if (type == 'jpg' || type == 'jpeg' || type == 'png') {
      return const Icon(Icons.image, color: Colors.deepPurple,);
    } else if (type == 'pdf') {
      return const Icon(Icons.picture_as_pdf, color: Colors.red,);
    } else if (type == 'mp3' || type == 'wav') {
      return const Icon(Icons.audiotrack_rounded, color: Colors.red,);
    } else {
      return Icon(Icons.attach_file, color: Colors.lightBlue.shade100,);
    }
  }

  Future<bool> permissionCheck(context) async {
    PermissionStatus cameraPermissionStatus = await Permission.camera.status;
    PermissionStatus micPermissionStatus = await Permission.microphone.status;

    if (cameraPermissionStatus.isGranted && micPermissionStatus.isGranted) {
      return true;
    } else if (cameraPermissionStatus.isDenied) {
      await Permission.camera.request();
      cameraPermissionStatus = await Permission.camera.status;
      if (!cameraPermissionStatus.isGranted) {
        await ShowWarnDialog().showWarn(
          context: context,
          message: 'Enable camera access.',
          iconData: Icons.camera_alt,
          isCameraPage: false,
        );
      }
    } else if (micPermissionStatus.isDenied) {
      await Permission.microphone.request();
      micPermissionStatus = await Permission.microphone.status;
      if (!micPermissionStatus.isGranted) {
        await ShowWarnDialog().showWarn(
          context: context,
          message: 'Audio access denied.',
          iconData: Icons.mic,
          isCameraPage: false,
        );
      }
    } else {
      if (cameraPermissionStatus.isPermanentlyDenied) {
        await ShowWarnDialog().showWarn(
          context: context,
          message: 'Enable camera access.',
          iconData: Icons.camera_alt,
          isCameraPage: false,
        );
      } else if (micPermissionStatus.isPermanentlyDenied) {
        await ShowWarnDialog().showWarn(
          context: context,
          message: 'Audio access denied.',
          iconData: Icons.mic,
          isCameraPage: false,
        );
      }
    }
    return false;
  }
}
