import 'package:SomanyHIL/model/inspection.dart';
import 'package:SomanyHIL/screens/inspection_history_detail.dart';
import 'package:SomanyHIL/style/colors.dart';
import 'package:SomanyHIL/style/text_style.dart';
import 'package:SomanyHIL/utils/constants.dart';
import 'package:SomanyHIL/utils/slide_transitions.dart';
import 'package:SomanyHIL/utils/utils.dart';
import 'package:SomanyHIL/viewmodel/home_viewmodel.dart';
import 'package:flutter/material.dart';
// import 'package:date_range_picker/date_range_picker.dart' as DateRangePicker;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class InspectionHistory extends StatefulWidget {
  @override
  _InspectionHistoryState createState() => _InspectionHistoryState();
}

class _InspectionHistoryState extends State<InspectionHistory> {
  var todayDate = DateTime.now();
  DateTime initialFirstDate;
  DateTime initialLastDate;
  List<Inspection> items;

  @override
  void initState() {
    super.initState();
    initialFirstDate = DateTime(todayDate.year, (todayDate.month), 1);
    initialLastDate = DateTime(todayDate.year, todayDate.month, todayDate.day);
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
        title: Text(
          'History',
          style: AppTextStyle.blackRubikMedium16,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_today),
            color: AppColor.textBlack,
            onPressed: () {
              SfDateRangePicker(
                onSelectionChanged: (args) {
                  if (args != null) {
                    setState(() {
                      initialFirstDate = args.value.startDate;
                      initialLastDate =
                          args.value.endDate ?? args.value.startDate;
                    });
                  }
                },
                selectionMode: DateRangePickerSelectionMode.range,
                initialSelectedRange:
                    PickerDateRange(initialFirstDate, initialLastDate),
              );
              // DateRangePicker.showDatePicker(
              //         context: context,
              //         initialFirstDate: initialFirstDate,
              //         initialLastDate: initialLastDate,
              //         firstDate: DateTime(2015),
              //         lastDate: DateTime(
              //             todayDate.year, todayDate.month, todayDate.day))
              //     .then((value) {
              //   if (value != null && value.isNotEmpty) {
              //     debugPrint(value.toString());
              //     // items.clear();
              //     setState(() {
              //       initialFirstDate = value[0];
              //       initialLastDate = value[0];
              //       if (value.length == 2) {
              //         initialLastDate = value[1];
              //       }
              //     });
              //   }
              // });
            },
          )
        ],
      ),
      body: getInspectionHistoryList(),
    ));
  }

  Widget getInspectionHistoryList() {
    return FutureBuilder(
      future: HomeViewModel.getInspectionHistory(
          context,
          Utils.formateDate(
              date: initialFirstDate?.toString(), formateTo: 'yyyy-MM-dd'),
          Utils.formateDate(
              date: initialLastDate?.toString(), formateTo: 'yyyy-MM-dd')),
      builder: (context, snapshot) {
        debugPrint('Data: ${snapshot.hasData}');
        if (snapshot.hasData) {
          debugPrint('Data: ${snapshot.hasData}');
          debugPrint('Data: ${snapshot.data}');
          if (snapshot.data is List) {
            debugPrint('Data: ${snapshot.data.length}');
            items = snapshot.data;
            if ((items?.length ?? 0) <= 0) {
              return getEmptyListLayout(context);
            }
            return _getListWidget();
          } else {
            return getEmptyListLayout(context);
          }
        } else if (snapshot.hasError) {
          // return Text("${snapshot.error}");
          return getEmptyListLayout(context);
        }
        // By default, show a loading spinner.
        return ((items?.length ?? 0) <= 0)
            ? Center(
                child: CircularProgressIndicator(),
              )
            : _getListWidget();
      },
    );
  }

  Widget _getListWidget() {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemBuilder: (contex, index) {
        final item = items[index];
        return getItemCard(index);
      },
      separatorBuilder: (BuildContext context, int index) => const SizedBox(
        height: 12,
      ),
      itemCount: items?.length ?? 0,
    );
  }

  Widget getItemCard(int index) {
    var inspection = items[index];
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            SlideLeftRoute(
                page: InspectionHistoryDetail(
              inspection: inspection,
            )));
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
                child: Container(
                  width: 46,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          width: 10,
                          height: 10,
                          margin: EdgeInsets.zero,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: getStatusColor(inspection.status)),
                        ),
                      ),
                      Opacity(
                          opacity: 0.08,
                          child: SvgPicture.asset(
                            Constants.geyser,
                            width: 46,
                            height: 46,
                          )),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          inspection.status ==
                                  Inspection
                                      .INSPECTION_STATUS_USAGE_DECISION_TAKEN
                              ? 'All done'
                              : 'Pending',
                          textAlign: TextAlign.center,
                          style: AppTextStyle.greyRubik13.copyWith(fontSize: 8),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      inspection.inspectionLotNo ?? '',
                      style: AppTextStyle.greyRubik13,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      inspection.materialDesc ?? '',
                      style: AppTextStyle.blackRubik15,
                    ),
                    if ((inspection?.dateCreated?.epochSecond ?? 0) > 0)
                      SizedBox(
                        height: 12,
                      ),
                    if ((inspection?.dateCreated?.epochSecond ?? 0) > 0)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Inspection Date',
                            style: AppTextStyle.blackRubik15,
                          ),
                          Text(
                            inspection.dateCreated.formatedDateForHistory(
                                formateTo: 'yyyy-MM-dd'),
                            style: AppTextStyle.blackRubik12
                                .copyWith(fontSize: 12),
                          ),
                        ],
                      ),
                    SizedBox(
                      height: 12,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if ((inspection?.poNumber ?? '').isNotEmpty)
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'PO Number',
                                  style: AppTextStyle.blackRubik15,
                                ),
                                Text(
                                  inspection?.poNumber,
                                  style: AppTextStyle.blackRubik12
                                      .copyWith(fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        if ((inspection?.poQuality ?? 0) > 0)
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Inspection Lot Quantity',
                                  style: AppTextStyle.blackRubik15,
                                ),
                                Text(
                                  '${inspection?.poQuality}',
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
                        if ((inspection?.inspectionStartTime?.epochSecond ?? 0) > 0)
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Start Time',
                                  style: AppTextStyle.blackRubik15,
                                ),
                                Text(
                                  inspection.inspectionStartTime
                                      .formatedDateForHistory(),
                                  style: AppTextStyle.blackRubik12
                                      .copyWith(fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        if ((inspection?.inspectionEndTime?.epochSecond ?? 0) >
                            0)
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Finish Time',
                                  style: AppTextStyle.blackRubik15,
                                ),
                                Text(
                                  inspection.inspectionEndTime
                                      .formatedDateForHistory(),
                                  style: AppTextStyle.blackRubik12
                                      .copyWith(fontSize: 12),
                                ),
                              ],
                            ),
                          )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color getStatusColor(String fgStatusCode) {
    Color color = AppColor.red.withOpacity(0.8);
    if (fgStatusCode == Inspection.INSPECTION_STATUS_USAGE_DECISION_TAKEN) {
      color = Colors.green.withOpacity(0.8);
    }
    return color;
  }

  Widget getEmptyListLayout(BuildContext context) {
    return Center(
      child: Text(
        Constants.NO_INSPECTION,
        style: AppTextStyle.blackRubikMedium22,
      ),
    );
  }
}
