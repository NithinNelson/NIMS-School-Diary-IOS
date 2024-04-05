import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../Services/snack_bar.dart';

class ImageViewWidget extends StatefulWidget {
  final String fileUrl;
  const ImageViewWidget({super.key, required this.fileUrl});

  @override
  State<ImageViewWidget> createState() => _ImageViewWidgetState();
}

class _ImageViewWidgetState extends State<ImageViewWidget> {

  Future<File?> _downloadImage({filename}) async {
    // setState(() => _isDownloading = true);
    await Permission.storage.request();

    final path = (await getDownloadsDirectory())!.path;
    var dir = Directory(path);

    var file = File('/');
    if (await dir.exists()) {
      file = File('${dir.path}/$filename');
    } else {
      var dir = await Directory(path).create(recursive: true);
      file = File('${dir.path}/$filename');
    }

    try {
      Dio dio = Dio();
      await dio.download(widget.fileUrl, '${dir.path}/$filename',
          // onReceiveProgress: (rec, total) {
          //   setState(() {
          //     progressPer = rec / total;
          //     progressStr = ((rec / total) * 100).toStringAsFixed(0);
          //   });
          //   if (progressStr == '100') {
          //     _isDownloading = false;
          //   }
          // }
          );
      await ImageGallerySaver.saveFile(file.path);
      snackBar(context: context, message: "Image saved to gallery", color: Colors.green);
      // await _initialize();
      // setState(() => _isDownloading = false);
      print("----------hrthr-----------${file.path}");
      return file;
    } catch (e) {
      // setState(() => _isDownloading = false);
      print("--e---${e.toString()}");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
            elevation: 1,
            position: PopupMenuPosition.under,
            onSelected: (String choice) async {
              // Handle menu item selection here
              if (choice == 'Option 1') {
                // Handle Option 1
                // await Permission.storage.request();
                // await ImageGallerySaver.saveFile(widget.imageFile.path);
                _downloadImage(filename: widget.fileUrl.split("/").last);
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<String>(
                  value: 'Option 1',
                  child: Text(
                    'Save to gallery',
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: Center(
        child: InteractiveViewer(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Center(
              child: Image.network(
                width: MediaQuery.of(context).size.width,
                  widget.fileUrl,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
