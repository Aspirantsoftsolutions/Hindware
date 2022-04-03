import 'package:SomanyHIL/mixin/e_dimension.dart';
import 'package:SomanyHIL/model/inspection.dart';
import 'package:SomanyHIL/model/inspection_serial_no_details.dart';
import 'package:SomanyHIL/style/colors.dart';
import 'package:SomanyHIL/style/text_style.dart';
import 'package:SomanyHIL/utils/inspection_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InspectionSerialNoDetail extends StatefulWidget {
  final String inspectionLotNo;

  InspectionSerialNoDetail({this.inspectionLotNo});

  @override
  _InspectionSerialNoDetailState createState() =>
      _InspectionSerialNoDetailState();
}

class _InspectionSerialNoDetailState extends State<InspectionSerialNoDetail>
    with EDimension {
  Inspection _inspection;
  InspectionSerialNoDetails _serialNoDetails;
  bool inspectedQuantityValidate = false;
  final TextEditingController poQualityController = TextEditingController();

  bool startSerialNoValidate = false;
  final TextEditingController startSerialNoController = TextEditingController();

  bool endSerialNoValidate = false;
  final TextEditingController endSerialNoController = TextEditingController();
  int sampleSizeLimit = 30;

  @override
  void initState() {
    super.initState();
    _inspection = InspectionUtils()
        .getInspactionByInspectionLotNo(widget.inspectionLotNo);
    _serialNoDetails =
        _inspection.inspectionSerialNoDetails ?? InspectionSerialNoDetails();
    _inspection.inspectionSerialNoDetails = _serialNoDetails;
    _serialNoDetails.sampleLotSrNo = _serialNoDetails.sampleLotSrNo ?? [];
    poQualityController.text =
        _serialNoDetails?.sampleSize?.toStringAsFixed(0) ??
            0.toStringAsFixed(0);
    startSerialNoController.text = _serialNoDetails?.lotStartSrNo ?? '';
    endSerialNoController.text = _serialNoDetails?.lotLastSrNo ?? '';
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
                            getSampleSizeWidget(),
                            SizedBox(
                              height: 16,
                            ),
                            getStartSerialNoWidget(),
                            SizedBox(
                              height: 16,
                            ),
                            getEndSerialNoWidget(),
                            SizedBox(
                              height: 28,
                            ),
                            createLotList(),
                            SizedBox(
                              height: 16,
                            ),
                          ],
                        ),
                      )),
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
                      // _inspection?.addToFirebase(modified: true);
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

  createLotList() {
    var length = _serialNoDetails?.sampleLotSrNo?.length ?? 0;
    return (length <= 0)
        ? Container()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Lot Serial No.',
                style: AppTextStyle.greyRubik13
                    .copyWith(fontSize: 16, color: Colors.black),
              ),
              SizedBox(
                height: 5,
              ),
              for (var i = 0;
                  i < _serialNoDetails?.sampleLotSrNo?.length ?? 0;
                  i++)
                getLotWidget(i),
            ],
          );
  }

  void initSampleLotNos() {
    var sampleSize = _serialNoDetails?.sampleSize ?? 0;
    var sampleList = _serialNoDetails?.sampleLotSrNo;
    List<String> termSizeList = List<String>.filled(
        int.parse(sampleSize?.round()?.toString() ?? '0'), '');
    for (var i = 0; i < sampleSize; i++) {
      termSizeList[i] = (sampleList.length >= i + 1) ? sampleList[i] : '';
    }
    _serialNoDetails?.sampleLotSrNo = termSizeList;
    debugPrint('Size: ${_serialNoDetails?.sampleLotSrNo?.length?.toString()}');
  }

  Widget getLotWidget(int index) {
    return Column(
      children: [
        SizedBox(
          height: 5,
        ),
        TextFormField(
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(12.0),
            filled: true,
            hintText: 'Lot Serial No. ${index + 1}',
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
            errorText: inspectedQuantityValidate
                ? 'Inspected Qty should be smaller than PO quantity'
                : null,
          ),
          readOnly: false,
          showCursor: true,
          autofocus: false,
          cursorColor: AppColor.textBlack,
          style: AppTextStyle.textFieldStyle,
          initialValue: _serialNoDetails?.sampleLotSrNo[index],
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.text,
          onChanged: (text) {
            _serialNoDetails?.sampleLotSrNo[index] = text;
            _inspection?.addToFirebase(modified: true);
          },
          onFieldSubmitted: (text) {},
        ),
      ],
    );
  }

  Widget getSampleSizeWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Inspection Lot Quantity',
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
          'Sample Size',
          style: AppTextStyle.textFieldStyle,
        ),
        SizedBox(
          height: 5,
        ),
        TextFormField(
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(12.0),
            filled: true,
            hintText: 'Sample Size',
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
            errorText: inspectedQuantityValidate
                ? 'Sample Size can be maximum of 30'
                : null,
          ),
          readOnly: false,
          showCursor: true,
          autofocus: false,
          cursorColor: AppColor.textBlack,
          style: AppTextStyle.textFieldStyle,
          controller: poQualityController,
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp("[0-9]*")),
          ],
          onChanged: (text) {
            var value = text.isEmpty ? 0 : double.parse(text);
            if (value == 0 || value > sampleSizeLimit) {
              if (value > sampleSizeLimit) inspectedQuantityValidate = true;
              _serialNoDetails?.sampleLotSrNo = [];
              setState(() {});
              return;
            }
            inspectedQuantityValidate = false;
            _serialNoDetails?.sampleSize = value;
            setSampleSizeWhereFrequencySampling(text);
            initSampleLotNos();
            _inspection?.addToFirebase(modified: true);
            setState(() {});
          },
          onFieldSubmitted: (text) {},
        ),
      ],
    );
  }

  Widget getStartSerialNoWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Start Serial No.',
          style: AppTextStyle.greyRubik13,
        ),
        SizedBox(
          height: 5,
        ),
        TextFormField(
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(12.0),
            filled: true,
            hintText: 'Start Serial No.',
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
            errorText: startSerialNoValidate ? 'Enter start serial no.' : null,
          ),
          readOnly: false,
          showCursor: true,
          autofocus: false,
          cursorColor: AppColor.textBlack,
          style: AppTextStyle.textFieldStyle,
          controller: startSerialNoController,
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.text,
          onChanged: (text) {
            startSerialNoValidate = false;
            _serialNoDetails?.lotStartSrNo = text;
            _inspection?.addToFirebase(modified: true);
          },
          onFieldSubmitted: (text) {},
        ),
      ],
    );
  }

  Widget getEndSerialNoWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Last Serial No.',
          style: AppTextStyle.greyRubik13,
        ),
        SizedBox(
          height: 5,
        ),
        TextFormField(
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(12.0),
            filled: true,
            hintText: 'Last Serial No.',
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
            errorText: endSerialNoValidate ? 'Enter last serial no.' : null,
          ),
          readOnly: false,
          showCursor: true,
          autofocus: false,
          cursorColor: AppColor.textBlack,
          style: AppTextStyle.textFieldStyle,
          controller: endSerialNoController,
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.text,
          onChanged: (text) {
            endSerialNoValidate = false;
            _serialNoDetails?.lotLastSrNo = text;
            _inspection?.addToFirebase(modified: true);
          },
          onFieldSubmitted: (text) {},
        ),
      ],
    );
  }

  void setSampleSizeWhereFrequencySampling(String text) {
    if ((text ?? '').isNotEmpty) {
      if (_inspection?.bomInspectionDetails != null) {
        for (var bomDetail in _inspection?.bomInspectionDetails) {
          if (bomDetail.samplingFreqType == true) {
            bomDetail.frequency = text;
          }
        }
      }

      if (_inspection?.fgInspectionDetails != null) {
        for (var fgDetail in _inspection?.fgInspectionDetails) {
          if (fgDetail.samplingFreqType == true) {
            fgDetail.frequency = text;
          }
        }
      }
    }
  }
}
