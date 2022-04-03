import 'package:SomanyHIL/mixin/e_dimension.dart';
import 'package:SomanyHIL/model/inspection.dart';
import 'package:SomanyHIL/style/colors.dart';
import 'package:SomanyHIL/style/text_style.dart';
import 'package:SomanyHIL/utils/constants.dart';
import 'package:SomanyHIL/utils/ui_utils.dart';
import 'package:SomanyHIL/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DialogUserDecision extends StatefulWidget {
  final Inspection inspection;
  final Function callBack;

  const DialogUserDecision({Key key, this.inspection, this.callBack})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _DialogUserDecisionState();
}

class _DialogUserDecisionState extends State<DialogUserDecision>
    with EDimension {
  TextEditingController commentController = TextEditingController();
  bool showComment = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    commentController.text = widget?.inspection?.remarks ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: AppColor.textBlack.withOpacity(0.9),
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(10),
        child: Wrap(
          children: [
            Card(
              color: AppColor.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16))),
              child: Container(
                padding: EdgeInsets.all(25),
                child: Column(
                  children: [
                    Text(
                      'User decision',
                      style: AppTextStyle.blackRubikMedium16,
                    ),
                    SizedBox(
                      height: 22,
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: RaisedButton(
                          onPressed: () {
                            Utils.hideKeyBoard(context);
                            setState(() {
                              widget.inspection.decision = 1;
                              // widget.inspection.versions.add(widget.inspection);
                            });
                            // widget.callBack(Constants.SAVE_INSPACTION);
                            // Navigator.pop(context);
                          },
                          padding: const EdgeInsets.all(0.0),
                          splashColor: Colors.black38,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          child: Ink(
                            decoration: widget.inspection.decision == 1
                                ? getOrangeButtonBg(context)
                                : getBlackButtonBg(context),
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                    child: Text(
                                  "Accept",
                                  style: AppTextStyle.whiteRubik14,
                                  textAlign: TextAlign.center,
                                ))
                              ],
                            ),
                          ),
                        )),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                            child: RaisedButton(
                          onPressed: () {
                            Utils.hideKeyBoard(context);
                            setState(() {
                              widget.inspection.decision = 2;
                            });
                            // widget.callBack(Constants.SAVE_INSPACTION);
                            // Navigator.pop(context);
                          },
                          padding: const EdgeInsets.all(0.0),
                          splashColor: Colors.black38,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Ink(
                            decoration: widget.inspection.decision == 2
                                ? getOrangeButtonBg(context)
                                : getBlackButtonBg(context),
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                    child: Text(
                                  "Reject",
                                  style: AppTextStyle.whiteRubik14,
                                  textAlign: TextAlign.center,
                                ))
                              ],
                            ),
                          ),
                        )),
                      ],
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    if (widget.inspection.decision == 2)
                      TextFormField(
                        decoration: InputDecoration(
                          filled: true,
                          hintText: 'UD short text',
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
                          fillColor: AppColor.white,
                          hintStyle: AppTextStyle.textHintStyle,
                        ),
                        readOnly: false,
                        showCursor: true,
                        autofocus: false,
                        minLines: 5,
                        maxLines: 5,
                        textAlign: TextAlign.start,
                        cursorColor: AppColor.textBlack,
                        style: AppTextStyle.textFieldStyle,
                        controller: commentController,
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.text,
                        textCapitalization: TextCapitalization.sentences,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp("[A-Za-z0-9#+-_@. ]*")),
                        ],
                        onChanged: (text) {
                          setState(() {
                            widget.inspection.remarks = text;
                          });
                        },
                      ),
                    if (widget.inspection.decision != 2)
                      Container(
                        height: getHeightAsPerScreenRatio(context, 12),
                      ),
                    SizedBox(
                      height: 24,
                    ),
                    RaisedButton(
                      onPressed: () {
                        Utils.hideKeyBoard(context);
                        if (widget.inspection.decision == 1) {
                          widget.inspection.remarks = '';
                        }
                        if (widget.inspection.decision == 2 &&
                            commentController.text.isEmpty) {
                          UiUtils.showMyToast(
                              message: 'Please enter UD short text');
                          return;
                        }
                        widget.callBack(Constants.SAVE_INSPACTION);
                        Navigator.pop(context);
                      },
                      padding: const EdgeInsets.all(0.0),
                      splashColor: Colors.black38,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Ink(
                        decoration: getOrangeButtonBg(context),
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                                child: Text(
                              "SUBMIT",
                              style: AppTextStyle.whiteRubik14,
                              textAlign: TextAlign.center,
                            ))
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    ));
  }
}
