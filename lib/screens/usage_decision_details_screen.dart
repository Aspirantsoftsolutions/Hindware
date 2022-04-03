import 'dart:io';

import 'package:SomanyHIL/firebase/firebase_utils.dart';
import 'package:SomanyHIL/mixin/e_dimension.dart';
import 'package:SomanyHIL/model/inspection.dart';
import 'package:SomanyHIL/model/inspection_detail.dart';
import 'package:SomanyHIL/screens/dialog_inspection_signature.dart';
import 'package:SomanyHIL/screens/dialog_user_decision.dart';
import 'package:SomanyHIL/screens/home_screen.dart';
import 'package:SomanyHIL/screens/inspection_overall_observation_detail_screen%20copy.dart';
import 'package:SomanyHIL/style/colors.dart';
import 'package:SomanyHIL/style/text_style.dart';
import 'package:SomanyHIL/utils/constants.dart';
import 'package:SomanyHIL/utils/inspection_utils.dart';
import 'package:SomanyHIL/utils/ui_utils.dart';
import 'package:SomanyHIL/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'common_dialog.dart';
import 'dialog_inspection_lot.dart';

class UsageDecisionDetailsScreen extends StatefulWidget {
  final String inspectionLotNo;

  UsageDecisionDetailsScreen({this.inspectionLotNo});

  @override
  State<StatefulWidget> createState() => _UsageDecisionDetailsScreenState();
}

