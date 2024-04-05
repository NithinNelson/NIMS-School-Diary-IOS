import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:open_file_safe/open_file_safe.dart';
import 'package:url_launcher/url_launcher.dart';

class MessageWidget extends StatefulWidget {
  final String content;
  const MessageWidget({super.key, required this.content});

  @override
  State<MessageWidget> createState() => _MessageWidgetState();
}

class _MessageWidgetState extends State<MessageWidget> {
  @override
  Widget build(BuildContext context) {
    final words = widget.content.split(' ');

    return Padding(
        padding: const EdgeInsets.only(left: 8, right: 8, top: 5, bottom: 5),
        child: SelectableText.rich(
          TextSpan(
            children: words.map((word) {
              if (word.startsWith('http')) {
                return TextSpan(
                  text: '$word ',
                  style: const TextStyle(
                      color: Colors.blue, decoration: TextDecoration.underline),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      _launchURL(word);
                    },
                );
              } else {
                return TextSpan(
                  text: '$word ',
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                );
              }
            }).toList(),
          ),
        ));
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }
}

// SelectableText(
// widget.content,
// style: const TextStyle(
// color: Colors.white,
// ),
// ),
