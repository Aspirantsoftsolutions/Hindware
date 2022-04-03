import 'dart:async';
import 'dart:convert';

import 'package:SomanyHIL/firebase/firebase_utils.dart';
import 'package:SomanyHIL/mixin/commom_ui.dart';
import 'package:SomanyHIL/mixin/e_dimension.dart';
import 'package:SomanyHIL/model/login_data.dart';
import 'package:SomanyHIL/model/product_catalog.dart';
import 'package:SomanyHIL/screens/common_dialog.dart';
import 'package:SomanyHIL/screens/data_maintain_screen.dart';
import 'package:SomanyHIL/screens/dialog_inspection_signature.dart';
import 'package:SomanyHIL/screens/inspection_history.dart';
import 'package:SomanyHIL/screens/splash_screen.dart';
import 'package:SomanyHIL/screens/usage_decision_screen.dart';
import 'package:SomanyHIL/services/push_notification_service.dart';
import 'package:SomanyHIL/utils/e_image.dart';
import 'package:SomanyHIL/utils/inspection_utils.dart';
import 'package:SomanyHIL/utils/slide_transitions.dart';
import 'package:SomanyHIL/viewmodel/home_viewmodel.dart';
import 'package:SomanyHIL/widgets/product_card.dart';
import 'package:broadcast_events/broadcast_events.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../rest/eightfolds_retrofit.dart';
import '../style/colors.dart';
import '../style/text_style.dart';
import '../utils/constants.dart';
import '../utils/utils.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/HomeScreen';

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with EDimension, CommomUi, WidgetsBindingObserver {
  LoginData loginData;
  List<ProductCatalog> items = [];
  Query messageQuery;
  StreamSubscription<QuerySnapshot> streamSub;
  bool loading = false;
  bool initFirebase = false;
  bool allSync = true;
  bool paused = false;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (this.mounted)
        setState(() {
          loading = InspectionUtils().isSyncStarted ||
              InspectionUtils().isUploadingImages ||
              InspectionUtils().fileDownload;
        });
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  void initState() {
    super.initState();

    PushNotificationService.submitDeviceInfo();
    _initSavedComments();
    loading = InspectionUtils().isSyncStarted ||
        InspectionUtils().isUploadingImages ||
        InspectionUtils().fileDownload;
    Utils.getFromSharedPraferances(Constants.LOGIN_DATA)?.then((value) {
      if (value != null) {
        var data = LoginData.fromJson(jsonDecode(value));
        _getAssignedInspections(data);
        setState(() {
          loginData = data;
        });
      }
      getPaginatedData();
    });
    BroadcastEvents().unsubscribe(Constants.SYNC_STARTED);
    BroadcastEvents().subscribe(Constants.SYNC_STARTED, (args) {
      if (args is bool) {
        if (this.mounted)
          setState(() {
            // loading = args;
            loading = InspectionUtils().isSyncStarted ||
                InspectionUtils().isUploadingImages ||
                InspectionUtils().fileDownload;
          });
      }
    });
    // BroadcastEvents().subscribe(Constants.REFRESH_LOADING, (args) {
    //   if (this.mounted) {
    //     setState(() {
    //       loading = InspectionUtils().isSyncStarted ||
    //           InspectionUtils().isUploadingImages;
    //     });
    //     goForSync();
    //   }
    // });
  }

  Future _getAssignedInspections(LoginData data) async {
    await FirebaseUtils.firebaseCustomLogin(data.firebaseToken);
    FirebaseUtils.userId = data.userId;
    messageQuery = FirebaseUtils.getUsersReference();
    streamSub = messageQuery.snapshots().listen((change) {
      if (initFirebase &&
          InspectionUtils().isAnyNewInspection(change.docChanges)) {
        debugPrint('Download image on new inspection added');
        initFirebase = false;
      }

      InspectionUtils().updateChangedDoc(change.docChanges);
      setStatusColor();

      if (!initFirebase) {
        initFirebase = true;
        // showSignatureDialog();
        goForSync();
        goForFileDownload();
        /*List<Inspection> list = [];
        list.addAll(InspectionUtils().assignedInspevtion ?? []);
        showDialog(
            context: context,
            useSafeArea: true,
            builder: (_) {
              return DialogInspectionSignature(
                index: 0,
                inspectionList: list,
                callBack: (int type) {},
              );
            }).then((value) {
          if (mounted) setState(() {});
        });*/
      }
    });
  }

  void dispose() {
    streamSub?.cancel();
    // BroadcastEvents().unsubscribe(Constants.SYNC_STARTED);
    // BroadcastEvents().unsubscribe(Constants.REFRESH_LOADING);
    super.dispose();
  }

  _initSavedComments() {
    Utils.getFromSharedPraferances(Constants.PRODUCTS).then((value) {
      if (value != null) {
        var tagsJson = jsonDecode(value) as List;
        List<ProductCatalog> comments = tagsJson
            .map((tagJson) => ProductCatalog.fromJson(tagJson))
            .toList();

        if (items.length <= 0 && (comments?.length ?? 0) > 0) {
          setState(() {
            items = comments;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: AppColor.backgroundColor,
            body: Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRRect(
                        child: CachedNetworkImage(
                          imageUrl: loginData != null &&
                                  loginData.profilePicId != null
                              ? EightFoldsRetrofit.GET_FILE_URL +
                                  loginData.profilePicId
                              : EightFoldsRetrofit.GET_FILE_URL,
                          width: 54,
                          height: 54,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Image(
                              fit: BoxFit.contain,
                              image: AssetImage(Constants.defaultUser)),
                          errorWidget: (context, url, error) => Image(
                              fit: BoxFit.contain,
                              image: AssetImage(Constants.defaultUser)),
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: InkWell(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Hello ${loginData != null && loginData.displayName != null ? loginData.displayName : ''}!",
                              style: AppTextStyle.blackRubikMedium22,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "Welcome back to your account",
                              style: AppTextStyle.greyRubik13,
                            ),
                          ],
                        )),
                      ),
                      Container(
                        width: 50,
                        height: 50,
                        child: Stack(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              alignment: Alignment.center,
                              child: loading
                                  ? CupertinoActivityIndicator()
                                  : IconButton(
                                      icon: Icon(
                                        Icons.sync,
                                        color: AppColor.black,
                                      ),
                                      onPressed: () {
                                        goForSync();
                                      },
                                      tooltip: 'Sync',
                                    ),
                            ),
                            Align(
                              alignment: Alignment.topRight,
                              child: Container(
                                width: 10,
                                height: 10,
                                margin: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: InspectionUtils()
                                            .anyFilePendingToUpload()
                                        ? AppColor.red.withOpacity(0.8)
                                        : Colors.green.withOpacity(0.8)),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 45,
                  ),
                  Text(
                    "Our services",
                    style: AppTextStyle.blackRubikMedium22,
                  ),
                  SizedBox(
                    height: 18,
                  ),
                  Expanded(
                      child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 0),
                    child: _getGridView(),
                  )),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 0, 20),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context, SlideLeftRoute(page: InspectionHistory()));
                      },
                      child: Row(
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            child: EImage.getSvgImage(
                              'history.svg',
                              fColor: AppColor.darkGreen,
                            ),
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 10, right: 10, bottom: 10),
                            child: Text(
                              "View History",
                              style: AppTextStyle.redRubik16
                                  .copyWith(color: AppColor.darkGreen),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                showDialog(
                    context: context,
                    useSafeArea: true,
                    builder: (_) {
                      return CommonDialog(
                        callBack: () {
                          Utils.logout(context)
                              ?.then((value) => Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SplashScreen(),
                                  )));
                        },
                        title: "Logout",
                        message: "Do you really want to logout?",
                        yesText: "Yes",
                        noText: "No",
                      );
                    });
              },
              child: const Icon(
                Icons.logout,
                color: Colors.white,
                size: 20,
              ),
              mini: true,
              backgroundColor: Color(0xFFF5A442),
            )));
  }

  Widget _getGridView() {
    return GridView.builder(
        shrinkWrap: true,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: items.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 1 / 1.25,
            crossAxisCount: 3,
            crossAxisSpacing: 11.0,
            mainAxisSpacing: 10.0),
        itemBuilder: (context, index) {
          return ProductCard(items[index], () {
            setState(() {
              paused = true;
            });
            Navigator.push(
                    context,
                    SlideLeftRoute(
                        page:
                            DataMaintainScreen(items[index].productCatalogId)))
                .then((value) {
              if (this.mounted) {
                setState(() {
                  paused = false;
                  loading = InspectionUtils().isSyncStarted ||
                      InspectionUtils().isUploadingImages ||
                      InspectionUtils().fileDownload;
                });
                // showSignatureDialog();
                goForSync();
              }
              // setStatusColor();
            });
          });
        });
  }

  void getPaginatedData() {
    HomeViewModel.getAllProducts(context).then((value) {
      if (value != null && value is List<ProductCatalog> && value.isNotEmpty) {
        setState(() {
          items = value;
        });
      }
    });
  }

  void goForSync() {
    InspectionUtils().inUseInspectionLotNo = null;
    EightFoldsRetrofit.isNetworkAvailable(showToast: false).then((value) {
      if (value) {
        setState(() {
          loading = true;
        });
        InspectionUtils().uploadAllInspection();
      }
    });
  }

  void goForFileDownload() {
    EightFoldsRetrofit.isNetworkAvailable(showToast: false).then((value) {
      if (value) {
        setState(() {
          loading = true;
        });
        InspectionUtils().downloadRefImages();
      }
    });
  }

  void setStatusColor() {
    if (mounted) {
      setState(() {
        allSync = !InspectionUtils().anyFilePendingToUpload();
      });
    }
  }

  void showSignatureDialog() {
    if (!paused &&
        InspectionUtils().getPendingSignatureInspection().length > 0) {
      showDialog(
          context: context,
          useSafeArea: true,
          builder: (_) {
            return DialogInspectionSignature(
              index: 0,
              inspectionList: InspectionUtils().getPendingSignatureInspection(),
            );
          }).then((value) {
        goForSync();
      });
    }
  }
}
