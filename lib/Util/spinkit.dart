import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shimmer/shimmer.dart';

final spinkit = SpinKitThreeBounce(
  size: 24,
  itemBuilder: (context, index) {
    final colors = [Colors.red, Colors.blue, Colors.green];
    final color = colors[index % colors.length];
    return DecoratedBox(
      decoration:
      BoxDecoration(color: color, borderRadius: BorderRadius.circular(15)),
    );
  },
);

final skeleton = Shimmer.fromColors(
  baseColor: Color(0xffcda4de),
  highlightColor: Color(0xffc3d0be),
  child: Container(
    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
    width: 1.sw,
    height: 100,
    decoration: BoxDecoration(
        color: Colors.grey, borderRadius: BorderRadius.circular(10)),
  ),
);

Widget timeTableSkeleton(context) {
  return Shimmer.fromColors(
      baseColor: const Color(0xffcda4de),
      highlightColor: const Color(0xffc3d0be),
      child: Column(
        children: [
          Container(
            height: 90,
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(left: 5, right: 5),
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 6,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (ctx, index) {
                return Container(
                  margin:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  width: 60,
                  // height: 30,
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(10)),
                );
              },
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 1.sh - 210,
            child: ListView.builder(
              itemCount: 8,
              padding: EdgeInsets.only(bottom: 250.h, top: 10.h),
              physics: const BouncingScrollPhysics(),
              itemBuilder: (ctx, index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  width: 1.sw,
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(10)),
                );
              },
            ),
          ),
        ],
      ));
}

Widget aflReport(context) {
  return Column(
    children: [
      Container(
        width: 1.sw,
        height: 180,
        margin: const EdgeInsets.symmetric(horizontal: 10),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        //color: Colors.red,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
                color: Color(0x24161616),
                offset: Offset(0, 7),
                blurRadius: 24,
                spreadRadius: 0)
          ],
          color: Colors.white,
        ),
        child: Shimmer.fromColors(
          baseColor: const Color(0xffcda4de),
          highlightColor: const Color(0xffc3d0be),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 150,
                    height: 70,
                    //color: Colors.red,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 70,
                          height: 70,
                          // color: Colors.green,
                          decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(20)),
                        ),
                        Container(
                          width: 70,
                          height: 70,
                          // color: Colors.green,
                          decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(20)),
                        ),
                      ],
                    ),
                  ),
                  Stack(
                    children: [
                      Container(
                        width: 1.sw / 2 - 40,
                        height: 50,
                        //color: Colors.red,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: const BoxDecoration(
                            borderRadius:
                            BorderRadius.all(Radius.circular(10)),
                            // border: Border(bottom: BorderSide(color: Colors.black26)),
                            boxShadow: [
                              BoxShadow(
                                  color: Color(0x78aeaed8),
                                  offset: Offset(0, 10),
                                  blurRadius: 32,
                                  spreadRadius: 0)
                            ],
                            color: Colors.white),
                      ),
                    ],
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Stack(
                    children: [
                      Container(
                        width: 1.sw / 2 - 40,
                        height: 50,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        // color: Colors.red,
                        decoration: const BoxDecoration(
                            borderRadius:
                            BorderRadius.all(Radius.circular(10)),
                            boxShadow: [
                              BoxShadow(
                                  color: Color(0x78aeaed8),
                                  offset: Offset(0, 10),
                                  blurRadius: 32,
                                  spreadRadius: 0)
                            ],
                            color: Colors.white),
                      ),
                    ],
                  ),
                  Container(
                    width: 1.sw / 2 - 40,
                    height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    //color: Colors.red,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        boxShadow: [
                          BoxShadow(
                              color: Color(0x78aeaed8),
                              offset: Offset(0, 10),
                              blurRadius: 32,
                              spreadRadius: 0)
                        ],
                        color: Colors.white),
                  )
                ],
              )
            ],
          ),
        ),
      ),
      // SizedBox(
      //   width: MediaQuery.of(context).size.width,
      //   height: MediaQuery.of(context).size.height,
      //   child: ListView.builder(
      //     itemCount: 8,
      //     padding: EdgeInsets.only(bottom: 250.h, top: 10.h),
      //     physics: const BouncingScrollPhysics(),
      //     itemBuilder: (ctx, index) {
      //       return Container(
      //         margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      //         width: 1.sw,
      //         height: 100,
      //         decoration: BoxDecoration(
      //             color: Colors.grey,
      //             borderRadius: BorderRadius.circular(10)),
      //       );
      //     },
      //   ),
      // ),
    ],
  );
}