import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Provider/user_provider.dart';
import '../Util/color_util.dart';
import '../Util/custom_paint/fee_paid_card.dart';

class ReceiptSendingScreen extends StatefulWidget {
  final String? voucherNo;
  final String? token;
  final List<dynamic>? detailList;
  final String? totalAmount;
  final String? admsnNo;
  final String? transactionDate;
  const ReceiptSendingScreen({super.key, this.voucherNo, this.token, this.detailList, this.totalAmount, this.admsnNo, this.transactionDate});

  @override
  State<ReceiptSendingScreen> createState() => _ReceiptSendingScreenState();
}

class _ReceiptSendingScreenState extends State<ReceiptSendingScreen> {
  TextEditingController _emailController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _saveKeyboard();
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

  @override
  void dispose() {
    _removeKeyboard();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorUtil.mainBg,
      appBar: AppBar(
        title: const Text("Send Receipt"),
        centerTitle: true,
        elevation: 1,
        // backgroundColor: ColorUtil.mainBg,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(20),
                bottomLeft: Radius.circular(20))),
        flexibleSpace: ClipRRect(
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20)),
          child: Image.asset(
            "assets/images/appbar.png",
            fit: BoxFit.cover,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            Stack(
              alignment: Alignment.topCenter,
              children: [
                // Container(
                //   width: double.infinity,
                //   height: double.infinity,
                // ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(top: 80),
                  // padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.08, left: 16.0, right: 16.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.08, left: 16.0, right: 16.0),
                    child: Column(
                      children: [
                        Container(
                          width: 1.sw,
                          height: 60 *
                              double.parse(widget.detailList!.length.toString()) +
                              50,
                          child: Stack(
                            children: [
                              Positioned(
                                top: 10,
                                right: 0,
                                left: 0,
                                child: DottedBorder(
                                    borderType: BorderType.RRect,
                                    color: ColorUtil.paidBor,
                                    radius: Radius.circular(12),
                                    child: Table(
                                      columnWidths: {
                                        0: FlexColumnWidth(5),
                                        1: FlexColumnWidth(1),
                                        2: FlexColumnWidth(2),
                                      },
                                      children: [
                                        // ...widget.detailList!.map((e) => TableRow(
                                        //   children: [
                                        //     Text('${e['transaction_desc']}'),
                                        //     Text(':'),
                                        //     Text('${e['transaction_amount']}')
                                        //   ]
                                        // )).toList()
                                        ...widget.detailList!
                                            .asMap()
                                            .map((index, element) => MapEntry(
                                            index,
                                            TableRow(
                                                decoration: BoxDecoration(
                                                    color: (index % 2 == 0)
                                                        ? Colors.transparent
                                                        : ColorUtil.paidBor
                                                        .withOpacity(0.2)),
                                                children: [
                                                  Container(
                                                    constraints: BoxConstraints(
                                                        minHeight: 60),
                                                    padding:
                                                    EdgeInsets.only(left: 10),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .center,
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .start,
                                                      children: [
                                                        Text(
                                                          '${element['transaction_desc']}',
                                                          textScaleFactor: 0.75,
                                                          style: feeListStyle(),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    constraints: BoxConstraints(
                                                        minHeight: 60),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .center,
                                                      children: [
                                                        Text(
                                                          ':',
                                                          textScaleFactor: 0.75,
                                                          style: feeListStyle(),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    constraints: BoxConstraints(
                                                        minHeight: 60),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .center,
                                                      children: [
                                                        Text(
                                                          'AED ${element['transaction_amount']}',
                                                          textScaleFactor: 0.75,
                                                          //maxLines: 2,
                                                          style: feeListStyle(),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ])))
                                            .values
                                            .toList()
                                      ],
                                    )),
                              ),
                              Positioned(
                                top: 1,
                                left: 18,
                                child: Container(
                                  width: 80,
                                  color: Colors.white,
                                  child: Center(
                                      child: Text(
                                        'Particulars',
                                        textScaleFactor: 0.9,
                                      )),
                                ),
                              ),
                            ],
                          ),
                        ),
                        DottedBorder(
                            borderType: BorderType.RRect,
                            radius: Radius.circular(12),
                            color: ColorUtil.feegreen,
                            child: Container(
                              //margin: EdgeInsets.all(8),
                              width: 1.sw,
                              // height: 60,
                              child: Table(
                                columnWidths: {
                                  0: FlexColumnWidth(2),
                                  1: FlexColumnWidth(1),
                                  2: FlexColumnWidth(2),
                                },
                                children: [
                                  TableRow(children: [
                                    Container(
                                      constraints: BoxConstraints(minHeight: 60),
                                      padding: EdgeInsets.only(left: 10),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Grand Total',
                                            textScaleFactor: 1.0,
                                            style: feeTotalStyle(),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      constraints: BoxConstraints(minHeight: 60),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            ':',
                                            style: feeTotalStyle(),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      constraints: BoxConstraints(minHeight: 60),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'AED ${widget.totalAmount!}',
                                            textScaleFactor: 1.0,
                                            style: feeTotalStyle(),
                                          ),
                                        ],
                                      ),
                                    )
                                  ])
                                ],
                              ),
                            )),
                        const SizedBox(height: 20),
                        // Flexible(flex: 3, child: Container()),
                        Form(
                          key: _globalKey,
                          child: TextFormField(
                            controller: _emailController,
                            focusNode: _focusNode,
                            decoration: InputDecoration(
                              hintText: "Enter Email",
                              filled: true,
                              hintStyle: const TextStyle(
                                  color: Colors.black26, fontSize: 15),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: ColorUtil.deepPurple),
                                  borderRadius: BorderRadius.circular(20)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: ColorUtil.deepPurple),
                                  borderRadius: BorderRadius.circular(20)),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: ColorUtil.deepPurple),
                                  borderRadius: BorderRadius.circular(20)),
                              errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: ColorUtil.deepPurple),
                                  borderRadius: BorderRadius.circular(20)),
                              disabledBorder: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 0),
                              prefixIcon: Icon(Icons.mail_outline, color: ColorUtil.deepPurple, size: 20.sp,),
                            ),
                            style: const TextStyle(
                                fontSize: 16, color: Colors.black),
                            onChanged: (value) {},
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter an email address.';
                              }
                              const emailRegex = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,5}$';
                              if (!RegExp(emailRegex).hasMatch(value)) {
                                return 'Please enter a valid email address.';
                              }
                              return null;
                            },
                          ),
                        ),
                        // Flexible(flex: 1, child: Container()),
                        InkWell(
                          onTap: () {
                            if (_globalKey.currentState!.validate()) {
                              _generateReceipt(_emailController.text, widget.admsnNo!,
                                  widget.voucherNo!, widget.token!);
                              _focusNode.unfocus();
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20, bottom: 20),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: ColorUtil.feegreen,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 5, bottom: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.mail_outline, color: Colors.white, size: 20.sp,),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      'Send',
                                      textScaleFactor: 0.95,
                                      style: TextStyle(color: Colors.white),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        // Flexible(flex: 5, child: Container()),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.15,
                  child: CustomPaint(
                    painter: DrawPaint(),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 30),
                      child: Row(
                        children: [
                          Flexible(flex: 1, child: Container()),
                          leftPart(date: widget.transactionDate!),
                          Flexible(flex: 8, child: Container()),
                          Row(
                            children: [
                              rightPart(
                                  rcptNo: widget.voucherNo,
                                  totalPaid: widget.totalAmount,
                                  traDate: widget.transactionDate),
                            ],
                          ),
                          Flexible(flex: 1, child: Container()),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  feeListStyle() => TextStyle(
      color: ColorUtil.paidBor,
      fontWeight: FontWeight.w400,
      fontFamily: "Axiforma",
      fontStyle: FontStyle.normal,
      fontSize: 14);
  feeTotalStyle() => TextStyle(
      color: ColorUtil.feegreen,
      fontWeight: FontWeight.w700,
      fontFamily: "Axiforma",
      fontStyle: FontStyle.normal,
      fontSize: 14);

  Widget leftPart({required String date}) => Text(
    '${DateFormat('MMM').format(DateTime.parse('${date.split('-').last}-${date.split('-')[1]}-${date.split('-').first}')).toString().toUpperCase()}',
    style: TextStyle(
        color: Colors.white,
        fontSize: 18.sp,
        fontFamily: 'Axiforma',
        fontWeight: FontWeight.w700),
  );

  Widget rightPart({String? rcptNo, String? totalPaid, String? traDate}) =>
      Column(
        children: [
          Flexible(flex: 1, child: Container()),
          Container(
            width: 170,
            height: 25,
            // margin: EdgeInsets.only(bottom: 10),
            // padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
                color: Color(0xff5558ff).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 5,
                ),
                Text(
                  'Receipt No.',
                  textScaleFactor: 0.95,
                  style: receiptTextStyle(),
                ),
                // SizedBox(
                //   width: 5,
                // ),
                Text(
                  ':',
                  style: receiptTextStyle(),
                  textScaleFactor: 0.95,
                ),
                // SizedBox(
                //   width: 5,
                // ),
                Text(
                  rcptNo!,
                  textScaleFactor: 0.95,
                  style: receiptTextStyle(),
                ),
                SizedBox(
                  width: 5,
                ),
              ],
            ),
          ),
          Flexible(flex: 1, child: Container()),
          Container(
            width: 170,
            height: 25,
            // margin: EdgeInsets.only(bottom: 10),
            //padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(15)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Icons.payments_outlined,
                  color: Color(0xff6e6e6e),
                ),
                Text(
                  'Total Paid',
                  textScaleFactor: 0.95,
                  style: transactionStyle(),
                ),
                Text(
                  ':',
                  style: transactionStyle(),
                  textScaleFactor: 0.95,
                ),
                Text(
                  'AED $totalPaid',
                  textScaleFactor: 0.95,
                  style: TextStyle(
                      color: Color(0xff26de81),
                      fontWeight: FontWeight.w700,
                      fontFamily: "Axiforma",
                      fontSize: 11.sp),
                ),
                // Icon(Icons.arrow_drop_down)
              ],
            ),
          ),
          Flexible(flex: 1, child: Container()),
          Container(
            width: 170,
            height: 25,
            // margin: EdgeInsets.only(bottom: 15),
            //padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(15)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Icons.calendar_month_outlined,
                  color: Color(0xff6e6e6e),
                ),
                Text(
                  'Paid On',
                  textScaleFactor: 0.95,
                  style: transactionStyle(),
                ),
                Text(
                  ':',
                  style: transactionStyle(),
                  textScaleFactor: 0.95,
                ),
                Text(
                  '${DateFormat('dd MMM yyyy').format(DateTime.parse('${traDate!.split('-').last}-${traDate.split('-')[1]}-${traDate.split('-').first}'))}',
                  textScaleFactor: 0.95,
                  style: transactionStyle(),
                )
              ],
            ),
          ),
          Flexible(flex: 1, child: Container()),
        ],
      );

  receiptTextStyle() => TextStyle(
    fontFamily: 'Axiforma',
    color: Color(0xff5558ff),
    fontSize: 10.sp,
    fontWeight: FontWeight.w400,
  );
  transactionStyle() => TextStyle(
      color: const Color(0xff6e6e6e),
      fontWeight: FontWeight.w400,
      fontFamily: "Axiforma",
      fontSize: 12);

  _generateReceipt(
      String parentEmail, String admnNo, String voucher, String token) async {
    try {
      setState(() {
        //_isloading = true;
      });
      var resp = await Provider.of<UserProvider>(context, listen: false)
          .getReceipt(parentEmail, admnNo, voucher, token);
      print(resp);
      print('staus code-------------->${resp['message']}');
      _showToast(context, resp['message'], Colors.red);
      if (resp['status']['code'] == 200) {
        setState(() {
          //_isloading = false;
        });
      } else if (resp['status']['code'] == 400) {
        setState(() {
          //_isloading = false;
        });
      } else {
        setState(() {
          // _isloading = false;
        });
      }
    } catch (e) {}
  }

  void _showToast(BuildContext context, String errText, Color color) {
    //final scaffold = Scaffold.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errText),
        backgroundColor: color,
        margin: EdgeInsets.all(8),
        behavior: SnackBarBehavior.floating,
      ),
    );
    // scaffold.showSnackBar(
    //   SnackBar(
    //     content: Text(errText),
    //     backgroundColor: color,
    //     margin: EdgeInsets.all(8),
    //     behavior: SnackBarBehavior.floating,
    //   ),
    // );
  }
}
