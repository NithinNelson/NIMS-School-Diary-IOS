import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class ApplyLeaveFloatButton extends StatefulWidget {
  final Function(int) pageUpdate;
  final Animation<Size>? heightanimation;
  final Animation<Size>? buttonText;
  final bool isButtonExpand;
  const ApplyLeaveFloatButton({super.key, required this.pageUpdate, required this.heightanimation, required this.buttonText, required this.isButtonExpand});

  @override
  State<ApplyLeaveFloatButton> createState() => _ApplyLeaveFloatButtonState();
}

class _ApplyLeaveFloatButtonState extends State<ApplyLeaveFloatButton> with TickerProviderStateMixin {
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.pageUpdate(12);
      },
      child: Container(
        width: widget.heightanimation!.value.width,
        height: widget.heightanimation!.value.height,
        decoration: BoxDecoration(
            color: Colors.deepPurple.shade300,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                offset: Offset(1, 3),
                blurRadius: 5,
              ),
            ]
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              "assets/images/leave-request.svg",
              width: 25.w,
              colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            ),
            if(widget.isButtonExpand)
              SizedBox(width: 3.w),
            SizedBox(
              width: widget.buttonText!.value.width,
              height: 40.h,
              child: const Center(
                child: Text(
                  "Leave",
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: "Gotham",
                      overflow: TextOverflow.fade
                  ),
                  maxLines: 1,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
