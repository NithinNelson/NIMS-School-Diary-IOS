import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
import '../Models/Filter/filter_data.dart';
import '../Models/Filter/filter_item.dart';
import '../Util/color_util.dart';
import '../Util/spinkit.dart';
import 'DownloadSubScreens/academicdwnlds.dart';
import 'DownloadSubScreens/circulardwnlds.dart';
import 'DownloadSubScreens/examdwnlds.dart';

class DownloadScreen extends StatefulWidget {
  final String? studId;
  const DownloadScreen({Key? key, this.studId}) : super(key: key);

  @override
  State<DownloadScreen> createState() => _DownloadScreenState();
}

class _DownloadScreenState extends State<DownloadScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _loader = false;

  void onSelected(BuildContext context, FilterMenuItem item) {
    switch (item) {
      case FilterMenu.sortByName:
        print('sort by name');
        break;
      case FilterMenu.sortByDate:
        print('sort by date');
        break;
      default:
        throw Error();
    }
  }

  @override
  void didChangeDependencies() {
    _tabController = TabController(length: 3, vsync: this);
    requestPermission();
    super.didChangeDependencies();
  }

  requestPermission() async {
    if (await Permission.storage.status.isDenied) {
      await Permission.storage.request();
    }
  }

  // @override
  // void didUpdateWidget(covariant DownloadScreen oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  // }

  // @override
  // void initState() {
  //   _tabController = TabController(length: 3, vsync: this);
  //   super.initState();
  // }

  @override
  void dispose() {
    if (_tabController.index >= 0 && _tabController.indexIsChanging) {
      _tabController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.sw,
      height: 1.sh - 120,
      color: ColorUtil.mainBg,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 10),
            width: 1.sw,
            height: 40,
            //margin: EdgeInsets.symmetric(vertical: 10),
            //margin: EdgeInsets.only(top: 15),
            padding: EdgeInsets.symmetric(horizontal: 10),
            color: ColorUtil.mainBg,
            child: TabBar(
              controller: _tabController,
              //isScrollable: true,
              labelColor: Colors.white,
              labelStyle: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
                fontFamily: 'Axiforma',
              ),
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Color(0xff25dbdc),
              ),
              //indicatorColor: Colors.white,
              // indicatorSize: TabBarIndicatorSize.tab,
              unselectedLabelColor: Color(0xFF414D55).withOpacity(0.36),
              tabs: [
                Tab(
                  text: 'Circular',
                ),
                Tab(
                  text: 'Academic',
                ),
                Tab(
                  text: 'Exam',
                )
              ],
            ),
          ),
          // Container(
          //   color: Colors.grey.shade200,
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.end,
          //     children: [
          //       Text(
          //         'Filter',
          //         style: TextStyle(
          //           color: Color(0xff6e6e6e),
          //           fontSize: 12.sp,
          //           fontWeight: FontWeight.w400,
          //           fontFamily: 'Axiforma',
          //         ),
          //       ),
          //       SizedBox(
          //         width: 5,
          //       ),
          //       PopupMenuButton<FilterMenuItem>(
          //         onSelected: (item) => onSelected(context, item),
          //         icon: Icon(Icons.arrow_drop_down),
          //         itemBuilder: (context) => [
          //           ...FilterMenu.theFilter.map(buildItem).toList(),
          //         ],
          //       ),
          //     ],
          //   ),
          // ),
          _loader
              ? Container(
                  width: 1.sw,
                  height: 1.sh - 200,
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(bottom: 40),
                    itemCount: 10,
                    itemBuilder: (context, index) => skeleton,
                  ),
                )
              : Container(
                  width: 1.sw,
                  height: 1.sh - 230,
                  padding: const EdgeInsets.only(bottom: 20),
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      CircularDownloads(
                        studId: widget.studId,
                        loader: (newValue) => _loader = newValue,
                      ),
                      AcademicDownloads(
                        studId: widget.studId,
                        loader: (newValue) => _loader = newValue,
                      ),
                      ExamDownloads(
                        studId: widget.studId,
                        loader: (newValue) => _loader = newValue,
                      )
                    ],
                  ),
                )
        ],
      ),
    );
  }

  PopupMenuItem<FilterMenuItem> buildItem(FilterMenuItem item) =>
      PopupMenuItem<FilterMenuItem>(
        child: Text(item.text),
        value: item,
      );
}
