import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Models/appliedLeaves_model.dart';
import '../Provider/user_provider.dart';
import '../Util/snackBar.dart';

class LeaveDeleteButton extends StatefulWidget {
  final Details details;
  final Function(bool) reloadData;
  const LeaveDeleteButton({super.key, required this.details, required this.reloadData});

  @override
  State<LeaveDeleteButton> createState() => _LeaveDeleteButtonState();
}

class _LeaveDeleteButtonState extends State<LeaveDeleteButton> {
  bool _deleteButton = false;

  Future<dynamic> deleteLeaveData(
      {required String leaveId,
      required String schoolId,
      required String academicYr}) async {
    setState(() => _deleteButton = true);
    try {
      var resp =
          await Provider.of<UserProvider>(context, listen: false).deleteLeave(
        leaveId: leaveId,
        schoolId: schoolId,
        academicYr: academicYr,
      );
      print(resp.runtimeType);
      print('staus code-------------->${resp['status']['code']}');
      if (resp['status']['code'] == 200) {
        widget.reloadData(true);
        showSnackBar(context, resp['data']['message'], Colors.green);
      }
    } catch (e) {
      showSnackBar(context, "Something went wrong", Colors.red);
      print(e);
    }
    setState(() => _deleteButton = false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.deepPurple.shade50),
      child: _deleteButton
          ? const Center(
            child: SizedBox(
                height: 10,
                width: 10,
                child: CircularProgressIndicator(),
              ),
          )
          : TextButton(
              onPressed: () => deleteLeaveData(
                leaveId: widget.details.sId!,
                schoolId: widget.details.schoolId!,
                academicYr: widget.details.academicYear!,
              ),
              child: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
            ),
    );
  }
}
