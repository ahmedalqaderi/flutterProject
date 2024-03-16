import 'dart:async';

import 'package:expandable_bottom_sheet/expandable_bottom_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talabiapp/controller/auth_controller.dart';
import 'package:talabiapp/controller/location_controller.dart';
import 'package:talabiapp/controller/notice_controller.dart';
import 'package:talabiapp/controller/order_controller.dart';
import 'package:talabiapp/controller/splash_controller.dart';
import 'package:talabiapp/data/model/response/order_model.dart';
import 'package:talabiapp/helper/responsive_helper.dart';
import 'package:talabiapp/helper/route_helper.dart';
import 'package:talabiapp/util/app_constants.dart';
import 'package:talabiapp/util/dimensions.dart';
import 'package:talabiapp/util/images.dart';
import 'package:talabiapp/view/base/cart_widget.dart';
import 'package:talabiapp/view/base/custom_dialog.dart';
import 'package:talabiapp/view/screens/checkout/widget/congratulation_dialogue.dart';
import 'package:talabiapp/view/screens/dashboard/widget/address_bottom_sheet.dart';
import 'package:talabiapp/view/screens/favourite/favourite_screen.dart';
import 'package:talabiapp/view/screens/home/home_screen.dart';
import 'package:talabiapp/view/screens/menu/menu_screen_new.dart';
import 'package:talabiapp/view/screens/order/order_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'widget/running_order_view_widget.dart';

class DashboardScreen extends StatefulWidget {
  final int pageIndex;
  final bool fromSplash;
  const DashboardScreen({Key? key, required this.pageIndex, this.fromSplash = false}) : super(key: key);

  @override
  DashboardScreenState createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> {
  PageController? _pageController;
  int _pageIndex = 0;
  late List<Widget> _screens;
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey();
  bool _canExit = GetPlatform.isWeb ? true : false;

  GlobalKey<ExpandableBottomSheetState> key = GlobalKey();
  // final GlobalKey<ScaffoldState> _drawerKey = GlobalKey<ScaffoldState>();

  // void _openEndDrawer() {
  //   _drawerKey.currentState!.openEndDrawer();
  // }

  // void _closeEndDrawer() {
  //   Navigator.of(context).pop();
  // }

void saveUserIsFirstTimeLogin()async{
  
  SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
  sharedPreferences.setBool("isFirstTime", true);

}
Future<bool> isUserLoginFirstTime()async{
  
  SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
 bool result=  sharedPreferences.getBool("isFirstTime")??false;
 return result;

}


/*
void showDialogFunction()async{

if(await isUserLoginFirstTime() ==false){
      // showDialog(

      // context:context, builder: (context) => 
       
        AlertDialog(
          // : ,
          // contentPadding: EdgeInsets.zero,
          backgroundColor: Colors.black38,
          // actionsPadding: EdgeInsets.zero,
          content: Container(
            child: Column(
            children: [
              Image.asset(Images.greating_image,width: MediaQuery.of(context).size.width,height: 250,)
            ],
                  ),
          ),
          // )
          );
      
    }
    // else{
    //   saveUserIsFirstTimeLogin();
    // }


}
*/

  late bool _isLogin;
  bool active = false;

  @override
  void initState() {
    super.initState();
    //  showDialogFunction();
    
    _isLogin = Get.find<AuthController>().isLoggedIn();

    if(_isLogin){
      if(Get.find<SplashController>().configModel!.loyaltyPointStatus == 1 && Get.find<AuthController>().getEarningPint().isNotEmpty
          && !ResponsiveHelper.isDesktop(Get.context)){
        Future.delayed(const Duration(seconds: 1), () => showAnimatedDialog(context, const CongratulationDialogue()));
      }
      suggestAddressBottomSheet();
      Get.find<OrderController>().getRunningOrders(1);
    }

    _pageIndex = widget.pageIndex;

    _pageController = PageController(initialPage: widget.pageIndex);

    _screens = [
      const HomeScreen(),
      const FavouriteScreen(),
      // const CartScreen(fromNav: true),
      const SizedBox(),
      const OrderScreen(),
      const MenuScreenNew()
    ];

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {});
    });

  }

  Future<void> suggestAddressBottomSheet() async {

    active = await Get.find<LocationController>().checkLocationActive();
    if(widget.fromSplash && Get.find<LocationController>().showLocationSuggestion && active){
      Future.delayed(const Duration(seconds: 1), () {
        showModalBottomSheet(
          context: context, isScrollControlled: true, backgroundColor: Colors.transparent,
          builder: (con) => const AddressBottomSheet(),
        ).then((value) {
          Get.find<LocationController>().hideSuggestedLocation();
          setState(() {});
        });
      });
    }
  }
  void _setPage(int pageIndex) {
    
    setState(() {
       if(pageIndex==0&&Get.find<SplashController>().module != null){
        Get.find<SplashController>().removeModule();
       }
       
       _pageController!.jumpToPage(pageIndex);
      _pageIndex = pageIndex;
    });
    print("this the page index ${_pageIndex}  = = =   = =  = = = = = = = == ");
  }
