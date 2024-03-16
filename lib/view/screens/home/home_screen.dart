import 'dart:convert';

import 'package:flutter_html/flutter_html.dart';
import 'package:marquee/marquee.dart';
import 'package:talabiapp/controller/auth_controller.dart';
import 'package:talabiapp/controller/banner_controller.dart';
import 'package:talabiapp/controller/campaign_controller.dart';
import 'package:talabiapp/controller/category_controller.dart';
import 'package:talabiapp/controller/location_controller.dart';
import 'package:talabiapp/controller/notice_controller.dart';
import 'package:talabiapp/controller/notification_controller.dart';
import 'package:talabiapp/controller/item_controller.dart';
import 'package:talabiapp/controller/parcel_controller.dart';
import 'package:talabiapp/controller/store_controller.dart';
import 'package:talabiapp/controller/splash_controller.dart';
import 'package:talabiapp/controller/user_controller.dart';
import 'package:talabiapp/helper/responsive_helper.dart';
import 'package:talabiapp/helper/route_helper.dart';
import 'package:talabiapp/util/dimensions.dart';
import 'package:talabiapp/util/images.dart';
import 'package:talabiapp/util/styles.dart';
import 'package:talabiapp/view/base/item_view.dart';
import 'package:talabiapp/view/base/menu_drawer.dart';
import 'package:talabiapp/view/base/paginated_list_view.dart';
import 'package:talabiapp/view/base/web_menu_bar.dart';
import 'package:talabiapp/view/screens/home/theme1/theme1_home_screen.dart';
import 'package:talabiapp/view/screens/home/web_home_screen.dart';
import 'package:talabiapp/view/screens/home/widget/filter_view.dart';
import 'package:talabiapp/view/screens/home/widget/popular_item_view.dart';
import 'package:talabiapp/view/screens/home/widget/item_campaign_view.dart';
import 'package:talabiapp/view/screens/home/widget/popular_store_view.dart';
import 'package:talabiapp/view/screens/home/widget/banner_view.dart';
import 'package:talabiapp/view/screens/home/widget/category_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:talabiapp/view/screens/home/widget/module_view.dart';
import 'package:talabiapp/view/screens/parcel/parcel_category_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../controller/splash_controllerS.dart';
import '../../../data/model/response/social_media.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../support/support_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);


  static Future<void> loadData(bool reload) async {
    if(Get.find<SplashController>().module != null && !Get.find<SplashController>().configModel!.moduleConfig!.module!.isParcel!) {
      Get.find<LocationController>().syncZoneData();
      Get.find<BannerController>().getBannerList(reload);
      Get.find<CategoryController>().getCategoryList(reload);
      Get.find<StoreController>().getPopularStoreList(reload, 'all', false);
      Get.find<CampaignController>().getItemCampaignList(reload);
      Get.find<ItemController>().getPopularItemList(reload, 'all', false);
      Get.find<StoreController>().getLatestStoreList(reload, 'all', false);
      Get.find<ItemController>().getReviewedItemList(reload, 'all', false);
      Get.find<StoreController>().getStoreList(1, reload);
    }
    if(Get.find<AuthController>().isLoggedIn()) {
      Get.find<UserController>().getUserInfo();
      Get.find<NotificationController>().getNotificationList(reload);
    }
    Get.find<SplashController>().getModules();
    if(Get.find<SplashController>().module == null && Get.find<SplashController>().configModel!.module == null) {
      Get.find<BannerController>().getFeaturedBanner();
      Get.find<StoreController>().getFeaturedStoreList();
      if(Get.find<AuthController>().isLoggedIn()) {
        Get.find<LocationController>().getAddressList();
      }
    }
    if(Get.find<SplashController>().module != null && Get.find<SplashController>().configModel!.moduleConfig!.module!.isParcel!) {
      Get.find<ParcelController>().getParcelCategoryList();
    }
  }

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
//List<Concat> concat=[];
  @override
  void initState() {
    super.initState();

    HomeScreen.loadData(false);
    if(!ResponsiveHelper.isWeb()) {
      Get.find<LocationController>().getZone(
          Get.find<LocationController>().getUserAddress()!.latitude,
          Get.find<LocationController>().getUserAddress()!.longitude, false, updateInAddress: true
      );
    }
  }

  @override
  void dispose() {
    super.dispose();

    _scrollController.dispose();
  }
