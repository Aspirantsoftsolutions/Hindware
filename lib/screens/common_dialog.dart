import 'package:SomanyHIL/mixin/e_dimension.dart';
import 'package:SomanyHIL/style/colors.dart';
import 'package:SomanyHIL/style/text_style.dart';
import 'package:SomanyHIL/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CommonDialog extends StatefulWidget {
  final String title;
  final String message;
  final String yesText;
  final String noText;
  final Function callBack;

  const CommonDialog(
      {Key key,
      this.title,
      this.message,
      this.yesText,
      this.noText,
      this.callBack})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _CommonDialogState();
}

class _CommonDialogState extends State<CommonDialog> with EDimension {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
                      widget.title ?? 'Alert',
                      style: AppTextStyle.blackRubikMedium22,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    Text(
                      widget.message ?? "",
                      style: AppTextStyle.blackRubikMedium16,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: RaisedButton(
                          onPressed: () {
                            Utils.hideKeyBoard(context);
                            widget.callBack();
                            Navigator.pop(context);
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
                                  widget.yesText != null
                                      ? widget.yesText
                                      : "Yes",
                                  style: AppTextStyle.whiteRubik14,
                                  textAlign: TextAlign.center,
                                ))
                              ],
                            ),
                          ),
                        )),
                        if (widget.noText != null)
                          SizedBox(
                            width: 10,
                          ),
                        if (widget.noText != null)
                          Expanded(
                              child: RaisedButton(
                            onPressed: () {
                              Utils.hideKeyBoard(context);
                              Navigator.pop(context);
                            },
                            padding: const EdgeInsets.all(0.0),
                            splashColor: Colors.black38,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Ink(
                              decoration: getBlackButtonBg(context),
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                      child: Text(
                                    widget.noText != null
                                        ? widget.noText
                                        : "No",
                                    style: AppTextStyle.whiteRubik14,
                                    textAlign: TextAlign.center,
                                  ))
                                ],
                              ),
                            ),
                          )),
                      ],
                    )
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
