import 'package:SomanyHIL/mixin/e_dimension.dart';
import 'package:SomanyHIL/model/inspection.dart';
import 'package:SomanyHIL/model/inspection_overall_observation.dart';
import 'package:SomanyHIL/screens/dialog_remove_image.dart';
import 'package:SomanyHIL/style/colors.dart';
import 'package:SomanyHIL/style/text_style.dart';
import 'package:SomanyHIL/utils/inspection_utils.dart';
import 'package:SomanyHIL/utils/ui_utils.dart';
import 'package:SomanyHIL/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InspectionOverAllObservationDetail extends StatefulWidget {
  final String inspectionLotNo;

  InspectionOverAllObservationDetail({this.inspectionLotNo});

  @override
  _InspectionSerialNoDetailState createState() =>
      _InspectionSerialNoDetailState();
}

class _InspectionSerialNoDetailState
    extends State<InspectionOverAllObservationDetail> with EDimension {
  Inspection _inspection;
  List<InspectionOverallObservation> overallObservations = [];
  int sampleSizeLimit = 10;

  @override
  void initState() {
    super.initState();
    _inspection = InspectionUtils()
        .getInspactionByInspectionLotNo(widget.inspectionLotNo);
    overallObservations =
        _inspection.overallObservations ?? overallObservations;
    var size = overallObservations.length;
    if (size <= 0) {
      overallObservations.add(InspectionOverallObservation());
    }
    _inspection.overallObservations = overallObservations;
  }

  @override
  Widget build(BuildContext context) {
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
              heightFactor: 0.9,
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
                        padding:
                            EdgeInsets.symmetric(horizontal: 25, vertical: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (var i = 0;
                                i < overallObservations?.length ?? 0;
                                i++)
                              getObservationWidget(i),
                          ],
                        ),
                      )),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(60, 10, 60, 10),
                        child: RaisedButton(
                          onPressed: () {
                            Utils.hideKeyBoard(context);
                            var observationSize = overallObservations.length;
                            if (observationSize > 0) {
                              var lastObservation = overallObservations[
                                  overallObservations.length - 1];
                              if ((lastObservation.actionTaken?.isEmpty ??
                                      true) ||
                                  (lastObservation.observations?.isEmpty ??
                                      true) ||
                                  (lastObservation.status?.isEmpty ?? true)) {
                                UiUtils.showMyToast(
                                    message: 'Please enter details');
                                return;
                              }
                            }
                            if (overallObservations.length > sampleSizeLimit) {
                              UiUtils.showMyToast(
                                  message:
                                      'Maximum $sampleSizeLimit observation allowed');
                              return;
                            }
                            overallObservations
                                .add(InspectionOverallObservation());

                            setState(() {});
                          },
                          padding: const EdgeInsets.all(0.0),
                          splashColor: Colors.black38,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          child: Ink(
                            decoration: getOrangeButtonBg(context),
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              "Add New Observation",
                              style: AppTextStyle.whiteRubik14,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            FractionallySizedBox(
              alignment: Alignment.bottomCenter,
              heightFactor: 0.1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      child: Text(
                        '',
                        style: AppTextStyle.whiteRubik14,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      overallObservations?.removeWhere((element) =>
                          ((element.observations?.isEmpty ?? true) &&
                              (element.actionTaken?.isEmpty ?? true) &&
                              (element.status?.isEmpty ?? true)));
                      _inspection?.addToFirebase(modified: false);
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      child: Container(
                        decoration: getOrangeButtonBg(context),
                        padding: EdgeInsets.fromLTRB(18, 8, 18, 8),
                        child: Text(
                          'Submit',
                          style: AppTextStyle.whiteRubik14,
                        ),
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

  Widget getObservationWidget(int index) {
    return Card(
      color: AppColor.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16))),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            addObservation(index),
            SizedBox(
              height: 10,
            ),
            addActionTaken(index),
            SizedBox(
              height: 10,
            ),
            addStatus(index),
          ],
        ),
      ),
    );
  }

  addObservation(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Observation ${index + 1}',
              style: AppTextStyle.greyRubik13,
            ),
            InkWell(
              child: Container(
                width: 20,
                height: 20,
                margin: EdgeInsets.symmetric(horizontal: 6, vertical: 6),
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
                        message: 'Do you want to remove observetion?',
                        callBack: () {
                          debugPrint('Index $index');
                          overallObservations.removeAt(index);
                          _inspection.overallObservations = overallObservations;
                          setState(() {});
                        },
                      );
                    });
              },
            ),
          ],
        ),
        SizedBox(
          height: 5,
        ),
        TextFormField(
          key: Key(overallObservations[index].observations),
          initialValue: overallObservations[index].observations ?? '',
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(12.0),
            filled: true,
            hintText: 'Observation',
            enabledBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: AppColor.dividerColor, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            border: OutlineInputBorder(
                borderSide:
                    BorderSide(color: AppColor.dividerColor, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            focusedBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: AppColor.dividerColor, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            errorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: AppColor.red.withOpacity(0.8), width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            fillColor: AppColor.white,
            hintStyle: AppTextStyle.textHintStyle,
          ),
          readOnly: false,
          showCursor: true,
          autofocus: false,
          cursorColor: AppColor.textBlack,
          style: AppTextStyle.textFieldStyle,
          // initialValue: _serialNoDetails?.sampleLotSrNo[index],
          textInputAction: TextInputAction.newline,
          maxLines: 4,
          keyboardType: TextInputType.multiline,
          onChanged: (text) {
            overallObservations[index].observations = text;
            // _serialNoDetails?.sampleLotSrNo[index] = text;
            // _inspection?.addToFirebase(modified: true);
          },
          onFieldSubmitted: (text) {},
        ),
      ],
    );
  }

  addActionTaken(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Action Taken',
          style: AppTextStyle.greyRubik13,
        ),
        SizedBox(
          height: 5,
        ),
        TextFormField(
          key: Key(overallObservations[index].actionTaken),
          initialValue: overallObservations[index].actionTaken ?? '',
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(12.0),
            filled: true,
            hintText: 'Action Taken',
            enabledBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: AppColor.dividerColor, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            border: OutlineInputBorder(
                borderSide:
                    BorderSide(color: AppColor.dividerColor, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            focusedBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: AppColor.dividerColor, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            errorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: AppColor.red.withOpacity(0.8), width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            fillColor: AppColor.white,
            hintStyle: AppTextStyle.textHintStyle,
          ),
          readOnly: false,
          showCursor: true,
          autofocus: false,
          cursorColor: AppColor.textBlack,
          style: AppTextStyle.textFieldStyle,
          // initialValue: _serialNoDetails?.sampleLotSrNo[index],
          textInputAction: TextInputAction.done,
          keyboardType: TextInputType.text,
          onChanged: (text) {
            overallObservations[index].actionTaken = text;
            // _serialNoDetails?.sampleLotSrNo[index] = text;
            // _inspection?.addToFirebase(modified: true);
          },
          onFieldSubmitted: (text) {},
        ),
      ],
    );
  }

  addStatus(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Status',
          style: AppTextStyle.greyRubik13,
        ),
        SizedBox(
          height: 5,
        ),
        TextFormField(
          key: Key(overallObservations[index].status),
          initialValue: overallObservations[index].status ?? '',
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(12.0),
            filled: true,
            hintText: 'Status',
            enabledBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: AppColor.dividerColor, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            border: OutlineInputBorder(
                borderSide:
                    BorderSide(color: AppColor.dividerColor, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            focusedBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: AppColor.dividerColor, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            errorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: AppColor.red.withOpacity(0.8), width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            fillColor: AppColor.white,
            hintStyle: AppTextStyle.textHintStyle,
          ),
          readOnly: false,
          showCursor: true,
          autofocus: false,
          cursorColor: AppColor.textBlack,
          style: AppTextStyle.textFieldStyle,
          // initialValue: _serialNoDetails?.sampleLotSrNo[index],
          textInputAction: TextInputAction.done,
          keyboardType: TextInputType.text,
          onChanged: (text) {
            overallObservations[index].status = text;
            // _serialNoDetails?.sampleLotSrNo[index] = text;
            // _inspection?.addToFirebase(modified: true);
          },
          onFieldSubmitted: (text) {},
        ),
      ],
    );
  }
}