List<Concat> concat=[];
  @override
  Widget build(BuildContext context) {
    NoteModelControllerS noteModelController = Get.put(NoteModelControllerS());
    return GetBuilder<SplashController>(builder: (splashController) {
      bool showMobileModule = !ResponsiveHelper.isDesktop(context) && splashController.module == null && splashController.configModel!.module == null;
      bool isParcel = splashController.module != null && splashController.configModel!.moduleConfig!.module!.isParcel!;
      // bool isTaxiBooking = splashController.module != null && splashController.configModel!.moduleConfig!.module!.isTaxi!;

      return SafeArea(
        child: Stack(
            fit: StackFit.expand,
          children: [
             Container(
              margin: const EdgeInsets.only(top: 65),
              child: Scaffold(
                // appBar:
                //  ResponsiveHelper.isDesktop(context) ? const WebMenuBar() 
                // : null,
                // endDrawer: const MenuDrawer(),endDrawerEnableOpenDragGesture: false,
                backgroundColor: ResponsiveHelper.isDesktop(context) ? Theme.of(context).cardColor : splashController.module == null
                    ? Theme.of(context).colorScheme.background : null,
                body: /*isTaxiBooking ? const RiderHomeScreen() :*/ isParcel ? const ParcelCategoryScreen() : SafeArea(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      if(Get.find<SplashController>().module != null) {
                        await Get.find<LocationController>().syncZoneData();
                        await Get.find<BannerController>().getBannerList(true);
                        await Get.find<CategoryController>().getCategoryList(true);
                        await Get.find<StoreController>().getPopularStoreList(true, 'all', false);
                        await Get.find<CampaignController>().getItemCampaignList(true);
                        await Get.find<ItemController>().getPopularItemList(true, 'all', false);
                        await Get.find<StoreController>().getLatestStoreList(true, 'all', false);
                        await Get.find<ItemController>().getReviewedItemList(true, 'all', false);
                        await Get.find<StoreController>().getStoreList(1, true);
                        if(Get.find<AuthController>().isLoggedIn()) {
                          await Get.find<UserController>().getUserInfo();
                          await Get.find<NotificationController>().getNotificationList(true);
                        }
                      }else {
                        await Get.find<BannerController>().getFeaturedBanner();
                        await Get.find<SplashController>().getModules();
                        if(Get.find<AuthController>().isLoggedIn()) {
                          await Get.find<LocationController>().getAddressList();
                        }
                        await Get.find<StoreController>().getFeaturedStoreList();
                      }
                    },
                    child: ResponsiveHelper.isDesktop(context) ? WebHomeScreen(
                      scrollController: _scrollController,
                    ) : (Get.find<SplashController>().module != null && Get.find<SplashController>().module!.themeId == 2) ? Theme1HomeScreen(
                      scrollController: _scrollController, splashController: splashController, showMobileModule: showMobileModule,
                    ) : CustomScrollView(
                      controller: _scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      slivers: [
            
                        // App Bar
                        SliverAppBar(
                          floating: true, elevation: 0, automaticallyImplyLeading: false,
                          backgroundColor: ResponsiveHelper.isDesktop(context) ? Colors.transparent : Theme.of(context).colorScheme.background,
                          title: Container(
                          
                            width: Dimensions.webMaxWidth, height: 40,
                            //  color: Theme.of(context).colorScheme.background,
                            // color: Colors.green,
                            child: Row(
                              children: [
                              (splashController.module != null && splashController.configModel!.module == null) ? InkWell(
                                onTap: () => splashController.removeModule(),
                                child: Image.asset(Images.moduleIcon, height: 22, width: 22, color: Theme.of(context).textTheme.bodyLarge!.color),
                              ) : const SizedBox(),
                              SizedBox(width: (splashController.module != null && splashController.configModel!.module
                                  == null) ? Dimensions.paddingSizeExtraSmall : 0),
                              Expanded(child: InkWell(
                                onTap: () => Get.find<LocationController>().navigateToLocationScreen('home'),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: Dimensions.paddingSizeSmall,
                                    horizontal: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeSmall : 0,
                                  ),
                                  child: GetBuilder<LocationController>(builder: (locationController) {
                                    return 
                                    Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Icon(
                                          locationController.getUserAddress()!.addressType == 'home' ? Icons.home_filled
                                              : locationController.getUserAddress()!.addressType == 'office' ? Icons.work : Icons.location_on,
                                          size: 20, color: Theme.of(context).textTheme.bodyLarge!.color,
                                        ),
                                        const SizedBox(width: 10),
                                        Flexible(
                                          child: Text(
                                            locationController.getUserAddress()!.address!,
                                            style: robotoRegular.copyWith(
                                              color: Theme.of(context).textTheme.bodyLarge!.color, fontSize: Dimensions.fontSizeSmall,fontWeight: FontWeight.bold
                                            ),
                                            maxLines: 1, overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Icon(Icons.arrow_drop_down, color: Theme.of(context).textTheme.bodyLarge!.color),
                                      ],
                                    );
                                  }),
                                ),
                              )),
                              // InkWell(
                              //   child: GetBuilder<NotificationController>(builder: (notificationController) {
                              //     return Stack(children: [
                              //       Icon(Icons.notifications, size: 25, color: Theme.of(context).textTheme.bodyLarge!.color),
                              //       notificationController.hasNotification ? Positioned(top: 0, right: 0, child: Container(
                              //         height: 10, width: 10, decoration: BoxDecoration(
                              //         color: Theme.of(context).primaryColor, shape: BoxShape.circle,
                              //         border: Border.all(width: 1, color: Theme.of(context).cardColor),
                              //       ),
                              //       )) : const SizedBox(),
                              //     ]);
                              //   }),
                              //   onTap: () => Get.toNamed(RouteHelper.getNotificationRoute()),
                              // ),
                            ]),
                          ),
                          actions: const [SizedBox()],
                        ),
            
                        // Search Button
                        !showMobileModule ? SliverPersistentHeader(
                          pinned: true,
                          delegate: SliverDelegate(child: Center(child: Container(
                            height: 50, width: Dimensions.webMaxWidth,
                            color: Theme.of(context).colorScheme.background,
                            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                            child: InkWell(
                              onTap: () => Get.toNamed(RouteHelper.getSearchRoute()),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                  boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 800 : 200]!, spreadRadius: 1, blurRadius: 5)],
                                ),
                                child: Row(children: [
                                  Icon(
                                    Icons.search, size: 25,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                                  Expanded(child: Text(
                                    Get.find<SplashController>().configModel!.moduleConfig!.module!.showRestaurantText!
                                        ? 'search_food_or_restaurant'.tr : 'search_item_or_store'.tr,
                                    style: robotoRegular.copyWith(
                                      fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor,
                                    ),
                                  )),
                                ]),
                              ),
                            ),
                          ))),
                        ) : const SliverToBoxAdapter(),
            
                        SliverToBoxAdapter(
                          child: Center(child: SizedBox(
                            width: Dimensions.webMaxWidth,
                            child: !showMobileModule ? 
                            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            
                              const BannerView(isFeatured: false),
                              const CategoryView(),
            /*
                              const PopularStoreView(isPopular: true, isFeatured: false),
                           
                              const ItemCampaignView(),
                              const PopularItemView(isPopular: true),
                              const PopularStoreView(isPopular: false, isFeatured: false),
                              const PopularItemView(isPopular: false),
            */
                              // Padding(
                              //   padding: const EdgeInsets.fromLTRB(10, 15, 0, 5),
                              //   child: Row(children: [
                              //     Expanded(child: Text(
                              //       Get.find<SplashController>().configModel!.moduleConfig!.module!.showRestaurantText!
                              //           ? 'all_restaurants'.tr : 'all_stores'.tr,
                              //       style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
                              //     )),
                              //     const FilterView(),
                              //   ]),
                              // ),
            
                                           const SizedBox(
                         child: FilterView(),
                      ),
            
            
                              GetBuilder<StoreController>(builder: (storeController) {
                                return PaginatedListView(
                                  scrollController: _scrollController,
                                  totalSize: storeController.storeModel != null ? storeController.storeModel!.totalSize : null,
                                  offset: storeController.storeModel != null ? storeController.storeModel!.offset : null,
                                  onPaginate: (int? offset) async => await storeController.getStoreList(offset!, false),
                                  itemView: ItemsView(
                                                      storeName: "",
            
                                    isStore: true, items: null,
                                    stores:  storeController.storeModel!.stores,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeExtraSmall : Dimensions.paddingSizeSmall,
                                      vertical: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeExtraSmall : 0,
                                    ),
                                  ),
                                );
                              }),
            
                            ]) : ModuleView(splashController: splashController),
                          )),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ),
    
        
        
        
        //     Positioned(
        //     top: 45,
        //     right: 0,left: 120,
        //     child:        Container(height: 30,
        //     width: MediaQuery.of(context).size.width,
        //     color: Theme.of(context).secondaryHeaderColor,
        //   child:   
        //    Marquee(
        // text:  "خصم 10% عند من مكعم نجوم تهامة                                      ",
        //    // "طلبي بخدمتكم من الساعه الثامنه صباحا حتي العاشره مساء 736606605"
        // startPadding: 150,
      
        // pauseAfterRound: Duration(microseconds: 20),
        //   // mode: TextScrollMode.bouncing,
        //   // velocity: Velocity(pixelsPerSecond: Offset(150, 0)),
        //   // delayBefore: Duration(milliseconds: 5),
        //   // numberOfReps: 5,
        //   // pauseBetween: Duration(milliseconds: 2),
        //   // style: TextStyle(color: Theme.of(context).primaryColor),
        //   // textAlign: TextAlign.right,
        //   // selectable: true,
        //   )
          
          
          
        //   )
        //   ),
      
           Positioned(
            top:0,
            right: 0,left: 0,
             child: Stack(
              clipBehavior: Clip.none,
               children: 
               
                 [Container(
                    color: const Color.fromARGB(255, 0, 74, 97),
                  height: 75,
                  //color: Color.fromARGB(235, 233, 8, 8),
                  // decoration: const BoxDecoration(
                         
                  //          //  borderRadius: BorderRadius.circular(10)
                  //          ),
                  
                 ),
                // Image.asset(Images.logo, width: 125),
                Row(
                
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(bottom: 30),
                      color: const Color.fromARGB(255, 0, 74, 97),
                      height: 74,
              child:  Image.asset(Images.logo, width: 100,fit: BoxFit.cover,color: Colors.white,)
              ),
              //  GetBuilder<LocationController>(builder: (locationController) {
              //                       return 
              //                       Row(
              //                         mainAxisSize: MainAxisSize.min,
              //                         // crossAxisAlignment: CrossAxisAlignment.center,
              //                         //  mainAxisAlignment: MainAxisAlignment.start,
              //                         children: [
              //                           Icon(
              //                             locationController.getUserAddress()!.addressType == 'home' ? Icons.home_filled
              //                                 : locationController.getUserAddress()!.addressType == 'office' ? Icons.work : Icons.location_on,
              //                             size: 20, color: Theme.of(context).textTheme.bodyLarge!.color,
              //                           ),
              //                           const SizedBox(width: 10),
              //                           Flexible(
              //                             child: Text(
              //                               locationController.getUserAddress()!.address!,
              //                               style: robotoRegular.copyWith(
              //                                 color: Theme.of(context).textTheme.bodyLarge!.color, fontSize: Dimensions.fontSizeSmall,
              //                               ),
              //                               maxLines: 1, overflow: TextOverflow.ellipsis,
              //                             ),
              //                           ),
              //                           Icon(Icons.arrow_drop_down, color: Theme.of(context).textTheme.bodyLarge!.color),
              //                         ],
              //                       );
              //                     }),

              InkWell(
                                child: Container(
                                  padding: EdgeInsets.only(bottom: 30,left: 20),
                                  child: GetBuilder<NotificationController>(builder: (notificationController) {
                                    return Stack(children: [
                                     const Icon(Icons.notifications, size: 25, color: Colors.white),//Theme.of(context).textTheme.bodyLarge!.color
                                      notificationController.hasNotification ? Positioned(top: 0, right: 0, child: Container(
                                        height: 10, width: 10, decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor, shape: BoxShape.circle,
                                        border: Border.all(width: 1, color: Theme.of(context).cardColor),
                                      ),
                                      )) : const SizedBox(),
                                    ]);
                                  }),
                                ),
                                onTap: () => Get.toNamed(RouteHelper.getNotificationRoute()),
                              ),

                              // GetBuilder<LocationController>(builder: (locationController) {
                              //       return 
                              //       Row(
                              //         mainAxisSize: MainAxisSize.min,
                              //         // crossAxisAlignment: CrossAxisAlignment.center,
                              //         //  mainAxisAlignment: MainAxisAlignment.start,
                              //         children: [
                              //           Icon(
                              //             locationController.getUserAddress()!.addressType == 'home' ? Icons.home_filled
                              //                 : locationController.getUserAddress()!.addressType == 'office' ? Icons.work : Icons.location_on,
                              //             size: 20, color: Theme.of(context).textTheme.bodyLarge!.color,
                              //           ),
                              //           const SizedBox(width: 10),
                              //           Flexible(
                              //             child: Text(
                              //               locationController.getUserAddress()!.address!,
                              //               style: robotoRegular.copyWith(
                              //                 color: Theme.of(context).textTheme.bodyLarge!.color, fontSize: Dimensions.fontSizeSmall,
                              //               ),
                              //               maxLines: 1, overflow: TextOverflow.ellipsis,
                              //             ),
                              //           ),
                              //           Icon(Icons.arrow_drop_down, color: Theme.of(context).textTheme.bodyLarge!.color),
                              //         ],
                              //       );
                              //     })


                              
             
                  ],
                )
               ],
             ),
           ),
         
          Positioned(
            top: 45,
            right: 0,left: 0,
            child: InkWell(
              
           onTap:()=> Get.toNamed(RouteHelper.getSupportRoute()),
                     
                        
              child: Container(height: 30,
              width: MediaQuery.of(context).size.width,
                      //  color: Theme.of(context).secondaryHeaderColor,
              decoration: BoxDecoration(
               color: Theme.of(context).secondaryHeaderColor,
                borderRadius: const BorderRadius.only(
                  topLeft:Radius.circular(20),
                  topRight:Radius.circular(20)
                )
              ),
                      child: 
                      
                       GetBuilder<NoteModelControllerS>(
                      
                         builder: (controller) {
                           return
                           controller.loding ? const LinearProgressIndicator(
                            minHeight: 1,
                            color: Colors.orangeAccent,
                           ):
                            Marquee(
                            
                      
                                     text:controller.listnote[0].value?? "0",
                                           //"طلبي بخدمتكم من الساعه الثامنه صباحا حتي العاشره مساء 736606605              ",
                                           style: const TextStyle(color: Colors.black),
                           // "طلبي بخدمتكم من الساعه الثامنه صباحا حتي العاشره مساء 736606605"
                                           startPadding: 150,
                                           
                                         
                                           pauseAfterRound: const Duration(microseconds: 20),
                                             // mode: TextScrollMode.bouncing,
                                             // velocity: Velocity(pixelsPerSecond: Offset(150, 0)),
                                             // delayBefore: Duration(milliseconds: 5),
                                             // numberOfReps: 5,
                                             // pauseBetween: Duration(milliseconds: 2),
                                             // style: TextStyle(color: Theme.of(context).primaryColor),
                                             // textAlign: TextAlign.right,
                                             // selectable: true,
                                             );
                         }
                       )
                      
                      
                      
                      ),
                //         onDoubleTap: () {
                // Get.to(SupportScreen); },
            )
          ),
          ],
        ),
      );
      
    });

    
  }
 
  
}

class SliverDelegate extends SliverPersistentHeaderDelegate {
  Widget child;

  SliverDelegate({required this.child});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => 50;

  @override
  double get minExtent => 50;

  @override
  bool shouldRebuild(SliverDelegate oldDelegate) {
    return oldDelegate.maxExtent != 50 || oldDelegate.minExtent != 50 || child != oldDelegate.child;
  }
}








class CustomClipPath extends CustomClipper<Path> {
  //var radius=9.0;
  @override
  Path getClip(Size size) {
    double w =size.width;
    double h =size.height;

    final  path = Path();
    path.lineTo(0,h);
    path.quadraticBezierTo(w*0.5, h -100,w,h);


    path.lineTo(w,h);
    path.lineTo(w,0);
    path.close();
  //  path.lineTo(size.width, 5.0);
    return path;
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}


