import 'dart:io';

import 'package:SomanyHIL/model/inspection_detail.dart';
import 'package:SomanyHIL/rest/eightfolds_retrofit.dart';
import 'package:SomanyHIL/screens/dialog_remove_image.dart';
import 'package:SomanyHIL/screens/photo_expanded_screen.dart';
import 'package:SomanyHIL/style/colors.dart';
import 'package:SomanyHIL/style/text_style.dart';
import 'package:SomanyHIL/utils/constants.dart';
import 'package:SomanyHIL/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class CapturedImages extends StatefulWidget {
  final List<String> imageList;
  final int index;
  final List<InspectionDetail> inspectionList;
  final Function callBack;
  final bool readOnly;

  CapturedImages(this.imageList, this.index, this.inspectionList, this.callBack,
      this.readOnly);

  @override
  _CapturedImagesState createState() => _CapturedImagesState();
}

class _CapturedImagesState extends State<CapturedImages> {
  InspectionDetail inspectionDetail;
  @override
  void initState() {
    super.initState();
    inspectionDetail = widget.inspectionList[widget.index];
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('Length ${widget.imageList.length}');
    return SafeArea(
        child: Scaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColor.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: AppColor.textBlack,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Captured image's",
              style: AppTextStyle.blackRubikMedium16,
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: GridView.builder(
          itemBuilder: (context, position) {
            return InkWell(
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                child: Container(
                  width: double.maxFinite,
                  height: double.maxFinite,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: widget.imageList[position].contains('/')
                            ? Image.file(
                                File(widget.imageList[position]),
                                width: double.maxFinite,
                                height: double.maxFinite,
                                fit: BoxFit.cover,
                              )
                            : CachedNetworkImage(
                                width: double.maxFinite,
                                height: double.maxFinite,
                                imageUrl:
                                    EightFoldsRetrofit.GET_CAPTURED_FILE_URL +
                                        widget.imageList[position],
                                cacheManager: DefaultCacheManager(),
                                fit: BoxFit.cover,
                                placeholder: (_, _1) => Image.asset(
                                  Constants.ref_image,
                                  width: double.maxFinite,
                                  height: double.maxFinite,
                                ),
                                errorWidget: (context, url, error) =>
                                    Image.asset(
                                  Constants.ref_image,
                                  width: 87,
                                  height: 87,
                                ),
                              ),
                      ),
                      // if (!widget.readOnly)
                      Align(
                        alignment: Alignment.topRight,
                        child: InkWell(
                          child: Container(
                            width: 20,
                            height: 20,
                            margin: EdgeInsets.symmetric(
                                horizontal: 6, vertical: 6),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle, color: Colors.black54),
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.close,
                              size: 10,
                              color: Colors.white,
                            ),
                          ),
                          onTap: () {
                            Utils.hideKeyBoard(context);
                            showDialog(
                                context: context,
                                useSafeArea: true,
                                builder: (_) {
                                  return DialogRemoveImage(
                                    callBack: () {
                                      widget.imageList
                                          .remove(widget.imageList[position]);
                                      inspectionDetail.capturedImages =
                                          widget.imageList;
                                      setState(() {});
                                      widget
                                          .callBack(Constants.SAVE_INSPACTION);
                                    },
                                  );
                                });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ExpandedImageView(
                              image: widget.imageList[position],
                              refImage: false,
                            )));
              },
            );
          },
          itemCount: widget.imageList.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
        ),
      ),
    ));
  }
}
