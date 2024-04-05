import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Models/assignment_model.dart';
import '../Util/color_util.dart';

class AttachUrlWidget extends StatefulWidget {
  final ClassRoomFile? file;
  const AttachUrlWidget({Key? key, this.file}) : super(key: key);

  @override
  State<AttachUrlWidget> createState() => _AttachUrlWidgetState();
}

class _AttachUrlWidgetState extends State<AttachUrlWidget> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      //width: 100,
      height: 40,
      decoration: BoxDecoration(
        color: Color(0xfff8f9ff),
      ),
      //color: Colors.white,
      child: Row(
        children: [
          Container(
            width: 100,
            height: 35,
            //color: Colors.blue,
            decoration: BoxDecoration(
                color: widget.file!.type == "drive"
                    ? ColorUtil.darkGreen.withOpacity(0.6)
                    : ColorUtil.darkGreen,
                borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: linkWidget(widget.file!.type),
            ),
          ),
        ],
      ),
    );
  }

  Widget linkWidget(type) {
    switch (type) {
      case "drive":
        return GestureDetector(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: const Text(
                  "This is for your information, file access only for students.",
                style: TextStyle(color: Colors.black),
              ),
              margin: const EdgeInsets.all(20),
              backgroundColor: Colors.purple[200],
              behavior: SnackBarBehavior.floating,
            ));
          },
          child: Row(
            children: [
              Icon(
                Icons.add_to_drive,
                color: Colors.yellowAccent,
                size: 20,
              ),
              SizedBox(
                width: 4,
              ),
              SizedBox(
                width: 60,
                child: Text(
                  widget.file!.name!,
                  style: const TextStyle(
                      color: ColorUtil.white,
                      fontSize: 12,
                      overflow: TextOverflow.ellipsis),
                ),
              ),
            ],
          ),
        );
      case "link":
        return GestureDetector(
          onTap: () async {
            await launchUrl(Uri.parse(widget.file!.link.toString()),
                mode: LaunchMode.externalApplication);
          },
          child: Row(
            children: [
              Icon(
                Icons.link,
                color: Colors.lightBlueAccent,
                size: 20,
              ),
              SizedBox(
                width: 4,
              ),
              SizedBox(
                width: 60,
                child: Text(
                  widget.file!.name!,
                  style: const TextStyle(
                      color: ColorUtil.white,
                      fontSize: 12,
                      overflow: TextOverflow.ellipsis),
                ),
              ),
            ],
          ),
        );
      case "youtube":
        return GestureDetector(
          onTap: () async {
            await launchUrl(Uri.parse(widget.file!.link.toString()),
                mode: LaunchMode.externalApplication);
          },
          child: Row(
            children: [
              Icon(
                Icons.play_arrow,
                color: Colors.red,
                size: 20,
              ),
              SizedBox(
                width: 4,
              ),
              SizedBox(
                width: 60,
                child: Text(
                  widget.file!.name!,
                  style: const TextStyle(
                      color: ColorUtil.white,
                      fontSize: 12,
                      overflow: TextOverflow.ellipsis),
                ),
              ),
            ],
          ),
        );
      default:
        return Row(
          children: [
            const Icon(
              Icons.add_to_drive,
              color: ColorUtil.white,
              size: 20,
            ),
            const SizedBox(
              width: 4,
            ),
            SizedBox(
              width: 60,
              child: Text(
                widget.file!.name!,
                style: const TextStyle(
                    color: ColorUtil.white,
                    fontSize: 12,
                    overflow: TextOverflow.ellipsis),
              ),
            ),
          ],
        );
    }
  }
}