class _UsageDecisionDetailsScreenState extends State<UsageDecisionDetailsScreen>
    with EDimension {
  final TextEditingController poQualityController = TextEditingController();
  Inspection _inspection;

  Future<void> parentCallBack(int type) async {
    if (type == Constants.SAVE_INSPACTION) {
      await _inspection?.addToFirebase(modified: false);
      UiUtils.showMyToast(
          message: 'User decision submitted successfully...',
          messagetype: MessageType.INFO);
      InspectionUtils().inUseInspectionLotNo = null;
      InspectionUtils().goForSync();
      Navigator.of(context).pushNamedAndRemoveUntil(
          HomeScreen.routeName, (Route<dynamic> route) => false);
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
    WidgetsBinding.instance
        .addPostFrameCallback((_) => validateAndNavigate(fromInit: true));
  }

  void showSignatureDialog() {
    var inspectionList;
    if(_inspection.version !=null && _inspection.version !=''){
       inspectionList = InspectionUtils().getPendingSignatureInspection(
          inspectionLotNo: _inspection.inspectionLotNo+_inspection.version);

    }else{
       inspectionList = InspectionUtils().getPendingSignatureInspection(
          inspectionLotNo: _inspection.inspectionLotNo);

    }
    if (inspectionList.length > 0) {
      showDialog(
          context: context,
          useSafeArea: true,
          builder: (_) {
            return DialogInspectionSignature(
              index: 0,
              inspectionList: inspectionList,
            );
          }).then((value) {
        _inspection = InspectionUtils()
            .getInspactionByInspectionLotNo(widget.inspectionLotNo);
        setState(() {});
        // InspectionUtils().goForSync();
      });
    }
  }

  @override
  void dispose() {
    // BroadcastEvents().publish(Constants.REFRESH_UG_COLOR);
    InspectionUtils().inUseInspectionLotNo = null;
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
      body: Column(
        children: [
          Expanded(
              child: SingleChildScrollView(
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
                          height: 20,
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
                          height: 20,
                        ),
                        Text(
                          'System status',
                          style: AppTextStyle.greyRubik13,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          _inspection?.status ?? '',
                          style: AppTextStyle.blackRubik14,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Insp, end date',
                          style: AppTextStyle.greyRubik13,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          '',
                          style: AppTextStyle.blackRubik14,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: RaisedButton(
                            onPressed: () {
                              if ((_inspection.decision > 0)) {
                                UiUtils.showMyToast(
                                    message: 'User decision submitted...',
                                    messagetype: MessageType.INFO);
                              } else {
                                showDialog(
                                    context: context,
                                    useSafeArea: true,
                                    builder: (_) {
                                      return InspectionOverAllObservationDetail(
                                        inspectionLotNo:
                                            _inspection.inspectionLotNo,
                                      );
                                    });
                              }
                            },
                            padding: const EdgeInsets.all(0.0),
                            splashColor: Colors.black38,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            child: Ink(
                              decoration: getOrangeButtonBg(context),
                              padding: const EdgeInsets.all(10),
                              child: Text(
                                "Add Observation",
                                style: AppTextStyle.whiteRubik14,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                if (_inspection.bomInspectionDetails != null &&
                    _inspection.bomInspectionDetails.length > 0)
                  for (int i = 0;
                      i < _inspection.bomInspectionDetails.length;
                      i++)
                    InkWell(
                      onTap: () {
                        List<InspectionDetail> list = [];
                        list.addAll(_inspection?.bomInspectionDetails ?? []);
                        list.addAll(_inspection?.fgInspectionDetails ?? []);
                        showDialog(
                            context: context,
                            useSafeArea: true,
                            builder: (_) {
                              return DialogInspectionLot(
                                index: i,
                                inspectionList: list,
                                callBack: (value) {},
                                readOnly: true,
                              );
                            });
                      },
                      child: Card(
                        color: AppColor.white,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(16))),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 25, vertical: 16),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Align(
                                        child: Container(
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: getStatusColor(_inspection
                                                  .bomInspectionDetails[i]
                                                  ?.getStatusCode())),
                                          width: 10,
                                          height: 10,
                                        ),
                                        alignment: Alignment.centerRight,
                                      ),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                                _inspection
                                                        .bomInspectionDetails[i]
                                                        ?.characNo ??
                                                    '',
                                                style:
                                                    AppTextStyle.blackRubik14,
                                              ),
                                            ],
                                          )),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                              child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                'Specification',
                                                style: AppTextStyle.greyRubik13,
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                _inspection
                                                        .bomInspectionDetails[i]
                                                        ?.specification ??
                                                    '',
                                                style:
                                                    AppTextStyle.blackRubik14,
                                              ),
                                            ],
                                          )),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                              child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Oper./Act.',
                                                style: AppTextStyle.greyRubik13,
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                '0010',
                                                style:
                                                    AppTextStyle.blackRubik14,
                                              ),
                                            ],
                                          )),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  'Short text',
                                                  style:
                                                      AppTextStyle.greyRubik13,
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  _inspection
                                                          .bomInspectionDetails[
                                                              i]
                                                          ?.shortDesc ??
                                                      '',
                                                  style:
                                                      AppTextStyle.blackRubik14,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                              child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Mast. charac.',
                                                style: AppTextStyle.greyRubik13,
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                _inspection
                                                        .bomInspectionDetails[i]
                                                        ?.mastCharac ??
                                                    '',
                                                style:
                                                    AppTextStyle.blackRubik14,
                                              ),
                                            ],
                                          )),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          if (_inspection
                                                      .bomInspectionDetails[i]
                                                      ?.decision !=
                                                  null &&
                                              _inspection
                                                      .bomInspectionDetails[i]
                                                      ?.decision !=
                                                  0)
                                            Expanded(
                                                child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  'Result',
                                                  style:
                                                      AppTextStyle.greyRubik13,
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  _inspection
                                                              .bomInspectionDetails[
                                                                  i]
                                                              ?.decision ==
                                                          1
                                                      ? 'Accepted'
                                                      : _inspection
                                                                  .bomInspectionDetails[
                                                                      i]
                                                                  ?.decision ==
                                                              2
                                                          ? "Not Accepted"
                                                          : '',
                                                  style:
                                                      AppTextStyle.blackRubik14,
                                                ),
                                              ],
                                            )),
                                        ],
                                      ),
                                    ],
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ),
                if (_inspection.fgInspectionDetails != null &&
                    _inspection.fgInspectionDetails.length > 0)
                  for (int i = 0;
                      i < _inspection.fgInspectionDetails.length;
                      i++)
                    InkWell(
                      onTap: () {
                        List<InspectionDetail> list = [];
                        list.addAll(_inspection?.bomInspectionDetails ?? []);
                        list.addAll(_inspection?.fgInspectionDetails ?? []);
                        int index =
                            ((_inspection?.bomInspectionDetails ?? []).length) +
                                i;
                        showDialog(
                            context: context,
                            useSafeArea: true,
                            builder: (_) {
                              return DialogInspectionLot(
                                index: index,
                                inspectionList: list,
                                callBack: (value) {},
                                readOnly: true,
                              );
                            });
                      },
                      child: Card(
                        color: AppColor.white,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(16))),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 25, vertical: 16),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Align(
                                        child: Container(
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: getStatusColor(_inspection
                                                  .fgInspectionDetails[i]
                                                  ?.getStatusCode())),
                                          width: 10,
                                          height: 10,
                                        ),
                                        alignment: Alignment.centerRight,
                                      ),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                                _inspection
                                                        .fgInspectionDetails[i]
                                                        ?.characNo ??
                                                    '',
                                                style:
                                                    AppTextStyle.blackRubik14,
                                              ),
                                            ],
                                          )),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                              child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                'Specification',
                                                style: AppTextStyle.greyRubik13,
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                _inspection
                                                        .fgInspectionDetails[i]
                                                        ?.specification ??
                                                    '',
                                                style:
                                                    AppTextStyle.blackRubik14,
                                              ),
                                            ],
                                          )),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                              child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Oper./Act.'.toUpperCase(),
                                                style: AppTextStyle.greyRubik13,
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                '0020',
                                                style:
                                                    AppTextStyle.blackRubik14,
                                              ),
                                            ],
                                          )),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  'Short text',
                                                  style:
                                                      AppTextStyle.greyRubik13,
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  _inspection
                                                          .fgInspectionDetails[
                                                              i]
                                                          ?.shortDesc ??
                                                      '',
                                                  style:
                                                      AppTextStyle.blackRubik14,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                              child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Mast. charac.',
                                                style: AppTextStyle.greyRubik13,
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                _inspection
                                                        .fgInspectionDetails[i]
                                                        ?.mastCharac ??
                                                    '',
                                                style:
                                                    AppTextStyle.blackRubik14,
                                              ),
                                            ],
                                          )),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          if (_inspection.fgInspectionDetails[i]
                                                      ?.decision !=
                                                  null &&
                                              _inspection.fgInspectionDetails[i]
                                                      ?.decision !=
                                                  0)
                                            Expanded(
                                                child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  'Result',
                                                  style:
                                                      AppTextStyle.greyRubik13,
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  _inspection
                                                              .fgInspectionDetails[
                                                                  i]
                                                              ?.decision ==
                                                          1
                                                      ? 'Accepted'
                                                      : _inspection
                                                                  .fgInspectionDetails[
                                                                      i]
                                                                  ?.decision ==
                                                              2
                                                          ? "Not Accepted"
                                                          : '',
                                                  style:
                                                      AppTextStyle.blackRubik14,
                                                ),
                                              ],
                                            )),
                                        ],
                                      ),
                                    ],
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ),
              ],
            ),
          )),
          Container(
            color: AppColor.textBlack,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Row(
              children: [
                Spacer(),
                Spacer(),
                Expanded(
                    child: RaisedButton(
                  onPressed: () {
                    Utils.hideKeyBoard(context);
                    if ((_inspection.decision > 0)) {
                      UiUtils.showMyToast(
                          message: 'User decision submitted...',
                          messagetype: MessageType.INFO);
                    } else {
                      validateAndNavigate();
                    }
                  },
                  padding: const EdgeInsets.all(0.0),
                  splashColor: Colors.black38,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  child: Ink(
                    decoration: getOrangeButtonBg(context),
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                            child: Text(
                          "User decision",
                          style: AppTextStyle.whiteRubik14,
                          textAlign: TextAlign.center,
                        ))
                      ],
                    ),
                  ),
                )),
              ],
            ),
          )
        ],
      ),
    ));
  }

  void validateAndNavigate({bool fromInit = false}) {
    var isBOMInspectionCompleted = _inspection.isBOMInspectionCompleted();
    var isFGInspectionCompleted = _inspection.isFGInspectionCompleted();
    var isSignatureCompleted = _inspection.isSignatureCompleted();
    var isOverallObservationCompleted =
        _inspection.isOverallObservationCompleted();
    var isinspectionSerialNoDetailCompleted =
        _inspection.isinspectionSerialNoDetailCompleted();
    if (!isOverallObservationCompleted) {
      showOverAllObservationDialog();
      return;
    }
    if (!isSignatureCompleted) {
      showSignatureDialog();
      return;
    }

    if (fromInit) {
      return;
    }
    if (isBOMInspectionCompleted &&
        isFGInspectionCompleted &&
        isSignatureCompleted &&
        isinspectionSerialNoDetailCompleted &&
        isOverallObservationCompleted &&
        // ((_inspection.poQuality ?? 0) == (_inspection.inspectedQuality ?? 0))) {
        ((_inspection.inspectedQuality ?? 0) > 0)) {
      // if (true) {
      showDialog(
          context: context,
          useSafeArea: true,
          builder: (_) {
            return DialogUserDecision(
              inspection: _inspection,
              callBack: parentCallBack,
            );
          });
    } else {
      showDialog(
          context: context,
          useSafeArea: true,
          builder: (_) {
            return CommonDialog(
              callBack: () {},
              title: "Alert",
              message:
                  "Didn't completed inspection yet. Please complete it to submit decision",
              yesText: "OK",
            );
          });
    }
  }

  void showOverAllObservationDialog() {
    showDialog(
        context: context,
        useSafeArea: true,
        builder: (_) {
          return InspectionOverAllObservationDetail(
            inspectionLotNo: _inspection.inspectionLotNo,
          );
        }).then((value) {
      _inspection = InspectionUtils()
          .getInspactionByInspectionLotNo(widget.inspectionLotNo);
      setState(() {});
    });
  }
}
