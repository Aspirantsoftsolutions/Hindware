import 'package:SomanyHIL/mixin/common_data.dart';
import 'package:SomanyHIL/mixin/e_dimension.dart';
import 'package:SomanyHIL/model/inspection.dart';
import 'package:SomanyHIL/model/product_catalog.dart';
import 'package:SomanyHIL/screens/usage_decision_details_screen.dart';
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

class UsageDecisionScreen extends StatefulWidget {
  final String productCatalogId;

  UsageDecisionScreen(this.productCatalogId);

  @override
  State<StatefulWidget> createState() => _UsageDecisionScreenState();
}

class _UsageDecisionScreenState extends State<UsageDecisionScreen>
    with EDimension, CommonData {
  bool search = false;

  List<Inspection> _inspection = List<Inspection>();
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

    // BroadcastEvents().subscribe(Constants.REFRESH_UG_COLOR, (args) {
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
    // BroadcastEvents().unsubscribe(Constants.REFRESH_UG_COLOR);
    super.dispose();
  }

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
                'Usage decisions',
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
                // debugPrint(inspection?.dateCreated?.stringDate());
                return InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        SlideLeftRoute(
                            page: UsageDecisionDetailsScreen(
                          inspectionLotNo: inspection.inspectionLotNo,
                        ))).then((value) {
                      refreshScreen();
                    });
                  },
                  child: Card(
                    color: AppColor.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16))),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 25, vertical: 16),
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
                                          color: getStatusColor(
                                              inspection.getUDStatusCode())),
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
                                      inspection.getUDStatusCode() == 'red'
                                          ? 'Pending'
                                          : inspection.getUDStatusCode() ==
                                                  'orange'
                                              ? "Upload Pending"
                                              : inspection.getUDStatusCode() ==
                                                      'green'
                                                  ? "All done"
                                                  : '',
                                      textAlign: TextAlign.center,
                                      style: AppTextStyle.greyRubik13
                                          .copyWith(fontSize: 8),
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
                                SizedBox(
                                  height: 3,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
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
    if (fgStatusCode == 'green') {
      color = Colors.green.withOpacity(0.8);
    }
    return color;
  }
}
