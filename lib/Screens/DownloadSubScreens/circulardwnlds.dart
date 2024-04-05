import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../Models/Filter/filter_data.dart';
import '../../Models/Filter/filter_item.dart';
import '../../Models/downloadmodel.dart';
import '../../Services/getfiles.dart';
import '../../Util/color_util.dart';
import '../../Widgets/circulardwnldwidget.dart';
class CircularDownloads extends StatefulWidget {
  final String? studId;
  final Function(bool) loader;
  const CircularDownloads({Key? key, this.studId, required this.loader}) : super(key: key);

  @override
  State<CircularDownloads> createState() => _CircularDownloadsState();
}

class _CircularDownloadsState extends State<CircularDownloads> {
  List<DownloadModel> circlars = [];
  var _isloading = false;
  void onSelected(BuildContext context, FilterMenuItem item) {
    switch (item) {
      case FilterMenu.sortByName:
        setState((){
          circlars.sort((a,b) => a.title!.toLowerCase().compareTo(b.title!.toLowerCase()));
        });
        break;
      case FilterMenu.sortByDate:
        setState((){
          circlars.sort((a,b){
            DateTime aa = DateTime.parse("${a.date!.split('-').last}-${a.date!.split('-')[1]}-${a.date!.split('-').first}");
            DateTime bb = DateTime.parse("${b.date!.split('-').last}-${b.date!.split('-')[1]}-${b.date!.split('-').first}");
            return -1 * aa.compareTo(bb);
          });
        });
        break;
      default:
        throw Error();
    }
  }
  getCirc() async {
    setState((){
      widget.loader(true);
    });
    circlars.clear();
    circlars = await getFiles('Circular', widget.studId);
    print(circlars.length);
    setState((){
      widget.loader(false);
    });
  }

  @override
  void didChangeDependencies() {
    getCirc();
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant CircularDownloads oldWidget) {
    getCirc();
    super.didUpdateWidget(oldWidget);
  }

  // @override
  // void initState() {
  //   getCirc();
  //   // TODO: implement initState
  //   super.initState();
  // }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: ColorUtil.mainBg,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Filter',
                style: TextStyle(
                  color: Color(0xff6e6e6e),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Axiforma',
                ),
              ),
              // SizedBox(
              //   width: 5,
              // ),
              PopupMenuButton<FilterMenuItem>(
                onSelected: (item) => onSelected(context, item),
                icon: Icon(Icons.arrow_drop_down),
                itemBuilder: (context) => [
                  ...FilterMenu.theFilter.map(buildItem).toList(),
                ],
              ),
            ],
          ),
        ),
        circlars.isEmpty ?  SizedBox(
          width: 1.sw,
            height: 1.sh/2,
            child: Center(child: Text('No Downloads'))):Expanded(
          child: MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              itemBuilder: (ctx,i)=>CircularDwnldWidget(
              filePath: circlars[i].path,
              title: circlars[i].title,
              date: circlars[i].date,
              type: 'Circular',
            ),itemCount: circlars.length,),
          ),
        )
      ],

    )  ;
  }
  PopupMenuItem<FilterMenuItem> buildItem(FilterMenuItem item) =>
      PopupMenuItem<FilterMenuItem>(
        child: Text(item.text),
        value: item,
      );
}
