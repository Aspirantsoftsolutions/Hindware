import 'package:SomanyHIL/mixin/e_dimension.dart';
import 'package:SomanyHIL/model/inspection.dart';
import 'package:SomanyHIL/model/inspection_detail.dart';
import 'package:SomanyHIL/screens/dialog_inspection_lot.dart';
import 'package:SomanyHIL/style/colors.dart';
import 'package:SomanyHIL/style/text_style.dart';
import 'package:SomanyHIL/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class InspectionHistoryDetail extends StatefulWidget {
  final Inspection inspection;

  InspectionHistoryDetail({this.inspection});

  @override
  _InspectionHistoryDetailState createState() =>
      _InspectionHistoryDetailState();
}

class _InspectionHistoryDetailState extends State<InspectionHistoryDetail>
    with EDimension {
  Inspection _inspection;
  @override
  void initState() {
    super.initState();
    _inspection = widget.inspection;
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Material',
                                  style: AppTextStyle.blackRubik15,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  _inspection?.materialModel ?? '',
                                  style: AppTextStyle.blackRubik14
                                      .copyWith(fontSize: 12),
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
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  'Inception lot',
                                  style: AppTextStyle.blackRubik15,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  _inspection?.inspectionLotNo ?? '',
                                  style: AppTextStyle.blackRubik14
                                      .copyWith(fontSize: 12),
                                ),
                              ],
                            )
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'System status',
                          style: AppTextStyle.blackRubik15,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          _inspection.status ==
                                  Inspection
                                      .INSPECTION_STATUS_USAGE_DECISION_TAKEN
                              ? 'All done'
                              : 'Pending',
                          style:
                              AppTextStyle.blackRubik14.copyWith(fontSize: 12),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if ((_inspection?.poNumber ?? '').isNotEmpty)
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'PO Number',
                                      style: AppTextStyle.blackRubik15,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      _inspection?.poNumber,
                                      style: AppTextStyle.blackRubik12
                                          .copyWith(fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                            if ((_inspection?.poQuality ?? 0) > 0)
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Inspection Lot Quantity',
                                      style: AppTextStyle.blackRubik15,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      '${_inspection?.poQuality}',
                                      style: AppTextStyle.blackRubik12
                                          .copyWith(fontSize: 12),
                                    ),
                                  ],
                                ),
                              )
                          ],
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if ((_inspection
                                        ?.inspectionStartTime?.epochSecond ??
                                    0) >
                                0)
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Start Time',
                                      style: AppTextStyle.blackRubik15,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      _inspection.inspectionStartTime
                                          .formatedDateForHistory(),
                                      style: AppTextStyle.blackRubik12
                                          .copyWith(fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                            if ((_inspection?.inspectionEndTime?.epochSecond ??
                                    0) >
                                0)
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Finish Time',
                                      style: AppTextStyle.blackRubik15,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      _inspection.inspectionEndTime
                                          .formatedDateForHistory(),
                                      style: AppTextStyle.blackRubik12
                                          .copyWith(fontSize: 12),
                                    ),
                                  ],
                                ),
                              )
                          ],
                        ),
                        if ((_inspection.remarks ?? '').isNotEmpty)
                          SizedBox(
                            height: 20,
                          ),
                        if ((_inspection.remarks ?? '').isNotEmpty)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Observations',
                                style: AppTextStyle.blackRubik15,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                _inspection.remarks,
                                style: AppTextStyle.blackRubik12
                                    .copyWith(fontSize: 12),
                              ),
                            ],
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
                                isHistory: true,
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
                                isHistory: true,
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
        ],
      ),
    ));
  }
}
