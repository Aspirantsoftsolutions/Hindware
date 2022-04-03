import 'package:SomanyHIL/mixin/e_dimension.dart';
import 'package:SomanyHIL/model/inspection.dart';
import 'package:SomanyHIL/screens/result_recording_screen.dart';
import 'package:SomanyHIL/screens/usage_decision_screen.dart';
import 'package:SomanyHIL/style/colors.dart';
import 'package:SomanyHIL/style/text_style.dart';
import 'package:SomanyHIL/utils/constants.dart';
import 'package:SomanyHIL/utils/inspection_utils.dart';
import 'package:SomanyHIL/utils/slide_transitions.dart';
import 'package:broadcast_events/broadcast_events.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DataMaintainScreen extends StatefulWidget {
  static const String routeName = '/DataMaintainScreen';
  final String productCatalogId;

  DataMaintainScreen(this.productCatalogId);

  @override
  State<StatefulWidget> createState() => _DataMaintainScreenState();
}

class _DataMaintainScreenState extends State<DataMaintainScreen>
    with EDimension {
  List<Inspection> _inspection;

  @override
  void initState() {
    super.initState();
    _inspection = InspectionUtils()
        .getInspactionByProductCatalogId(widget.productCatalogId);
  }

  @override
  void dispose() {
    // BroadcastEvents().publish(Constants.REFRESH_LOADING);
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
        title: Text(
          'Master data maintain (Q1)',
          style: AppTextStyle.blackRubikMedium16,
        ),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /* SizedBox(
              height: 10,
            ),*/
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    SlideLeftRoute(
                        page: ResultRecordingScreen(widget.productCatalogId)));
              },
              child: Card(
                color: AppColor.cardBlue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                SvgPicture.asset(
                                  Constants.recording,
                                  width: 71,
                                  height: 71,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                    child: Text(
                                  'QE51N',
                                  style: AppTextStyle.whiteRubik27,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ))
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              'Result recording',
                              style: AppTextStyle.whiteRubik18,
                            )
                          ],
                        ),
                      ),
                      Opacity(
                          opacity: 0.2,
                          child: SvgPicture.asset(
                            Constants.geyser,
                            width: 110,
                            height: 110,
                          )),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    SlideLeftRoute(
                        page: UsageDecisionScreen(widget.productCatalogId)));
              },
              child: Card(
                color: AppColor.cardBlue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                SvgPicture.asset(
                                  Constants.usages_decision,
                                  width: 71,
                                  height: 71,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                    child: Text(
                                  'UD',
                                  style: AppTextStyle.whiteRubik27,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ))
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              'Usage decisions',
                              style: AppTextStyle.whiteRubik18,
                            )
                          ],
                        ),
                      ),
                      Opacity(
                          opacity: 0.2,
                          child: SvgPicture.asset(
                            Constants.geyser,
                            width: 110,
                            height: 110,
                          )),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    ));
  }
}
