import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:geolocator/geolocator.dart';
import 'package:talabiapp/controller/auth_controller.dart';
import 'package:talabiapp/controller/cart_controller.dart';
import 'package:talabiapp/controller/location_controller.dart';
import 'package:talabiapp/controller/splash_controller.dart';
import 'package:talabiapp/controller/wishlist_controller.dart';
import 'package:talabiapp/data/model/body/notification_body.dart';
import 'package:talabiapp/helper/route_helper.dart';
import 'package:talabiapp/util/app_constants.dart';
import 'package:talabiapp/util/dimensions.dart';
import 'package:talabiapp/util/images.dart';
import 'package:talabiapp/util/styles.dart';
import 'package:talabiapp/view/base/no_internet_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  final NotificationBody? body;
  const SplashScreen({Key? key, required this.body}) : super(key: key);

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey();
  late StreamSubscription<ConnectivityResult> _onConnectivityChanged;

  @override
  void initState() {
    super.initState();

    bool firstTime = true;
    _onConnectivityChanged = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if(!firstTime) {
        bool isNotConnected = result != ConnectivityResult.wifi && result != ConnectivityResult.mobile;
        isNotConnected ? const SizedBox() : ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: isNotConnected ? Colors.red : Colors.green,
          duration: Duration(seconds: isNotConnected ? 6000 : 3),
          content: Text(
            isNotConnected ? 'no_connection'.tr : 'connected'.tr,
            textAlign: TextAlign.center,
          ),
        ));
        if(!isNotConnected) {
          _route();
        }
      }
      firstTime = false;
    });

    Get.find<SplashController>().initSharedData();
    Get.find<CartController>().getCartData();
    _route();

  }

  @override
  void dispose() {
    super.dispose();

    _onConnectivityChanged.cancel();
  }

  void _route() {
    Get.find<SplashController>().getConfigData().then((isSuccess) {
      if(isSuccess) {
      
        Timer(const Duration(seconds: 1), () async {
          double? minimumVersion = 0;
          if(GetPlatform.isAndroid) {
            minimumVersion = Get.find<SplashController>().configModel!.appMinimumVersionAndroid;
          }else if(GetPlatform.isIOS) {
            minimumVersion = Get.find<SplashController>().configModel!.appMinimumVersionIos;
          }
          if(AppConstants.appVersion < minimumVersion! || Get.find<SplashController>().configModel!.maintenanceMode!) {
            Get.offNamed(RouteHelper.getUpdateRoute(AppConstants.appVersion < minimumVersion));
          }else {
            if(widget.body != null) {
              if (widget.body!.notificationType == NotificationType.order) {
                Get.offNamed(RouteHelper.getOrderDetailsRoute(widget.body!.orderId, fromNotification: true));
              }else if(widget.body!.notificationType == NotificationType.general){
                Get.offNamed(RouteHelper.getNotificationRoute(fromNotification: true));
              }else {
                Get.offNamed(RouteHelper.getChatRoute(notificationBody: widget.body, conversationID: widget.body!.conversationId, fromNotification: true));
              }
            }else {
              if (Get.find<AuthController>().isLoggedIn()) {
                Get.find<AuthController>().updateToken();
                if (Get.find<LocationController>().getUserAddress() != null) {
                  await Get.find<WishListController>().getWishList();
                  Get.offNamed(RouteHelper.getInitialRoute(fromSplash: true));
                } else {
                  Get.find<LocationController>().navigateToLocationScreen('splash', offNamed: true);
                }
              } else {
                if (Get.find<SplashController>().showIntro()!) {
                  if(AppConstants.languages.length > 1) {
                    Get.offNamed(RouteHelper.getLanguageRoute('splash'));
                  }else {
                    Get.offNamed(RouteHelper.getOnBoardingRoute());
                  }
                } else {
                  // Get.offNamed(RouteHelper.getSignInRoute(RouteHelper.splash));
               Navigator.pushReplacementNamed(context, RouteHelper.getInitialRoute());

                }
              }
            }
          }
        });
        
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Get.find<SplashController>().initSharedData();
    if(Get.find<LocationController>().getUserAddress() != null && Get.find<LocationController>().getUserAddress()!.zoneIds == null) {
      Get.find<AuthController>().clearSharedAddress();
    }

    return Scaffold(
      key: _globalKey,
      body: GetBuilder<SplashController>(builder: (splashController) {
        return splashController.hasConnection ? Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          // color: Colors.green,
          child: Container(
            // color: Colors.yellow,
            height: 150,
            width: 150,
            child: Stack(
              // fit: StackFit.expand,
              // mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  alignment: Alignment.center,child: Image.asset(Images.logo, width: 500)),
                // const SizedBox(height: Dimensions.paddingSizeSmall),
                 Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(left: 100,top: 180),    
                  

                   child: Container(
                    margin: EdgeInsets.only(),child: Text("قربنا لك البعيد ..", style: robotoMedium.copyWith(fontSize: 29,color: Theme.of(context).secondaryHeaderColor,fontWeight: FontWeight.bold))),
                 ),
              ],
            ),
          ),
        ) : NoInternetScreen(child: SplashScreen(body: widget.body));
      }),
    );
  }
}
