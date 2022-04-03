import 'dart:io';

import 'package:SomanyHIL/mixin/e_dimension.dart';
import 'package:SomanyHIL/model/inspection.dart';
import 'package:SomanyHIL/model/inspection_detail.dart';
import 'package:SomanyHIL/style/colors.dart';
import 'package:SomanyHIL/style/text_style.dart';
import 'package:SomanyHIL/utils/constants.dart';
import 'package:SomanyHIL/utils/inspection_utils.dart';
import 'package:SomanyHIL/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'dialog_inspection_lot.dart';

class InspectionLotDetailsScreen extends StatefulWidget {
  final String inspectionLotNo;

  InspectionLotDetailsScreen({this.inspectionLotNo});

  @override
  State<StatefulWidget> createState() => _InspectionLotDetailsScreenState();
}

class _InspectionLotDetailsScreenState extends State<InspectionLotDetailsScreen>
    with EDimension {
  final TextEditingController poQualityController = TextEditingController();
  bool inspectedQuantityValidate = false;
  Inspection _inspection;

  Function parentCallBack(int type) {
    if (type == Constants.SAVE_INSPACTION) {
      _inspection?.addToFirebase(modified: true);
    }
  }

  @override
  void initState() {
    super.initState();
    InspectionUtils().inUseInspectionLotNo = widget.inspectionLotNo;
    _inspection = InspectionUtils()
        .getInspactionByInspectionLotNo(widget.inspectionLotNo);
    _inspection?.bomInspectionDetails?.forEach((inspectionDetail) {
      List<String> tempList = [];
      inspectionDetail?.capturedImages?.forEach((element) {
        if (element.contains('/')) {
          if (!File(element).existsSync()) {
            tempList.add(element);
          }
        }
      });
      tempList.forEach((element1) {
        inspectionDetail?.capturedImages?.remove(element1);
      });
    });
    double tI = _inspection.inspectedQuality;
    poQualityController.text =
        tI.toStringAsFixed(0) ?? 0.toStringAsFixed(0);

  }

  @override
  void dispose() {
    // BroadcastEvents().publish(Constants.REFRESH_INSPECTION_COLOR);
    InspectionUtils().inUseInspectionLotNo = null;
    InspectionUtils().uploadImages();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              'Inspection Lot',
              style: AppTextStyle.blackRubikMedium16,
            ),
            SizedBox(
              height: 4,
            ),
            Text(
              _inspection?.inspectionLotNo ?? '',
              style: AppTextStyle.greyRubik13,
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          children: [
            Card(
              color: AppColor.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16))),
              child: Container(
                width: double.maxFinite,
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Material',
                      style: AppTextStyle.greyRubik13,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      _inspection?.materialModel ?? '',
                      style: AppTextStyle.blackRubik14,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      'Material Description',
                      style: AppTextStyle.greyRubik13,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      _inspection?.materialModelName ?? '',
                      style: AppTextStyle.blackRubik14,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      'Inception lot',
                      style: AppTextStyle.greyRubik13,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      _inspection?.inspectionLotNo ?? '',
                      style: AppTextStyle.blackRubik14,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      'Oper./Act.',
                      style: AppTextStyle.greyRubik13,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "0010 BOM for ${_inspection?.materialDesc ?? ''}",
                      style: AppTextStyle.blackRubik14,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      'Plant',
                      style: AppTextStyle.greyRubik13,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      _inspection?.plant ?? '',
                      style: AppTextStyle.blackRubik14,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      'Inspection Lot Qty',
                      style: AppTextStyle.greyRubik13,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      _inspection != null && _inspection.poQuality != null
                          ? _inspection.poQuality.toStringAsFixed(0)
                          : "0",
                      style: AppTextStyle.blackRubik14,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      'Inspected Qty',
                      style: AppTextStyle.greyRubik13,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      _inspection != null && _inspection.inspectedQuality != null && _inspection.decision == 1
                          ? (_inspection.inspectedQuality+_inspection.vqty??0).toStringAsFixed(0)
                          : (_inspection!=null?(_inspection.vqty??0):0).toStringAsFixed(0),
                      style: AppTextStyle.blackRubik14,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      'Inspecting Qty',
                      style: AppTextStyle.greyRubik13,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    /*Text(
                      _inspection?.inspectedQuality?.toStringAsFixed(0) ?? '',
                      style: AppTextStyle.blackRubik14,
                    ),*/
                    TextFormField(
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(12.0),
                        filled: true,
                        hintText: 'Inspecting Qty',
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: AppColor.dividerColor, width: 1.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: AppColor.dividerColor, width: 1.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: AppColor.dividerColor, width: 1.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: AppColor.red.withOpacity(0.8),
                                width: 1.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        fillColor: AppColor.white,
                        hintStyle: AppTextStyle.textHintStyle,
                        errorText: inspectedQuantityValidate
                            ? 'Inspected Qty should be smaller than PO quantity'
                            : null,
                      ),
                      readOnly: false,
                      showCursor: true,
                      autofocus: false,
                      cursorColor: AppColor.textBlack,
                      style: AppTextStyle.textFieldStyle,
                      controller: poQualityController,
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp("[0-9]*")),
                      ],
                      onChanged: (text) {
                        inspectedQuantityValidate = false;
                        if (text.isNotEmpty) {
                          if (double.parse(text)+(_inspection.vqty??0) <= _inspection.poQuality ??
                              0) {
                            _inspection.inspectedQuality = double.parse(text);
                            _inspection?.addToFirebase(modified: true);
                            setState(() {});
                          } else {
                            setState(() {
                              inspectedQuantityValidate = true;
                            });
                          }
                        } else {
                          _inspection.inspectedQuality = _inspection.vqty??0;
                          _inspection?.addToFirebase(modified: true);
                          setState(() {});
                        }
                      },
                      onFieldSubmitted: (text) {},
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      'To be inspect',
                      style: AppTextStyle.greyRubik13,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      _inspection?.getToBeInspect()?.toStringAsFixed(0) ?? '',
                      style: AppTextStyle.blackRubik14,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            for (int i = 0;
                i < _inspection?.bomInspectionDetails?.length ?? 0;
                i++)
              getInspectionDetailItem(i, _inspection?.bomInspectionDetails[i]),
          ],
        ),
      ),
    ));
  }

  getInspectionDetailItem(int index, InspectionDetail inspectionDetail) {
    return InkWell(
      onTap: () {
        Utils.hideKeyBoard(context);
        showDialog(
            context: context,
            useSafeArea: true,
            builder: (_) {
              return DialogInspectionLot(
                index: index,
                inspectionList: _inspection?.bomInspectionDetails,
                callBack: parentCallBack,
                readOnly: ((_inspection.decision > 0) ? true : false),
              );
            }).then((value) {
          if (mounted) setState(() {});
        });
      },
      child: Card(
        color: AppColor.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16))),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 16),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Opacity(
                      opacity: 0.08,
                      child: SvgPicture.asset(
                        Constants.geyser,
                        width: 70,
                        height: 70,
                      )),
                ),
              ),
              Align(
                  alignment: Alignment.topLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        child: Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: getStatusColor(
                                  inspectionDetail?.getStatusCode())),
                          width: 10,
                          height: 10,
                        ),
                        alignment: Alignment.centerRight,
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Charac. no.',
                                style: AppTextStyle.greyRubik13,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                inspectionDetail.characNo ?? '',
                                style: AppTextStyle.blackRubik14,
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 30,
                          ),
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
                      SizedBox(
                        height: 16,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Frequency',
                                style: AppTextStyle.greyRubik13,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                inspectionDetail?.frequency ?? '--',
                                style: AppTextStyle.blackRubik14,
                              ),
                            ],
                          )),
                          SizedBox(
                            width: 30,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'Short text',
                                  style: AppTextStyle.greyRubik13,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  inspectionDetail.shortDesc ?? '',
                                  style: AppTextStyle.blackRubik14,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
