import 'package:SomanyHIL/mixin/common_data.dart';
import 'package:SomanyHIL/mixin/e_dimension.dart';
import 'package:SomanyHIL/model/inspection.dart';
import 'package:SomanyHIL/model/product_catalog.dart';
import 'package:SomanyHIL/screens/inspection_lot_details_screen.dart';
import 'package:SomanyHIL/screens/inspection_serial_no_detail_screen.dart';
import 'package:SomanyHIL/style/colors.dart';
import 'package:SomanyHIL/style/text_style.dart';
import 'package:SomanyHIL/utils/constants.dart';
import 'package:SomanyHIL/utils/inspection_utils.dart';
import 'package:SomanyHIL/utils/slide_transitions.dart';
import 'package:SomanyHIL/utils/utils.dart';
import 'package:broadcast_events/broadcast_events.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'fg_inspection_lot_details_screen.dart';

class ResultRecordingScreen extends StatefulWidget {
  final String productCatalogId;

  ResultRecordingScreen(this.productCatalogId);

  @override
  State<StatefulWidget> createState() => _ResultRecordingScreenState();
}

class _ResultRecordingScreenState extends State<ResultRecordingScreen>
    with EDimension, CommonData {
  List<Inspection> _inspection = [];
  List<Inspection> list = [];
  ProductCatalog _productCatalog;

  @override
  void initState() {
    super.initState();
    getProductCatalogByCatalogId(widget.productCatalogId).then((value) {
      _productCatalog = value;
      setState(() {
        _inspection = InspectionUtils()
            .getInspactionByProductCatalogId(widget.productCatalogId);

        try {
          _inspection.sort((a, b) =>
              a.dateCreated.epochSecond.compareTo(b.dateCreated.epochSecond));
        } catch (e) {
          debugPrint(e.toString());
        }
        list = _inspection;
      });
    });
    // BroadcastEvents().subscribe(Constants.REFRESH_INSPECTION_COLOR, (args) {
    //   if (this.mounted) {
    //     Future.delayed(
    //         Duration(
    //           milliseconds: 2000,
    //         ), () {
    //       if (this.mounted)
    //         setState(() {
    //           list = _inspection;
    //         });
    //     });
    //   }
    // });
  }

  @override
  void dispose() {
    // BroadcastEvents().unsubscribe(Constants.REFRESH_INSPECTION_COLOR);
    super.dispose();
  }

  bool search = false;

  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: search
          ? AppBar(
              backgroundColor: AppColor.white,
              automaticallyImplyLeading: false,
              title: TextFormField(
                decoration: InputDecoration(
                  filled: true,
                  hintText: 'Search',
                  fillColor: AppColor.white,
                  hintStyle: AppTextStyle.textHintStyle,
                  prefixIcon: IconButton(
                    icon: Icon(Icons.search),
                    color: AppColor.textBlack,
                    onPressed: () {},
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.close),
                    color: AppColor.textBlack,
                    onPressed: () {
                      searchController.text = '';
                      setState(() {
                        search = false;
                        list = _inspection;
                      });
                      Utils.hideKeyBoard(context);
                    },
                  ),
                ),
                readOnly: false,
                showCursor: true,
                autofocus: false,
                cursorColor: AppColor.textBlack,
                style: AppTextStyle.textFieldStyle,
                controller: searchController,
                textInputAction: TextInputAction.search,
                keyboardType: TextInputType.text,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                      RegExp("[A-Za-z0-9#+-_@.]*")),
                ],
                onChanged: (text) {
                  if (text.isEmpty) {
                    setState(() {
                      list = _inspection;
                    });
                  }
                },
                onFieldSubmitted: (text) {
                  if (text.isEmpty) {
                    setState(() {
                      list = _inspection;
                    });
                  } else {
                    filterList(text);
                  }
                },
              ),
            )
          : AppBar(
              backgroundColor: AppColor.white,
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                color: AppColor.textBlack,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              title: Text(
                'Result Recording',
                style: AppTextStyle.blackRubikMedium16,
              ),
              actions: [
                IconButton(
                  icon: Icon(Icons.search),
                  color: AppColor.textBlack,
                  onPressed: () {
                    setState(() {
                      search = true;
                    });
                  },
                )
              ],
            ),
      body: list.length <= 0
          ? Center(
              child: Text(
                Constants.NO_INSPECTION_ASSIGNED,
                style: AppTextStyle.blackRubikMedium22,
              ),
            )
          : ListView.builder(
              itemCount: list.length,
              padding: EdgeInsets.only(
                left: 10,
                right: 10,
                top: 10,
              ),
              itemBuilder: (context, index) {
                var inspection = list[index];
                return Card(
                  color: AppColor.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16))),
                  child: Stack(
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
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
                                    // 'BOM for i - FOLD-Desert cooler 90L',
                                    style: AppTextStyle.blackRubik15,
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Expanded(
                                          child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Align(
                                            child: Container(
                                              width: 10,
                                              height: 10,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: getStatusColor(
                                                      inspection
                                                          .getBomStatusCode())),
                                            ),
                                            alignment: Alignment.topRight,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              if (!inspection
                                                  .isinspectionSerialNoDetailCompleted()) {
                                                showDialog(
                                                    context: context,
                                                    useSafeArea: true,
                                                    builder: (_) {
                                                      return InspectionSerialNoDetail(
                                                        inspectionLotNo:
                                                            inspection
                                                                .inspectionLotNo,
                                                      );
                                                    }).then((value) {
                                                  if (mounted) setState(() {});
                                                });
                                              } else {
                                                Navigator.push(
                                                    context,
                                                    SlideLeftRoute(
                                                        page:
                                                            InspectionLotDetailsScreen(
                                                      inspectionLotNo:
                                                          inspection
                                                              .inspectionLotNo,
                                                    ))).then((value) {
                                                  refreshScreen();
                                                });
                                              }
                                            },
                                            child: Container(
                                              width: double.maxFinite,
                                              child: InkWell(
                                                child: Text(
                                                  'BOM - 0010',
                                                  textAlign: TextAlign.center,
                                                  style: AppTextStyle
                                                      .blackRubik12
                                                      .copyWith(
                                                          decoration:
                                                              TextDecoration
                                                                  .underline,
                                                          color: AppColor
                                                              .textGray),
                                                ),
                                              ),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 18, vertical: 7),
                                              decoration: BoxDecoration(
                                                  // border: Border.all(
                                                  //     color: getStatusColor(inspection
                                                  //         .getBomStatusCode())),
                                                  border: Border.all(
                                                      color: AppColor.textGray),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(24))),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 3,
                                          ),
                                          Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              inspection.getBomStatusCode() ==
                                                      'red'
                                                  ? 'Pending'
                                                  : inspection.getBomStatusCode() ==
                                                          'orange'
                                                      ? "Upload Pending"
                                                      : inspection.getBomStatusCode() ==
                                                              'green'
                                                          ? "All done"
                                                          : '',
                                              textAlign: TextAlign.center,
                                              style: AppTextStyle.blackRubik12
                                                  .copyWith(
                                                      fontSize: 8,
                                                      color: AppColor.textGray),
                                            ),
                                          )
                                        ],
                                      )),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                          child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Align(
                                            child: Container(
                                              width: 10,
                                              height: 10,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: getStatusColor(
                                                      inspection
                                                          .getFGStatusCode())),
                                            ),
                                            alignment: Alignment.topRight,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              if (!inspection
                                                  .isinspectionSerialNoDetailCompleted()) {
                                                showDialog(
                                                    context: context,
                                                    useSafeArea: true,
                                                    builder: (_) {
                                                      return InspectionSerialNoDetail(
                                                        inspectionLotNo:
                                                            inspection
                                                                .inspectionLotNo,
                                                      );
                                                    }).then((value) {
                                                  if (mounted) setState(() {});
                                                });
                                              } else {
                                                Navigator.push(
                                                    context,
                                                    SlideLeftRoute(
                                                        page:
                                                            FGInspectionLotDetailsScreen(
                                                      inspectionLotNo:
                                                          inspection
                                                              .inspectionLotNo,
                                                    ))).then((value) {
                                                  refreshScreen();
                                                });
                                              }
                                            },
                                            child: Container(
                                              width: double.maxFinite,
                                              child: InkWell(
                                                child: Text(
                                                  'FG - 0020',
                                                  textAlign: TextAlign.center,
                                                  style: AppTextStyle
                                                      .blackRubik12
                                                      .copyWith(
                                                          decoration:
                                                              TextDecoration
                                                                  .underline,
                                                          color: AppColor
                                                              .textGray),
                                                ),
                                              ),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 18, vertical: 7),
                                              decoration: BoxDecoration(
                                                  // border: Border.all(
                                                  //     color: getStatusColor(inspection
                                                  //         .getBomStatusCode())),
                                                  border: Border.all(
                                                      color: AppColor.textGray),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(24))),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 3,
                                          ),
                                          Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              inspection.getFGStatusCode() ==
                                                      'red'
                                                  ? 'Pending'
                                                  : inspection.getFGStatusCode() ==
                                                          'orange'
                                                      ? "Upload Pending"
                                                      : inspection.getFGStatusCode() ==
                                                              'green'
                                                          ? "All done"
                                                          : '',
                                              textAlign: TextAlign.center,
                                              style: AppTextStyle.blackRubik12
                                                  .copyWith(
                                                      fontSize: 8,
                                                      color: AppColor.textGray),
                                            ),
                                          )
                                        ],
                                      )),
                                      /*Container(
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          SlideLeftRoute(
                                              page: FGInspectionLotDetailsScreen(
                                            inspectionLotNo:
                                                inspection.inspectionLotNo,
                                          )));
                                    },
                                    child: Text(
                                      'FG - 0020',
                                      style: AppTextStyle.redRubik12.copyWith(
                                          decoration: TextDecoration.underline,
                                          color: getStatusColor(
                                              inspection.getFGStatusCode())),
                                    ),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 18, vertical: 7),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: getStatusColor(
                                              inspection.getFGStatusCode())),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(24))),
                                ),*/
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Opacity(
                                opacity: 0.08,
                                child: SvgPicture.asset(
                                  Constants.geyser,
                                  width: 60,
                                  height: 60,
                                )),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          showDialog(
                              context: context,
                              useSafeArea: true,
                              builder: (_) {
                                return InspectionSerialNoDetail(
                                  inspectionLotNo: inspection.inspectionLotNo,
                                );
                              }).then((value) {
                            if (mounted) setState(() {});
                          });
                        },
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Padding(
                            padding: EdgeInsets.only(top: 8, right: 12),
                            child: SvgPicture.asset(
                              Constants.barcode,
                              width: 25,
                              height: 25,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                );
              }),
    ));
  }

  void refreshScreen() {
    if (this.mounted) {
      _inspection = InspectionUtils()
          .getInspactionByProductCatalogId(widget.productCatalogId);
      try {
        _inspection.sort((a, b) =>
            a.dateCreated.epochSecond.compareTo(b.dateCreated.epochSecond));
      } catch (e) {
        debugPrint(e.toString());
      }
      setState(() {
        list = _inspection;
      });
    }
  }

  void filterList(String text) {
    List<Inspection> tempList = [];
    _inspection?.forEach((element) {
      if (element != null &&
          element?.materialDesc != null &&
          element.materialDesc.toLowerCase().contains(text.toLowerCase())) {
        tempList.add(element);
      }
    });
    setState(() {
      list = tempList;
    });
  }

  Color getStatusColor(String fgStatusCode) {
    Color color = AppColor.red.withOpacity(0.8);
    if (fgStatusCode == 'orange') {
      color = AppColor.orange.withOpacity(0.8);
    } else if (fgStatusCode == 'green') {
      color = Colors.green.withOpacity(0.8);
    }
    return color;
  }
}
