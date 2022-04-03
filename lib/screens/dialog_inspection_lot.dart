import 'dart:io';

import 'package:SomanyHIL/mixin/e_dimension.dart';
import 'package:SomanyHIL/model/inspection_detail.dart';
import 'package:SomanyHIL/rest/eightfolds_retrofit.dart';
import 'package:SomanyHIL/screens/dialog_remove_image.dart';
import 'package:SomanyHIL/screens/photo_expanded_screen.dart';
import 'package:SomanyHIL/screens/captured_images_screen.dart';
import 'package:SomanyHIL/style/colors.dart';
import 'package:SomanyHIL/style/text_style.dart';
import 'package:SomanyHIL/utils/constants.dart';
import 'package:SomanyHIL/utils/e_image.dart';
import 'package:SomanyHIL/utils/slide_transitions.dart';
import 'package:SomanyHIL/utils/ui_utils.dart';
import 'package:SomanyHIL/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class DialogInspectionLot extends StatefulWidget {
  final int index;
  final List<InspectionDetail> inspectionList;
  final Function callBack;
  final bool readOnly;
  final bool isHistory;

  const DialogInspectionLot(
      {Key key,
      this.index,
      this.inspectionList,
      this.callBack,
      this.readOnly,
      this.isHistory = false})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _DialogInspectionLotState();
}

