import 'package:talabiapp/controller/auth_controller.dart';
import 'package:talabiapp/controller/splash_controller.dart';
import 'package:talabiapp/controller/wishlist_controller.dart';
import 'package:talabiapp/util/dimensions.dart';
import 'package:talabiapp/util/styles.dart';
import 'package:talabiapp/view/base/custom_app_bar.dart';
import 'package:talabiapp/view/base/menu_drawer.dart';
import 'package:talabiapp/view/base/not_logged_in_screen.dart';
import 'package:talabiapp/view/screens/favourite/widget/fav_item_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FavouriteScreen extends StatefulWidget {
  final int  index;
  const FavouriteScreen({Key? key,this.index=0}) : super(key: key);

  @override
  FavouriteScreenState createState() => FavouriteScreenState();
}

class FavouriteScreenState extends State<FavouriteScreen> with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, initialIndex: widget.index, vsync: this);

    initCall();
  }

  void initCall(){
    if(Get.find<AuthController>().isLoggedIn()) {
      Get.find<WishListController>().getWishList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'favourite'.tr, backButton:widget.index==1?true: false),
      endDrawer: const MenuDrawer(),endDrawerEnableOpenDragGesture: false,
      body: Get.find<AuthController>().isLoggedIn() ? SafeArea(child: Column(children: [

        Container(
          width: Dimensions.webMaxWidth,
          color: Theme.of(context).cardColor,
          child: TabBar(
            controller: _tabController,
            indicatorColor: Theme.of(context).primaryColor,
            indicatorWeight: 3,
            labelColor: Theme.of(context).primaryColor,
            unselectedLabelColor: Theme.of(context).disabledColor,
            unselectedLabelStyle: robotoRegular.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeSmall),
            labelStyle: robotoBold.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor),
            tabs: [
              Tab(text: 'item'.tr),
              Tab(text: Get.find<SplashController>().configModel!.moduleConfig!.module!.showRestaurantText!
                  ? 'restaurants'.tr : 'stores'.tr),
            ],
          ),
        ),

        Expanded(child: TabBarView(
          controller: _tabController,
          children: const [
            FavItemView(isStore: false),
            FavItemView(isStore: true),
          ],
        )),

      ])) : NotLoggedInScreen(callBack: (value){
        initCall();
        setState(() {});
      }),
    );
  }
}
