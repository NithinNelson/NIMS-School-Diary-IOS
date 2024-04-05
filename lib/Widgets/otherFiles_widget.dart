import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class OtherFiles extends StatefulWidget {
  final String content;
  final String fileName;
  const OtherFiles({super.key, required this.content, required this.fileName});

  @override
  State<OtherFiles> createState() => _OtherFilesState();
}

class _OtherFilesState extends State<OtherFiles> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 5),
      child: GestureDetector(
        onTap: () async {
          await launchUrlString(widget.content);
        },
        child: Container(
          width: 230,
          // height: 50,
          decoration: BoxDecoration(
              color: Colors.purple.shade50,
              borderRadius: BorderRadius.circular(15)
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: Container(
                    width: 25,
                      child: attchIcon(widget.content.split("/").last.split(".").last),
                  ),
                ),
                Container(
                  width: 140,
                  child: Text(
                      widget.fileName
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget attchIcon(type) {
    if (type == 'jpg' || type == 'jpeg' || type == 'png') {
      return const Icon(Icons.image, color: Colors.deepPurple,);
    } else if (type == 'pdf') { 
      return const Icon(Icons.picture_as_pdf, color: Colors.red,);
    } else if (type == 'mp4' || type == 'avi' || type == 'mov' || type == 'mkv') {
      return const Icon(Icons.play_arrow, color: Colors.red,);
    } else {
      return Icon(Icons.attach_file, color: Colors.lightBlue.shade100,);
    }
  }
}
