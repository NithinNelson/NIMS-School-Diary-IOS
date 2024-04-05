import 'dart:io';

import 'package:dio/dio.dart';
import 'package:educare_dubai_v2/Util/color_util.dart';
import 'package:educare_dubai_v2/Widgets/imageView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart';

class ImageWidget extends StatefulWidget {
  final String? fileUrl;
  const ImageWidget({super.key, this.fileUrl});

  @override
  State<ImageWidget> createState() => _ImageWidgetState();
}

class _ImageWidgetState extends State<ImageWidget> {
  // String _size = "0";
  // bool _loader = false;
  // bool _isDownloading = false;
  // File? _imageFile;
  // var progressStr = "";
  // var progressPer = 0.0;
  //
  // @override
  // void initState() {
  //   // _initialize();
  //   super.initState();
  // }
  //
  // Future<void> _initialize() async {
  //   await _getFileSize();
  //   await _checkExistImage();
  // }
  //
  // @override
  // void didUpdateWidget(covariant ImageWidget oldWidget) {
  //   if (!_isDownloading) {
  //     _checkExistImage();
  //   }
  //   super.didUpdateWidget(oldWidget);
  // }
  //
  // Future _getFileSize() async {
  //   print(
  //       "--------fgtb---------${widget.fileUrl!.split("/").last.split(".").first}");
  //   _loader = true;
  //   try {
  //     final response = await http.head(Uri.parse(widget.fileUrl!));
  //     if (response.statusCode == 200) {
  //       final contentLength = response.headers['content-length'];
  //       if (contentLength != null) {
  //         final fileSizeInBytes = int.parse(contentLength);
  //         if (fileSizeInBytes < 1024) {
  //           _size = '$fileSizeInBytes B';
  //         } else if (fileSizeInBytes < 1024 * 1024) {
  //           _size = '${(fileSizeInBytes / 1024).toStringAsFixed(2)} KB';
  //         } else {
  //           _size =
  //               '${(fileSizeInBytes / (1024 * 1024)).toStringAsFixed(2)} MB';
  //         }
  //       }
  //     }
  //   } catch (e) {
  //     print('Error: $e');
  //   }
  //   _loader = false;
  // }
  //
  // Future _checkExistImage() async {
  //   var status = await Permission.storage.status;
  //   if (status.isDenied) {
  //     if (await Permission.storage.request().isGranted) {
  //       // checkPermission = true;
  //     }
  //   }
  //
  //   final path = (await getApplicationDocumentsDirectory()).path;
  //   var dir = Directory(
  //       '$path/SchoolDiaryChat/${widget.studentId}/${widget.subjectId}');
  //
  //   try {
  //     var files = dir.listSync();
  //     files.forEach((file) {
  //       if ((file.path.split('/').last == widget.fileUrl!.split('/').last)) {
  //         setState(() => _imageFile = File(file.path));
  //         print("-------ryhrt-----___${_imageFile!.path}");
  //       }
  //     });
  //   } catch (e) {
  //     print(e);
  //   }
  // }
  //
  // Future<File?> _downloadImage({filename}) async {
  //   setState(() => _isDownloading = true);
  //   await Permission.storage.request();
  //
  //   final path = (await getApplicationDocumentsDirectory()).path;
  //   var dir = Directory(
  //       '$path/SchoolDiaryChat/${widget.studentId}/${widget.subjectId}');
  //
  //   var file = File('/');
  //   if (await dir.exists()) {
  //     file = File('${dir.path}/$filename');
  //   } else {
  //     var dir = await Directory(
  //             '$path/SchoolDiaryChat/${widget.studentId}/${widget.subjectId}')
  //         .create(recursive: true);
  //     file = File('${dir.path}/$filename');
  //   }
  //
  //   try {
  //     Dio dio = Dio();
  //     await dio.download(widget.fileUrl!, '${dir.path}/$filename',
  //         onReceiveProgress: (rec, total) {
  //       setState(() {
  //         progressPer = rec / total;
  //         progressStr = ((rec / total) * 100).toStringAsFixed(0);
  //       });
  //       if (progressStr == '100') {
  //         _isDownloading = false;
  //       }
  //     });
  //     await _initialize();
  //     print("-------ryjjjjjrj-----___${_imageFile!.path}");
  //     setState(() => _isDownloading = false);
  //     return file;
  //   } catch (e) {
  //     setState(() => _isDownloading = false);
  //     print("--e---${e.toString()}");
  //     return null;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 5),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: GestureDetector(
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return ImageViewWidget(fileUrl: widget.fileUrl!);
                    }));
                  },
                  child: Image.network(
                    width: 230,
                    widget.fileUrl!,
                  ),
                ),
      ),
    );
  }
}
