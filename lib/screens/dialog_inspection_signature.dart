import 'dart:io';

import 'package:SomanyHIL/mixin/e_dimension.dart';
import 'package:SomanyHIL/model/inspection.dart';
import 'package:SomanyHIL/model/inspection_signature.dart';
import 'package:SomanyHIL/style/colors.dart';
import 'package:SomanyHIL/style/text_style.dart';
import 'package:SomanyHIL/utils/constants.dart';
import 'package:SomanyHIL/utils/e_image.dart';
import 'package:SomanyHIL/utils/ui_utils.dart';
import 'package:SomanyHIL/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quiver/strings.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:signature/signature.dart';

class DialogInspectionSignature extends StatefulWidget {
  final int index;
  final List<Inspection> inspectionList;

  const DialogInspectionSignature({
    Key key,
    this.index,
    this.inspectionList,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DialogInspectionSignatureState();
}

class _DialogInspectionSignatureState extends State<DialogInspectionSignature>
    with EDimension, EImage {
  TextEditingController inspectorNameController = TextEditingController();
  TextEditingController representativeNameController = TextEditingController();
  List<Inspection> list = [];
  int currentPage = 0;
  Inspection inspection;
  ItemScrollController _scrollController = ItemScrollController();
  ScrollController _scrollController1 = ScrollController();
  final SignatureController inspectorSignatureController = SignatureController(
    penStrokeWidth: 5,
    penColor: Colors.black,
    exportBackgroundColor: AppColor.white,
  );
  final SignatureController representativeSignatureController =
      SignatureController(
    penStrokeWidth: 5,
    penColor: Colors.black,
    exportBackgroundColor: AppColor.white,
  );
  bool inspectorNameValidate = false;
  bool representativeNameValidate = false;
  bool inspectorSignatureEmpty = false;
  bool representativeSignatureEmpty = false;
  bool inspectorSelected = true;
  int inspectionListSize = 0;

  @override
  void initState() {
    super.initState();
    list = widget.inspectionList;
    inspectionListSize = list.length;
    currentPage = widget.index;
    inspection = list[currentPage];
    inspectorNameController.text =
        inspection?.inspectionSignature?.inspectorName ?? '';
    representativeNameController.text =
        inspection?.inspectionSignature?.factoryRepresentativeName ?? '';
    inspectorSignatureController?.addListener(signatureListner);
    representativeSignatureController?.addListener(signatureListner);
  }

  @override
  void dispose() {
    try {
      inspectorSignatureController?.removeListener(signatureListner);
      representativeSignatureController?.removeListener(signatureListner);
    } catch (e) {}
    super.dispose();
  }

  Function signatureListner() {
    if (inspectorSignatureController.isEmpty != inspectorSignatureEmpty ||
        representativeSignatureController.isEmpty !=
            representativeSignatureEmpty) {
      inspectorSignatureEmpty = inspectorSignatureController.isEmpty;
      representativeSignatureEmpty = representativeSignatureController.isEmpty;
      setState(() {});
    }
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
                            EdgeInsets.symmetric(horizontal: 25, vertical: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Inspection Lot no.',
                              style: AppTextStyle.greyRubik13,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              inspection.inspectionLotNo ?? '',
                              style: AppTextStyle.blackRubik14,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Expanded(
                                    child: InkWell(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 0, vertical: 5),
                                    child: Text(
                                      "Inspector",
                                      style: AppTextStyle.blackRubikMedium16
                                          .copyWith(
                                              color: inspectorSelected
                                                  ? AppColor.red
                                                  : (inspectorNameController
                                                              .text
                                                              .isNotEmpty &&
                                                          inspectorSignatureController
                                                              .isNotEmpty)
                                                      ? Colors.green
                                                          .withOpacity(0.8)
                                                      : AppColor.pinGrey),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      inspectorSelected = true;
                                    });
                                  },
                                )),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                    child: InkWell(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 0, vertical: 5),
                                    child: Text(
                                      "Representative",
                                      style: AppTextStyle.blackRubikMedium16
                                          .copyWith(
                                              color: !inspectorSelected
                                                  ? AppColor.red
                                                  : (representativeNameController
                                                              .text
                                                              .isNotEmpty &&
                                                          representativeSignatureController
                                                              .isNotEmpty)
                                                      ? Colors.green
                                                          .withOpacity(0.8)
                                                      : AppColor.pinGrey),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      inspectorSelected = false;
                                    });
                                  },
                                )),
                              ],
                            ),
                            Divider(
                              color: AppColor.grey,
                            ),
                            if (inspectorSelected)
                              SizedBox(
                                height: 20,
                              ),
                            if (inspectorSelected)
                              Text(
                                'Name of the inspector',
                                style: AppTextStyle.greyRubik13,
                              ),
                            if (inspectorSelected)
                              SizedBox(
                                height: 5,
                              ),
                            if (inspectorSelected)
                              TextFormField(
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(12.0),
                                  filled: true,
                                  hintText: 'Enter Name',
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: inspectorNameValidate
                                              ? AppColor.red.withOpacity(0.8)
                                              : AppColor.dividerColor,
                                          width: 1.0),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: inspectorNameValidate
                                              ? AppColor.red.withOpacity(0.8)
                                              : AppColor.dividerColor,
                                          width: 1.0),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: inspectorNameValidate
                                              ? AppColor.red.withOpacity(0.8)
                                              : AppColor.dividerColor,
                                          width: 1.0),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  fillColor: AppColor.white,
                                  hintStyle: AppTextStyle.textHintStyle,
                                ),
                                readOnly: false,
                                showCursor: true,
                                autofocus: false,
                                cursorColor: AppColor.textBlack,
                                style: AppTextStyle.textFieldStyle,
                                controller: inspectorNameController,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                textInputAction: TextInputAction.done,
                                keyboardType: TextInputType.text,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp("[A-Za-z0-9#+-_@. ]*")),
                                ],
                                onChanged: (text) {
                                  setState(() {
                                    inspectorNameValidate = false;
                                  });
                                },
                              ),
                            if (inspectorSelected)
                              SizedBox(
                                height: 5,
                              ),
                            if (inspectorSelected)
                              Container(
                                width: double.maxFinite,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey[300],
                                  ),
                                ),
                                child: Stack(
                                  children: [
                                    Signature(
                                      controller: inspectorSignatureController,
                                      width: double.maxFinite,
                                      height: 150,
                                      backgroundColor: AppColor.white,
                                    ),
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: IconButton(
                                        icon: SvgPicture.asset(
                                          Constants.eraser,
                                          width: 20,
                                          height: 20,
                                        ),
                                        iconSize: 20,
                                        onPressed: () {
                                          inspectorSignatureController.clear();
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            /*SizedBox(
                              height: 20,
                            ),
                            Divider(
                              color: AppColor.grey,
                            ),*/

                            if (!inspectorSelected)
                              SizedBox(
                                height: 20,
                              ),
                            if (!inspectorSelected)
                              Text(
                                'Factory Representative',
                                style: AppTextStyle.greyRubik13,
                              ),
                            if (!inspectorSelected)
                              SizedBox(
                                height: 5,
                              ),
                            if (!inspectorSelected)
                              TextFormField(
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(12.0),
                                  filled: true,
                                  hintText: 'Enter Name',
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: representativeNameValidate
                                              ? AppColor.red.withOpacity(0.8)
                                              : AppColor.dividerColor,
                                          width: 1.0),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: representativeNameValidate
                                              ? AppColor.red.withOpacity(0.8)
                                              : AppColor.dividerColor,
                                          width: 1.0),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: representativeNameValidate
                                              ? AppColor.red.withOpacity(0.8)
                                              : AppColor.dividerColor,
                                          width: 1.0),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  fillColor: AppColor.white,
                                  hintStyle: AppTextStyle.textHintStyle,
                                ),
                                readOnly: false,
                                showCursor: true,
                                autofocus: false,
                                cursorColor: AppColor.textBlack,
                                style: AppTextStyle.textFieldStyle,
                                controller: representativeNameController,
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
                                    representativeNameValidate = false;
                                  });
                                },
                              ),
                            if (!inspectorSelected)
                              SizedBox(
                                height: 5,
                              ),
                            if (!inspectorSelected)
                              Container(
                                width: double.maxFinite,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey[300],
                                  ),
                                ),
                                child: Stack(
                                  children: [
                                    Signature(
                                      controller:
                                          representativeSignatureController,
                                      width: double.maxFinite,
                                      height: 150,
                                      backgroundColor: AppColor.white,
                                    ),
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: IconButton(
                                        icon: SvgPicture.asset(
                                          Constants.eraser,
                                          width: 20,
                                          height: 20,
                                        ),
                                        iconSize: 20,
                                        onPressed: () {
                                          representativeSignatureController
                                              .clear();
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 0, vertical: 16),
                              child: Row(
                                children: [
                                  Spacer(),
                                  Expanded(
                                      child: RaisedButton(
                                    onPressed: () {
                                      Utils.hideKeyBoard(context);
                                      if (currentPage < list.length) {
                                        if (inspectorSelected) {
                                          if (isEmpty(inspectorNameController
                                              .text
                                              .trim())) {
                                            setState(() {
                                              inspectorNameValidate = true;
                                            });
                                            UiUtils.showMyToast(
                                                message:
                                                    'Please enter inspector name');
                                            return;
                                          } else if (inspectorSignatureController
                                              .isEmpty) {
                                            UiUtils.showMyToast(
                                                message:
                                                    'Please enter inspector signature');
                                            return;
                                          }
                                          setState(() {
                                            inspectorSelected = false;
                                          });
                                        } else
                                        /*if (inspectorNameController
                                                .text.isNotEmpty &&
                                            inspectorSignatureController
                                                .isNotEmpty &&
                                            representativeNameController
                                                .text.isNotEmpty &&
                                            representativeSignatureController
                                                .isNotEmpty) */
                                        {
                                          gotoNextPage();
                                        }
                                      }
                                    },
                                    padding: const EdgeInsets.all(0.0),
                                    splashColor: Colors.black38,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0)),
                                    child: Ink(
                                      decoration: getOrangeButtonBg(context),
                                      padding: const EdgeInsets.all(10),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Expanded(
                                              child: Text(
                                            inspectorSelected
                                                ? "Done".toUpperCase()
                                                : "Submit".toUpperCase(),
                                            style: AppTextStyle.whiteRubik14,
                                            textAlign: TextAlign.center,
                                          ))
                                        ],
                                      ),
                                    ),
                                  )),
                                  Spacer(),
                                ],
                              ),
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
              heightFactor: 0.08,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (inspectionListSize > 1)
                    InkWell(
                      onTap: () {
                        Utils.hideKeyBoard(context);
                        if (currentPage > 0) {
                          _scrollController1.jumpTo(0);
                          setState(() {
                            currentPage = currentPage - 1;
                            inspection = list[currentPage];
                            inspectorNameValidate = false;
                            representativeNameValidate = false;
                            inspectorSelected = true;
                          });
                          inspectorNameController.text =
                              inspection?.inspectionSignature?.inspectorName ??
                                  '';
                          representativeNameController.text = inspection
                                  ?.inspectionSignature
                                  ?.factoryRepresentativeName ??
                              '';

                          _scrollController.scrollTo(
                              index: currentPage,
                              duration: Duration(seconds: 1));
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
                  if (inspectionListSize > 1)
                    SizedBox(
                      width: 10,
                    ),
                  if (inspectionListSize > 1)
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
                              color: currentPage == i
                                  ? AppColor.red
                                  : Colors.white,
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
                        gotoNextPage();
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

  void gotoNextPage() {
    if (currentPage < list.length) {
      if (isEmpty(inspectorNameController.text.trim())) {
        setState(() {
          inspectorNameValidate = true;
        });
        UiUtils.showMyToast(message: 'Please enter inspector name');
        return;
      } else if (isEmpty(representativeNameController.text.trim())) {
        setState(() {
          representativeNameValidate = true;
        });
        UiUtils.showMyToast(
            message: 'Please enter factory representative name');
        return;
      } else if (inspectorSignatureController.isEmpty) {
        UiUtils.showMyToast(message: 'Please enter inspector signature');
        return;
      } else if (representativeSignatureController.isEmpty) {
        UiUtils.showMyToast(
            message: 'Please enter factory representative signature');
        return;
      }
      var signature = InspectionSignature(
          inspectorName: inspectorNameController.text.trim(),
          factoryRepresentativeName: representativeNameController.text.trim());

      if (currentPage == list.length - 1) {
        // var pd = MyDialog.showProgressDialog(context);
        saveSignature(signature)?.then((value) {
          // pd?.hide();
          inspection.inspectionSignature = signature;
          inspection.addToFirebase(modified: false);
          Navigator.pop(context);
        });
      } else {
        // var pd = MyDialog.showProgressDialog(context);
        saveSignature(signature)?.then((value) {
          // pd?.hide();
          inspection.inspectionSignature = signature;
          inspection.addToFirebase(modified: false);
          _scrollController1.jumpTo(0);
          setState(() {
            currentPage = currentPage + 1;
            inspection = list[currentPage];
            inspectorNameValidate = false;
            representativeNameValidate = false;
            inspectorSelected = true;
          });
          inspectorNameController.text =
              inspection?.inspectionSignature?.inspectorName ?? '';
          representativeNameController.text =
              inspection?.inspectionSignature?.factoryRepresentativeName ?? '';
          inspectorSignatureController.clear();
          representativeSignatureController.clear();
          _scrollController.scrollTo(
              index: currentPage, duration: Duration(seconds: 1));
        });
      }
    }
  }

  Future<void> saveSignature(InspectionSignature signature) async {
    try {
      final tempDir = await getTemporaryDirectory();
      var file;
      if(inspection.version == null && inspection.version == ''){
        file = await new File(
            '${tempDir.path}/${inspection.inspectionLotNo+inspection.version}_inspector_signature.png')
            .create();
      }else{
        file = await new File(
            '${tempDir.path}/${inspection.inspectionLotNo}_inspector_signature.png')
            .create();
      }

      var byte = await inspectorSignatureController.toPngBytes();
      await file.writeAsBytes(byte);
      signature.inspectorSignatureId = file.path;
      var file1;
      if(inspection.version == null && inspection.version == ''){
        file1 = await new File(
            '${tempDir.path}/${inspection.inspectionLotNo+inspection.version}_representative_signature.png')
            .create();
      }else{
        file1 = await new File(
            '${tempDir.path}/${inspection.inspectionLotNo}_representative_signature.png')
            .create();
      }
      // final file1 = await new File(
      //         '${tempDir.path}/${inspection.inspectionLotNo}_representative_signature.png')
      //     .create();
      var byte1 = await representativeSignatureController.toPngBytes();
      await file1.writeAsBytes(byte1);
      signature.factoryRepresentativeSignatureId = file1.path;
    } catch (e) {
      print('error: $e');
    }
  }
}
