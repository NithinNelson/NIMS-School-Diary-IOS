
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';

class ShowWarnDialog {

  Future<bool?> showWarn(
      {required BuildContext context,
        required String message,
        IconData? iconData,
        bool? isCameraPage}) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          title: Icon(
            iconData ?? Icons.error_outline,
            color: Colors.red,
            size: 60,
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              FittedBox(
                child: Text(
                  message,
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color(0xFF3392BE),
                      elevation: 0),
                  onPressed: () async {
                    await openAppSettings();
                    // _openAppSettings(context: context, callback: callback);
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Enable",
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color(0xFF3392BE).withOpacity(0.5),
                      elevation: 0),
                  onPressed: () {
                    Navigator.pop(context);
                    if (isCameraPage != null && isCameraPage) {
                      Navigator.pop(context);
                    }
                  },
                  child: const Text(
                    "Cancel",
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openAppSettings(
      {required BuildContext context, VoidCallback? callback}) async {
    await openAppSettings();
    if (callback != null) {
      Navigator.push(
          context, MaterialPageRoute(builder: (_) => _DummyPage(callback)));
    }
  }
}

class _DummyPage extends StatelessWidget {
  final VoidCallback onReturn;

  const _DummyPage(this.onReturn);

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      onReturn();
      Navigator.pop(context);
    });

    return Container();
  }
}