bool state=false;
  @override
  Widget build(BuildContext context) {
  isUserLoginFirstTime().then((value) => {
 if(value==false){
   setState(() {
      state=true;
    }),
       saveUserIsFirstTimeLogin()

 }
  });
  
  

 
 
  
NoteModelControllerS noteModelController = Get.put(NoteModelControllerS());



    return WillPopScope(
      onWillPop: () async {
        if (_pageIndex != 0) {
          _setPage(0);
          return false;
        } else {
          if(!ResponsiveHelper.isDesktop(context) && Get.find<SplashController>().module != null && Get.find<SplashController>().configModel!.module == null) {
            Get.find<SplashController>().setModule(null);
            return false;
          }else {
            if(_canExit) {
              return true;
            }else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('back_press_again_to_exit'.tr, style: const TextStyle(color: Colors.white)),
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 2),
                margin: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              ));
              _canExit = true;
              Timer(const Duration(seconds: 2), () {
                _canExit = false;
              });
              return false;
            }
          }
        }
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          GetBuilder<OrderController>(
            builder: (orderController) {
              List<OrderModel> runningOrder = orderController.runningOrderModel != null ? orderController.runningOrderModel!.orders! : [];

              List<OrderModel> reversOrder =  List.from(runningOrder.reversed);

              return Scaffold(
                key: _scaffoldKey,

                // endDrawer: const MenuScreenNew(),

                floatingActionButton: ResponsiveHelper.isDesktop(context) ? null : (widget.fromSplash && Get.find<LocationController>().showLocationSuggestion && active) ? null
                    : (orderController.showBottomSheet && orderController.runningOrderModel != null && orderController.runningOrderModel!.orders!.isNotEmpty)
                    ? const SizedBox() : FloatingActionButton(
                      elevation: 5,
                      backgroundColor: _pageIndex == 2 ? Theme.of(context).primaryColor : Theme.of(context).cardColor,
                      onPressed: () {
                          // _setPage(2);
                        Get.toNamed(RouteHelper.getCartRoute());
                      },
                      child: CartWidget(color: _pageIndex == 2 ? Theme.of(context).cardColor : Theme.of(context).disabledColor, size: 30),
                    ),
                floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

                bottomNavigationBar: ResponsiveHelper.isDesktop(context) ? const SizedBox() : (widget.fromSplash && Get.find<LocationController>().showLocationSuggestion && active) ? const SizedBox()
                    : (orderController.showBottomSheet && orderController.runningOrderModel != null && orderController.runningOrderModel!.orders!.isNotEmpty) ? const SizedBox() :  BottomAppBar(
                      elevation: 5,
                      notchMargin: 5,
                      clipBehavior: Clip.antiAlias,
                      shape: const CircularNotchedRectangle(),

                      child: Container(
                        height: 70,
                        padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                        child: Row(children: [

                            Expanded(
                              child: InkWell(
                              onTap: ()=>_setPage(0),
                          child: Column(
                              children: [
                                Icon(Icons.home, color: _pageIndex == 0 ? Theme.of(context).primaryColor : Colors.grey, size: 25)
                                ,Text("الرئيسية",style: TextStyle(color: Theme.of(context).primaryColor),),


                              ],
                          )),
                            ),


                         /* BottomNavItem(
                              name:"المفضلة",iconData: Icons.favorite, isSelected: _pageIndex == 1, onTap: () => _setPage(1)),
                         */
                          Expanded(
                            child: InkWell(
                                onTap: ()=>_setPage(1),
                                child: Column(
                                  children: [
                                    Icon(Icons.favorite, color: _pageIndex == 1 ? Theme.of(context).primaryColor : Colors.grey, size: 25)
                                    ,Text("المفضلة",style: TextStyle(color: Theme.of(context).primaryColor),),


                                  ],
                                )),
                          ),

                          const Expanded(child: SizedBox()),
                       /*   BottomNavItem(
                              name:"طلباتي",   iconData: Icons.shopping_bag, isSelected: _pageIndex == 3, onTap: () => _setPage(3)),
*/
                          Expanded(
                            child: InkWell(
                                onTap: ()=>_setPage(3),
                                child: Column(
                                  children: [
                                    Icon(Icons.shopping_bag, color: _pageIndex == 2 ? Theme.of(context).primaryColor : Colors.grey, size: 25)
                                    ,Text("طلباتي",style: TextStyle(color: Theme.of(context).primaryColor),),


                                  ],
                                )),
                          ),
                         /* BottomNavItem(
                          name:"المزيد",iconData: Icons.menu, isSelected: _pageIndex == 4, onTap: () => _setPage(4)),
                          */
                          Expanded(
                            child: InkWell(
                                onTap: ()=>_setPage(4),
                                child: Column(
                                  children: [
                                    Icon(Icons.menu, color: _pageIndex == 4 ? Theme.of(context).primaryColor : Colors.grey, size: 25)
                                    ,Text("المزيد",style: TextStyle(color: Theme.of(context).primaryColor),),


                                  ],
                                )),
                          ),
                          // BottomNavItem(iconData: Icons.menu, isSelected: _pageIndex == 4, onTap: () => _openEndDrawer()),
                          // BottomNavItem(iconData: Icons.menu, isSelected: _pageIndex == 4, onTap: () {
                          //   Get.bottomSheet(const MenuScreen(), backgroundColor: Colors.transparent, isScrollControlled: true);
                          // }),
                        ]),
                      ),
                    ),
                body: ExpandableBottomSheet(
                  background: PageView.builder(
                      controller: _pageController,
                      itemCount: _screens.length,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return _screens[index];
                      },
                    ),

                  persistentContentHeight:  (widget.fromSplash && Get.find<LocationController>().showLocationSuggestion && active) ? 0 : 100 ,

                  onIsContractedCallback: () {
                    if(!orderController.showOneOrder) {
                      orderController.showOrders();
                    }
                  },
                  onIsExtendedCallback: () {
                    if(orderController.showOneOrder) {
                      orderController.showOrders();
                    }
                  },

                  // enableToggle: true,

                  expandableContent: (widget.fromSplash && Get.find<LocationController>().showLocationSuggestion && active && !ResponsiveHelper.isDesktop(context)) ?  const SizedBox()
                  : (ResponsiveHelper.isDesktop(context) || !_isLogin || orderController.runningOrderModel == null
                  || orderController.runningOrderModel!.orders!.isEmpty || !orderController.showBottomSheet) ? const SizedBox()
                  : Dismissible(
                    key: UniqueKey(),
                    onDismissed: (direction) {
                      if(orderController.showBottomSheet){
                        orderController.showRunningOrders();
                      }
                    },
                    child: RunningOrderViewWidget(reversOrder: reversOrder, onOrderTap: () {
                      _setPage(3);
                      if(orderController.showBottomSheet){
                        orderController.showRunningOrders();
                      }
                    }),
                  ),
                ),
              );
            }
          ),
     
     
     if(state==false)
         GetBuilder<NoteModelControllerS>(
           builder: (controller) {
             return
             controller.loding?Text(""):
              Container(
                margin: EdgeInsets.only(top: 100),
              alignment: Alignment.center,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: Colors.black54,
              child: Container(
                // alignment: Alignment.center,
                height: 450,

                width: MediaQuery.of(context).size.width*0.7,
                child: Column(
                  children: [
               Stack(
                // fit: StackFit.expand,
                 children: [
                  controller.loadingImage ? CircularProgressIndicator() :
                   Image.network("${AppConstants.business}/${controller.imagename!}",width: MediaQuery.of(context).size.width*0.7,fit: BoxFit.fill,height: 250,),
                  //  Image.asset(Images.greating_image,width: MediaQuery.of(context).size.width*0.7,fit: BoxFit.fill,height: 250,),
               Positioned(
                right: 4,
                 
                  child: IconButton(onPressed: (){
                    setState(() {
                      state=true;
                    });
                    Get.back();
                  }, icon:const Icon(Icons.clear)),
                )
                
                 ],
               ),
//                Container(
//                 width: MediaQuery.of(context).size.width*0.7,
//                             color: Colors.yellow,
// child: Column(children: [

//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: const [
//                     Text("رايح تدور عروض",style:TextStyle(fontWeight: FontWeight.bold)),
//                     Text("🤔️" ,style:TextStyle(fontWeight: FontWeight.bold)),
//                   ],
//                 ),
//                 SizedBox(height: 20,),
//                 Text("وقف تدوير  علشان توصلك إشعارات"),
//                 Text("عروضنا"),

//                ]),)

                  ],
                ),
              ),
             );
           }
         )
     
     
        ],
      ),
    );
  }


  Widget trackView(BuildContext context, {required bool status}) {
    return Container(height: 3, decoration: BoxDecoration(color: status ? Theme.of(context).primaryColor
        : Theme.of(context).disabledColor.withOpacity(0.5), borderRadius: BorderRadius.circular(Dimensions.radiusDefault)));
  }
}