class _DialogInspectionLotState extends State<DialogInspectionLot>
    with EDimension, EImage {
  TextEditingController resultController = TextEditingController();

  TextEditingController commentController = TextEditingController();
  List<InspectionDetail> list = [];
  List<String> imageList = [];
  int currentPage = 0;
  InspectionDetail inspectionDetail;
  ItemScrollController _scrollController = ItemScrollController();
  ScrollController _scrollController1 = ScrollController();
  bool modified = false;
  int imageViewLimit = 4;
  int imageCapturedLimit = 100;
  int decision;

  @override
  void initState() {
    super.initState();
    list = widget.inspectionList;
    currentPage = widget.index;
    inspectionDetail = list[currentPage];
    debugPrint('inspectionDetail: ${inspectionDetail.toJson()}');
    // var count = inspectionDetail.noOfMeasurements ?? 0;
    // if (count > 0) {
    //   inspectionDetail.type = Constants.INSPECTION_TYPE_QUANTITATIVE;
    // }
    // if (inspectionDetail.capturedImages == null) {
    //   inspectionDetail.capturedImages = [];
    // }
    // if (inspectionDetail.quantitativeResult == null) {
    //   inspectionDetail.quantitativeResult = [];
    //   inspectionDetail.quantitativeResult.length =
    //       inspectionDetail.noOfMeasurements ?? 0;
    // }
    // imageList = inspectionDetail.capturedImages ?? [];
    // resultController.text = inspectionDetail?.result ?? '';
    // commentController.text = inspectionDetail?.remarks ?? '';

    reinitState(inspectionDetail);
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('Image URL: ${inspectionDetail.referenceImage}');
    return SafeArea(
        child: Scaffold(
      backgroundColor: AppColor.textBlack.withOpacity(0.9),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        width: double.maxFinite,
        child: Stack(
          fit: StackFit.expand,
          children: [
            FractionallySizedBox(
              alignment: Alignment.topCenter,
              heightFactor: 0.92,
              child: Container(
                child: Card(
                  color: AppColor.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16))),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          icon: Icon(
                            Icons.close,
                            size: 20,
                          ),
                          color: AppColor.textBlack,
                          iconSize: 20,
                          constraints: BoxConstraints(),
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      Expanded(
                          child: SingleChildScrollView(
                        controller: _scrollController1,
                        padding:
                            EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Charac. no.',
                                        style: AppTextStyle.greyRubik13,
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "${inspectionDetail.characNo} ${inspectionDetail.shortDesc}" ??
                                            '',
                                        style: AppTextStyle.blackRubik14,
                                      ),
                                    ],
                                  ),
                                ),
                                if ((inspectionDetail?.specification ?? '')
                                    .isNotEmpty)
                                  SizedBox(
                                    width: 20,
                                  ),
                                if ((inspectionDetail?.specification ?? '')
                                    .isNotEmpty)
                                  Expanded(
                                      child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        'Specification',
                                        style: AppTextStyle.greyRubik13,
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        inspectionDetail.specification ?? '',
                                        style: AppTextStyle.blackRubik14,
                                      ),
                                    ],
                                  )),
                              ],
                            ),
                            /*Text(
                              'Charac. no.',
                              style: AppTextStyle.greyRubik13,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              inspectionDetail != null &&
                                      inspectionDetail.characNo != null
                                  ? inspectionDetail.characNo
                                  : "",
                              style: AppTextStyle.blackRubik14,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              'Specifications',
                              style: AppTextStyle.greyRubik13,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              inspectionDetail != null &&
                                      inspectionDetail.specification != null
                                  ? inspectionDetail.specification
                                  : "",
                              style: AppTextStyle.blackRubik14,
                            ),*/
                            if (inspectionDetail.showResult())
                              SizedBox(
                                height: 18,
                              ),
                            if (inspectionDetail.showResult())
                              Text(
                                'Result',
                                style: AppTextStyle.greyRubik13,
                              ),
                            if (inspectionDetail.showResult())
                              if (widget.isHistory ||
                                  (inspectionDetail.type == null ||
                                      (inspectionDetail.type != null &&
                                          inspectionDetail.type !=
                                              Constants
                                                  .INSPECTION_TYPE_QUANTITATIVE)))
                                Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(12.0),
                                      filled: true,
                                      hintText: 'Result',
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: inspectionDetail
                                                      .validateResult()
                                                  ? AppColor.red
                                                      .withOpacity(0.8)
                                                  : AppColor.dividerColor,
                                              width: 1.0),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: inspectionDetail
                                                      .validateResult()
                                                  ? AppColor.red
                                                      .withOpacity(0.8)
                                                  : AppColor.dividerColor,
                                              width: 1.0),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: inspectionDetail
                                                      .validateResult()
                                                  ? AppColor.red
                                                      .withOpacity(0.8)
                                                  : AppColor.dividerColor,
                                              width: 1.0),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      fillColor: AppColor.white,
                                      hintStyle: AppTextStyle.textHintStyle,
                                    ),
                                    readOnly: widget.readOnly,
                                    showCursor: true,
                                    autofocus: false,
                                    cursorColor: AppColor.textBlack,
                                    style: AppTextStyle.textFieldStyle,
                                    controller: resultController,
                                    textInputAction: TextInputAction.done,
                                    keyboardType:
                                        inspectionDetail.isAlphaNumeric()
                                            ? TextInputType.text
                                            : TextInputType.numberWithOptions(
                                                decimal: true),
                                    inputFormatters: inspectionDetail
                                            .isAlphaNumeric()
                                        ? [
                                            FilteringTextInputFormatter.allow(
                                                RegExp("[A-Za-z0-9#+-_@. ]*")),
                                          ]
                                        : [
                                            FilteringTextInputFormatter.allow(
                                                RegExp("[0-9.]*")),
                                          ],
                                    onChanged: (text) {
                                      debugPrint("Text Change Called");
                                      setState(() {
                                        modified = true;
                                        inspectionDetail?.result = text;
                                      });
                                    },
                                  ),
                                ),
                            if (inspectionDetail.showResult())
                              if (!widget.isHistory &&
                                  inspectionDetail.type != null &&
                                  inspectionDetail.type ==
                                      Constants.INSPECTION_TYPE_QUANTITATIVE)
                                for (int i = 0;
                                    i <
                                        inspectionDetail
                                            .quantitativeResult.length;
                                    i++)
                                  getQuantResult(i,
                                      inspectionDetail.quantitativeResult[i]),
                            SizedBox(
                              height: 12,
                            ),
                            if (inspectionDetail?.isReferenceImageAvailable() ??
                                false)
                              Divider(
                                color: AppColor.grey,
                              ),
                            SizedBox(
                              height: 4,
                            ),
                            if (inspectionDetail?.isReferenceImageAvailable() ??
                                false)
                              Text(
                                'Reference image',
                                style: AppTextStyle.blackRubikMedium16,
                              ),
                            if (inspectionDetail?.isReferenceImageAvailable() ??
                                false)
                              SizedBox(
                                height: 10,
                              ),
                            if (inspectionDetail?.isReferenceImageAvailable() ??
                                false)
                              InkWell(
                                child: CachedNetworkImage(
                                  imageUrl: EightFoldsRetrofit
                                          .GET_REFERENCE_FILE_URL +
                                      inspectionDetail.referenceImage,
                                  // imageUrl: inspectionDetail.referenceImage,
                                  cacheManager: DefaultCacheManager(),
                                  fit: BoxFit.fill,
                                  width: double.infinity,
                                  // height: 87,
                                  placeholder: (_, _1) => Align(
                                    alignment: Alignment.topLeft,
                                    child: Image.asset(
                                      Constants.ref_image,
                                      fit: BoxFit.fill,
                                      width: 87,
                                      height: 87,
                                    ),
                                  ),
                                  errorWidget: (context, url, error) => Align(
                                    alignment: Alignment.topLeft,
                                    child: Image.asset(
                                      Constants.ref_image,
                                      fit: BoxFit.fill,
                                      width: 87,
                                      height: 87,
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ExpandedImageView(
                                                image: inspectionDetail
                                                        ?.referenceImage ??
                                                    '',
                                                refImage: true,
                                              )));
                                },
                              ),
                            SizedBox(
                              height: 20,
                            ),
                            if ((!widget.readOnly || imageList.length > 0) &&
                                (inspectionDetail
                                        ?.isReferenceImageAvailable() ??
                                    false))
                              Text(
                                "Captured image's",
                                style: AppTextStyle.blackRubikMedium16,
                              ),
                            if (inspectionDetail?.isReferenceImageAvailable() ??
                                false)
                              GridView.count(
                                shrinkWrap: true,
                                padding:
                                    const EdgeInsets.fromLTRB(0, 10, 4, 20),
                                physics: NeverScrollableScrollPhysics(),
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                                crossAxisCount: 3,
                                childAspectRatio: (1 / 1),
                                children: <Widget>[
                                  if (!widget.readOnly)
                                    InkWell(
                                      onTap: () {
                                        Utils.hideKeyBoard(context);
                                        if (imageList.length <
                                            imageCapturedLimit) {
                                          captureImage();
                                        } else {
                                          UiUtils.showMyToast(
                                              message:
                                                  'Maximum $imageCapturedLimit images allowed');
                                        }
                                      },
                                      child: Container(
                                        width: double.maxFinite,
                                        height: double.maxFinite,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(12)),
                                            color: Color(0xffB0B3BA)
                                                .withOpacity(0.1)),
                                        alignment: Alignment.center,
                                        child: Icon(
                                          Icons.camera_alt,
                                          color: AppColor.textBlack,
                                          size: 40,
                                        ),
                                      ),
                                    ),
                                  if (imageList.length > 0)
                                    for (int i = 0;
                                        i <
                                            (imageList.length > imageViewLimit
                                                ? imageViewLimit
                                                : imageList.length);
                                        i++)
                                      InkWell(
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(12)),
                                          child: Container(
                                            width: double.maxFinite,
                                            height: double.maxFinite,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(12)),
                                            ),
                                            child: Stack(
                                              children: [
                                                Align(
                                                  alignment:
                                                      Alignment.topCenter,
                                                  child: imageList[i]
                                                          .contains('/')
                                                      ? Image.file(
                                                          File(imageList[i]),
                                                          width:
                                                              double.maxFinite,
                                                          height:
                                                              double.maxFinite,
                                                          fit: BoxFit.cover,
                                                        )
                                                      : CachedNetworkImage(
                                                          width:
                                                              double.maxFinite,
                                                          height:
                                                              double.maxFinite,
                                                          imageUrl:
                                                              EightFoldsRetrofit
                                                                      .GET_CAPTURED_FILE_URL +
                                                                  imageList[i],
                                                          cacheManager:
                                                              DefaultCacheManager(),
                                                          fit: BoxFit.cover,
                                                          placeholder:
                                                              (_, _1) =>
                                                                  Image.asset(
                                                            Constants.ref_image,
                                                            width: double
                                                                .maxFinite,
                                                            height: double
                                                                .maxFinite,
                                                          ),
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              Image.asset(
                                                            Constants.ref_image,
                                                            width: 87,
                                                            height: 87,
                                                          ),
                                                        ),
                                                ),
                                                if (!widget.readOnly)
                                                  Align(
                                                    alignment:
                                                        Alignment.topRight,
                                                    child: InkWell(
                                                      child: Container(
                                                        width: 20,
                                                        height: 20,
                                                        margin: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 6,
                                                                vertical: 6),
                                                        decoration:
                                                            BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                color: Colors
                                                                    .black54),
                                                        alignment:
                                                            Alignment.center,
                                                        child: Icon(
                                                          Icons.close,
                                                          size: 10,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                      onTap: () {
                                                        Utils.hideKeyBoard(
                                                            context);
                                                        showDialog(
                                                            context: context,
                                                            useSafeArea: true,
                                                            builder: (_) {
                                                              return DialogRemoveImage(
                                                                callBack: () {
                                                                  imageList.remove(
                                                                      imageList[
                                                                          i]);
                                                                  inspectionDetail
                                                                          .capturedImages =
                                                                      imageList;
                                                                  setState(() {
                                                                    modified =
                                                                        true;
                                                                  });
                                                                  widget.callBack(
                                                                      Constants
                                                                          .SAVE_INSPACTION);
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
                                                  builder: (context) =>
                                                      ExpandedImageView(
                                                        image: imageList[i],
                                                        refImage: false,
                                                      )));
                                        },
                                      ),
                                  if (!widget.readOnly &&
                                      imageList.length > imageViewLimit)
                                    InkWell(
                                      onTap: () {
                                        Utils.hideKeyBoard(context);
                                        Navigator.push(
                                                context,
                                                SlideLeftRoute(
                                                    page: CapturedImages(
                                                        imageList,
                                                        widget.index,
                                                        widget.inspectionList,
                                                        widget.callBack,
                                                        widget.readOnly)))
                                            .then((value) => setState(() {}));
                                      },
                                      child: Container(
                                        width: double.maxFinite,
                                        height: double.maxFinite,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(12)),
                                            color: Color(0xffB0B3BA)
                                                .withOpacity(0.1)),
                                        alignment: Alignment.center,
                                        child: SvgPicture.asset(
                                          Constants.more,
                                          width: 45,
                                          height: 45,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            if (decision == 2)
                              SizedBox(
                                height: 38,
                              ),
                            if (decision == 2)
                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.all(12.0),
                                        filled: true,
                                        hintText: 'Comment',
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: AppColor.dividerColor,
                                                width: 1.0),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: AppColor.dividerColor,
                                                width: 1.0),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: AppColor.dividerColor,
                                                width: 1.0),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                        fillColor: AppColor.white,
                                        hintStyle: AppTextStyle.textHintStyle,
                                      ),
                                      readOnly: widget.readOnly,
                                      showCursor: true,
                                      autofocus: false,
                                      cursorColor: AppColor.textBlack,
                                      style: AppTextStyle.textFieldStyle,
                                      controller: commentController,
                                      textInputAction: TextInputAction.done,
                                      keyboardType: TextInputType.text,
                                      textCapitalization:
                                          TextCapitalization.sentences,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                            RegExp("[A-Za-z0-9#+-_@. ]*")),
                                      ],
                                      onChanged: (text) {
                                        setState(() {
                                          modified = true;
                                          inspectionDetail?.remarks = text;
                                        });
                                      },
                                    ),
                                  ),
                                  /* SizedBox(
                                                                          width: 10,
                                                                        ),
                                                                        IconButton(
                                                                            icon: SvgPicture.asset(
                                                                              Constants.upload,
                                                                              width: 36,
                                                                              height: 36,
                                                                            ),
                                                                            onPressed: () {})*/
                                ],
                              ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              child: null,
                            ),
                          ],
                        ),
                      )),
                      /* Padding(
                                                                padding:
                                                                    EdgeInsets.symmetric(horizontal: 25, vertical: 16),
                                                                child: Row(
                                                                  children: [
                                                                    Expanded(
                                                                        child: RaisedButton(
                                                                      onPressed: () {
                                                                        Utils.hideKeyBoard(context);
                                                                        setState(() {
                                                                          inspectionDetail.decision = 1;
                                                                        });
                                                                      },
                                                                      padding: const EdgeInsets.all(0.0),
                                                                      splashColor: Colors.black38,
                                                                      shape: RoundedRectangleBorder(
                                                                          borderRadius: BorderRadius.circular(10.0)),
                                                                      child: Ink(
                                                                        decoration: inspectionDetail?.decision == 1
                                                                            ? getOrangeButtonBg(context)
                                                                            : getBlackButtonBg(context),
                                                                        padding: const EdgeInsets.all(10),
                                                                        child: Row(
                                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                          children: [
                                                                            Expanded(
                                                                                child: Text(
                                                                              "Accepted".toUpperCase(),
                                                                              style: AppTextStyle.whiteRubik14,
                                                                              textAlign: TextAlign.center,
                                                                            ))
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    )),
                                                                    SizedBox(
                                                                      width: 10,
                                                                    ),
                                                                    Expanded(
                                                                        child: RaisedButton(
                                                                      onPressed: () {
                                                                        Utils.hideKeyBoard(context);
                                                                        setState(() {
                                                                          inspectionDetail.decision = 2;
                                                                        });
                                                                      },
                                                                      padding: const EdgeInsets.all(0.0),
                                                                      splashColor: Colors.black38,
                                                                      shape: RoundedRectangleBorder(
                                                                        borderRadius: BorderRadius.circular(10.0),
                                                                      ),
                                                                      child: Ink(
                                                                        decoration: inspectionDetail?.decision == 2
                                                                            ? getOrangeButtonBg(context)
                                                                            : getBlackButtonBg(context),
                                                                        padding: const EdgeInsets.all(10),
                                                                        child: Row(
                                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                          children: [
                                                                            Expanded(
                                                                                child: Text(
                                                                              "Not accepted".toUpperCase(),
                                                                              style: AppTextStyle.whiteRubik14,
                                                                              textAlign: TextAlign.center,
                                                                            ))
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    )),
                                                                  ],
                                                                ),
                                                              ),*/
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 25, vertical: 16),
                        child: Row(
                          children: [
                            Expanded(
                                child: InkWell(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  decision == 1
                                      ? Container(
                                          child: Icon(
                                            Icons.check,
                                            color: AppColor.white,
                                            size: 15,
                                          ),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            gradient: LinearGradient(
                                              begin: Alignment.centerRight,
                                              end: Alignment.centerLeft,
                                              colors: [
                                                const Color(0xFFEF4136),
                                                const Color(0xFFF46B29),
                                                const Color(0xFFF8931D),
                                              ],
                                            ),
                                          ),
                                          width: 20,
                                          height: 20,
                                        )
                                      : Container(
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                  color: AppColor.textBlack,
                                                  width: 1)),
                                          width: 20,
                                          height: 20,
                                        ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "Accepted".toUpperCase(),
                                    style: AppTextStyle.blackRubik14
                                        .copyWith(color: Colors.green),
                                    textAlign: TextAlign.center,
                                  )
                                ],
                              ),
                              onTap: () {
                                if (!widget.readOnly) {
                                  Utils.hideKeyBoard(context);
                                  if (!isValidDetail()) {
                                    return;
                                  }
                                  setState(() {
                                    modified = true;
                                    decision = 1;
                                  });
                                  gotoNextPage();
                                }
                              },
                            )),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                                child: InkWell(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  decision == 2
                                      ? Container(
                                          child: Icon(
                                            Icons.check,
                                            color: AppColor.white,
                                            size: 15,
                                          ),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            gradient: LinearGradient(
                                              begin: Alignment.centerRight,
                                              end: Alignment.centerLeft,
                                              colors: [
                                                const Color(0xFFEF4136),
                                                const Color(0xFFF46B29),
                                                const Color(0xFFF8931D),
                                              ],
                                            ),
                                          ),
                                          width: 20,
                                          height: 20,
                                        )
                                      : Container(
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                  color: AppColor.textBlack,
                                                  width: 1)),
                                          width: 20,
                                          height: 20,
                                        ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "Not accepted".toUpperCase(),
                                    style: AppTextStyle.blackRubik14
                                        .copyWith(color: Colors.red),
                                    textAlign: TextAlign.center,
                                  )
                                ],
                              ),
                              onTap: () {
                                if (!widget.readOnly) {
                                  Utils.hideKeyBoard(context);
                                  _scrollController1.animateTo(
                                      _scrollController1
                                          .position.maxScrollExtent,
                                      duration: Duration(milliseconds: 200),
                                      curve: Curves.easeOut);
                                  setState(() {
                                    modified = true;
                                    decision = 2;
                                  });
                                  // gotoNextPage();
                                }
                              },
                            )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            FractionallySizedBox(
              alignment: Alignment.bottomCenter,
              heightFactor: 0.08,
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      Utils.hideKeyBoard(context);
                      if (currentPage > 0) {
                        /*if (inspectionDetail.type != null &&
                                                                    inspectionDetail.type ==
                                                                        Constants.INSPECTION_TYPE_QUANTITATIVE) {
                                                                  double total = 0;
                                                                  int divider = 0;
                                                                  inspectionDetail.quantitativeResult
                                                                      ?.forEach((element) {
                                                                    if (element != null && element.isNotEmpty) {
                                                                      total = total + double.parse(element);
                                                                      divider = divider + 1;
                                                                    }
                                                                  });
                                                                  double avg = divider != 0 ? (total / divider) : total;
                                                                  setState(() {
                                                                    inspectionDetail.result = avg.toString();
                                                                  });
                                                                }*/
                        _scrollController1.jumpTo(0);
                        setState(() {
                          modified = false;
                          inspectionDetail.capturedImages = imageList;
                          currentPage = currentPage - 1;
                          inspectionDetail = list[currentPage];

                          if (inspectionDetail.capturedImages == null) {
                            inspectionDetail.capturedImages = [];
                          }
                          if (inspectionDetail.quantitativeResult == null) {
                            inspectionDetail.quantitativeResult = [];
                            inspectionDetail.quantitativeResult.length =
                                inspectionDetail.noOfMeasurements ?? 0;
                          }
                          imageList = inspectionDetail.capturedImages ?? [];
                        });
                        // resultController.text = inspectionDetail?.result ?? '';
                        // commentController.text =
                        //     inspectionDetail?.remarks ?? '';
                        reinitState(inspectionDetail);
                        _scrollController.scrollTo(
                            index: currentPage, duration: Duration(seconds: 1));
                      }
                    },
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      child: Text(
                        'Previous',
                        style: AppTextStyle.whiteRubik14,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  /*Expanded(
                                                              child: Container(
                                                            alignment: Alignment.center,
                                                            child: SingleChildScrollView(
                                                              scrollDirection: Axis.horizontal,
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: [
                                                                  for (int i = 0; i < list.length; i++)
                                                                    Container(
                                                                      width: currentPage == i ? 8.0 : 6.0,
                                                                      height: currentPage == i ? 8.0 : 6.0,
                                                                      margin: EdgeInsets.symmetric(
                                                                          vertical: 10.0, horizontal: 2.0),
                                                                      decoration: BoxDecoration(
                                                                        shape: BoxShape.circle,
                                                                        color: currentPage == i
                                                                            ? AppColor.red
                                                                            : Colors.white,
                                                                      ),
                                                                    ),
                                                                ],
                                                              ),
                                                            ),
                                                          )),*/
                  Expanded(
                      child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(horizontal: 2),
                    child: ScrollablePositionedList.builder(
                      itemScrollController: _scrollController,
                      itemCount: list.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, i) {
                        return Container(
                          width: currentPage == i ? 8.0 : 6.0,
                          height: currentPage == i ? 8.0 : 6.0,
                          margin: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 2.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                currentPage == i ? AppColor.red : Colors.white,
                          ),
                        );
                      },
                    ),
                  )),
                  SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    onTap: () {
                      Utils.hideKeyBoard(context);
                      if (currentPage < list.length) {
                        if (!widget.readOnly) {
                          setState(() {
                            modified = true;
                            decision = decision ?? 3;
                          });
                          gotoNextPage();
                        } else {
                          if (currentPage == list.length - 1) {
                            Navigator.pop(context);
                          } else {
                            _scrollController1.jumpTo(0);
                            setState(() {
                              inspectionDetail.capturedImages = imageList;
                              currentPage = currentPage + 1;
                              inspectionDetail = list[currentPage];
                              if (inspectionDetail.capturedImages == null) {
                                inspectionDetail.capturedImages = [];
                              }
                              if (inspectionDetail.quantitativeResult == null) {
                                inspectionDetail.quantitativeResult = [];
                                inspectionDetail.quantitativeResult.length =
                                    inspectionDetail.noOfMeasurements ?? 0;
                              }
                              imageList = inspectionDetail.capturedImages ?? [];
                            });

                            // resultController.text =
                            //     inspectionDetail?.result ?? '';
                            // commentController.text =
                            //     inspectionDetail?.remarks ?? '';
                            reinitState(inspectionDetail);
                            _scrollController.scrollTo(
                                index: currentPage,
                                duration: Duration(seconds: 1));
                          }
                        }
                      }
                    },
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      child: Text(
                        currentPage == list.length - 1 ? 'Done' : 'Next',
                        style: AppTextStyle.whiteRubik14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }

  Widget getQuantResult(int index, String quantitativeResult) {
    TextEditingController controller =
        TextEditingController(text: quantitativeResult ?? '');
    controller.selection = TextSelection.fromPosition(
        TextPosition(offset: controller.text.length));
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: TextFormField(
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(12.0),
          filled: true,
          hintText: 'Result',
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: inspectionDetail.validateResultForQuant(index)
                      ? AppColor.red.withOpacity(0.8)
                      : AppColor.dividerColor,
                  width: 1.0),
              borderRadius: BorderRadius.all(Radius.circular(10))),
          border: OutlineInputBorder(
              borderSide: BorderSide(
                  color: inspectionDetail.validateResultForQuant(index)
                      ? AppColor.red.withOpacity(0.8)
                      : AppColor.dividerColor,
                  width: 1.0),
              borderRadius: BorderRadius.all(Radius.circular(10))),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: inspectionDetail.validateResultForQuant(index)
                      ? AppColor.red.withOpacity(0.8)
                      : AppColor.dividerColor,
                  width: 1.0),
              borderRadius: BorderRadius.all(Radius.circular(10))),
          fillColor: AppColor.white,
          hintStyle: AppTextStyle.textHintStyle,
          // errorText: resultValidate ? "" : null,
          // errorText: inspectionDetail.result != null &&
          //         inspectionDetail.result.isNotEmpty &&
          //         !inspectionDetail.isValidResult(inspectionDetail.result)
          //     ? ""
          //     : null
        ),
        readOnly: widget.readOnly,
        showCursor: true,
        autofocus: false,
        cursorColor: AppColor.textBlack,
        style: AppTextStyle.textFieldStyle,
        controller: controller,
        textInputAction:
            index == ((inspectionDetail?.quantitativeResult?.length ?? 1) - 1)
                ? TextInputAction.done
                : TextInputAction.next,
        keyboardType: inspectionDetail.isAlphaNumeric()
            ? TextInputType.text
            : TextInputType.numberWithOptions(decimal: true),
        inputFormatters: inspectionDetail.isAlphaNumeric()
            ? [
                FilteringTextInputFormatter.allow(
                    RegExp("[A-Za-z0-9#+-_@. ]*")),
              ]
            : [
                FilteringTextInputFormatter.allow(RegExp("[0-9.]*")),
              ],
        onChanged: (text) {
          setState(() {
            inspectionDetail.quantitativeResult[index] = text;
          });
        },
      ),
    );
  }

  void gotoNextPage() {
    if (currentPage < list.length) {
      if (decision == 2 || decision == 1) {
        if (!isValidDetail()) {
          return;
        }
        if (decision == 2) {
          if ((inspectionDetail?.remarks ?? '').isEmpty) {
            UiUtils.showMyToast(message: 'Please enter comment');
            return;
          }
        }
      }
      inspectionDetail.decision = decision;

      if (currentPage == list.length - 1) {
        setState(() {
          inspectionDetail.capturedImages = imageList;
        });
        if (modified) widget.callBack(Constants.SAVE_INSPACTION);
        modified = false;
        Navigator.pop(context);
      } else {
        _scrollController1.jumpTo(0);
        setState(() {
          inspectionDetail.capturedImages = imageList;
          if (modified) widget.callBack(Constants.SAVE_INSPACTION);
          modified = false;
          currentPage = currentPage + 1;
          inspectionDetail = list[currentPage];
          if (inspectionDetail.capturedImages == null) {
            inspectionDetail.capturedImages = [];
          }
          if (inspectionDetail.quantitativeResult == null) {
            inspectionDetail.quantitativeResult = [];
            inspectionDetail.quantitativeResult.length =
                inspectionDetail.noOfMeasurements ?? 0;
          }
          imageList = inspectionDetail.capturedImages ?? [];
        });

        // resultController.text = inspectionDetail?.result ?? '';
        // commentController.text = inspectionDetail?.remarks ?? '';
        reinitState(inspectionDetail);
        _scrollController.scrollTo(
            index: currentPage, duration: Duration(seconds: 1));
      }
    }
  }

  void captureImage() {
    // if (Platform.isIOS) {
    ImagePicker()
        .getImage(
            source: ImageSource.camera, imageQuality: Constants.IMAGE_QUALITY)
        .then((value) {
      if (value?.path == null) return;
      imageList.insert(0, value.path);
      setState(() {
        modified = true;
      });
    });
    // } else {
    //   startForgroundService();
    // }
  }

  Future<void> startForgroundService() async {
    const plarform = MethodChannel('in.eightfolds/captureImage');
    try {
      plarform.invokeMethod('captureImage').then((value) {
        if (value == null) return;
        imageList.insert(0, value);
        setState(() {
          modified = true;
        });
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  bool isValidDetail() {
    var isEmptyResult = false;
    if (inspectionDetail.type != null &&
        inspectionDetail.type == Constants.INSPECTION_TYPE_QUANTITATIVE) {
      double total = 0;
      int divider = 0;
      inspectionDetail.quantitativeResult?.forEach((element) {
        if (element != null && element.isNotEmpty) {
          try {
            total = total + double.parse(element);
          } catch (e) {
            debugPrint(e.toString());
          }
          divider = divider + 1;
        } else {
          isEmptyResult = true;
        }
      });
      double avg = divider != 0 ? (total / divider) : total;
      debugPrint('Avg $avg');
      setState(() {
        inspectionDetail.result = avg.toString();
      });
    }

    if (inspectionDetail.type != null &&
        inspectionDetail.type == Constants.INSPECTION_TYPE_QUANTITATIVE &&
        isEmptyResult) {
      UiUtils.showMyToast(message: 'Please enter all result');
      return false;
    }

    if ((inspectionDetail?.type ?? '') !=
            Constants.INSPECTION_TYPE_QUANTITATIVE &&
        (inspectionDetail?.specification ?? '').isNotEmpty &&
        (inspectionDetail?.result ?? '').isEmpty) {
      UiUtils.showMyToast(message: 'Please enter result');
      return false;
    }

    if ((inspectionDetail?.isReferenceImageAvailable() ?? false) &&
        (imageList.length < 1)) {
      UiUtils.showMyToast(message: "Please capture image");
      return false;
    }

    if (inspectionDetail.samplingFreqType == true &&
        imageList.length < imageCapturedLimit) {
      UiUtils.showMyToast(
          message:
              "Please capture ${imageCapturedLimit - imageList.length} more image's");
      return false;
    }

    if ((inspectionDetail?.specification ?? '').isEmpty &&
        (inspectionDetail?.result ?? '').isEmpty &&
        (imageList.length < 1)) {
      UiUtils.showMyToast(message: "Please capture one image");
      return false;
    }

    return true;
  }

  void reinitState(InspectionDetail inspectionDetail) {
    var count = inspectionDetail.noOfMeasurements ?? 0;
    if (count > 0) {
      inspectionDetail.type = Constants.INSPECTION_TYPE_QUANTITATIVE;
    }
    if (inspectionDetail.quantitativeResult == null) {
      inspectionDetail.quantitativeResult = [];
      inspectionDetail.quantitativeResult.length =
          inspectionDetail.noOfMeasurements ?? 0;
    }
    imageList = inspectionDetail.capturedImages ?? [];
    resultController.text = inspectionDetail?.result ?? '';
    commentController.text = inspectionDetail?.remarks ?? '';

    imageCapturedLimit = 100;
    if ((inspectionDetail.frequency ?? '').isNotEmpty &&
        inspectionDetail.samplingFreqType == true) {
      try {
        int frequency = int.parse(inspectionDetail.frequency);
        imageCapturedLimit = frequency;
      } catch (e) {
        debugPrint(e.toString());
      }
    }

    decision = inspectionDetail.decision;
  }
}
