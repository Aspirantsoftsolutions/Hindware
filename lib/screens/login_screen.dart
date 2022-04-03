import 'package:SomanyHIL/mixin/e_dimension.dart';
import 'package:SomanyHIL/model/login_data.dart';
import 'package:SomanyHIL/utils/my_dialogs.dart';
import 'package:SomanyHIL/viewmodel/login_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quiver/strings.dart';

import '../rest/eightfolds_retrofit.dart';
import '../style/colors.dart';
import '../style/text_style.dart';
import '../utils/constants.dart';
import '../utils/utils.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/LoginScreen';

  @override
  State<StatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with EDimension {
  final _usernameFocusNode = FocusNode();
  final TextEditingController usernameController = TextEditingController();

  bool usernameValidate = false;
  final _passwordFocusNode = FocusNode();
  final TextEditingController passwordController = TextEditingController();

  bool passwordValidate = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          backgroundColor: AppColor.backgroundColor,
          body: Container(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 117),
                  Text(
                    'Welcome',
                    style: AppTextStyle.blackSegoeUISemiBold36,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  Image.asset(
                    Constants.logo,
                    width: getWidthAsPerScreenRatio(context, 40),
                    height: getWidthAsPerScreenRatio(context, 25),
                  ),
                  SizedBox(height: 56),
                  TextFormField(
                      focusNode: _usernameFocusNode,
                      decoration: InputDecoration(
                        filled: true,
                        labelText: 'User name',
                        labelStyle: AppTextStyle.textHintStyle,
                        hintText: 'User name',
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: AppColor.dividerColor, width: 1.0),
                            borderRadius: BorderRadius.all(
                                Radius.circular(10))),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: AppColor.dividerColor, width: 1.0),
                            borderRadius: BorderRadius.all(
                                Radius.circular(10))),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: AppColor.dividerColor, width: 1.0),
                            borderRadius: BorderRadius.all(
                                Radius.circular(10))),
                        fillColor: AppColor.white,
                        hintStyle: AppTextStyle.textHintStyle,
                        errorText:
                        usernameValidate ? 'Enter valid user name' : null,
                      ),

                      // onTap: () {
                      //   Utils.hideKeyBoard(context);
                      //   // onWidgetsClick(Constants.LOGIN_WITH_EMAIL_FULL, null);
                      // },
                      readOnly: false,
                      showCursor: true,
                      autofocus: false,
                      cursorColor: AppColor.textBlack,
                      style: AppTextStyle.textFieldStyle,
                      controller: usernameController,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp("[A-Za-z0-9#+-_@.]*")),
                      ],
                      onChanged: (text) {
                        setState(() {
                          usernameValidate = false;
                        });
                      },
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_passwordFocusNode);
                      }),
                  SizedBox(height: 30),
                  TextFormField(
                    focusNode: _passwordFocusNode,
                    decoration: InputDecoration(
                      filled: true,
                      labelText: 'Password',
                      labelStyle: AppTextStyle.textHintStyle,
                      hintText: 'Password',
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
                      fillColor: AppColor.white,
                      hintStyle: AppTextStyle.textHintStyle,
                      errorText: passwordValidate
                          ? 'Enter valid password'
                          : null,
                    ),

                    // onTap: () {
                    //   Utils.hideKeyBoard(context);
                    //   // onWidgetsClick(Constants.LOGIN_WITH_EMAIL_FULL, null);
                    // },
                    readOnly: false,
                    showCursor: true,
                    autofocus: false,
                    cursorColor: AppColor.textBlack,
                    style: AppTextStyle.textFieldStyle,
                    controller: passwordController,
                    textInputAction: TextInputAction.done,
                    obscureText: true,
                    obscuringCharacter: '*',
                    keyboardType: TextInputType.visiblePassword,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp("[A-Za-z0-9#+-_@.]*")),
                    ],
                    onChanged: (text) {
                      setState(() {
                        passwordValidate = false;
                      });
                    },
                  ),
                  SizedBox(height: 30),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: RaisedButton(
                      onPressed: () {
                        Utils.hideKeyBoard(context);
                        /*  showDialog(
                          context: context,
                          useSafeArea: true,
                          barrierDismissible: false,
                          builder: (_) {
                            return DialogSignInConfirmation(
                                "Please complete email verification.\nVerification link is sent to your registered email id",
                                () {});
                          });*/

                        if (isEmpty(usernameController.text.trim())) {
                          setState(() {
                            usernameValidate = true;
                          });
                          return;
                        } else if (isEmpty(passwordController.text.trim())) {
                          setState(() {
                            passwordValidate = true;
                          });
                          return;
                        }
                        EightFoldsRetrofit.isNetworkAvailable()?.then((value1) {
                          if (value1) {
                            var pd = MyDialog.showProgressDialog(context);
                            LoginViewModel.login(
                                context, usernameController.text.trim(),
                                passwordController.text.trim())
                                ?.then((value) {
                              Utils.hideDialog(pd);
                              if (value != null && value is LoginData) {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HomeScreen(),
                                    ));
                              }
                            });
                          }
                        });
                      },
                      padding: const EdgeInsets.all(0.0),
                      splashColor: Colors.black38,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      child: Ink(
                        decoration: getOrangeButtonBg(context),
                        padding: const EdgeInsets.all(17),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Login".toUpperCase(),
                              style: AppTextStyle.whiteRubik14,
                              textAlign: TextAlign.center,
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
