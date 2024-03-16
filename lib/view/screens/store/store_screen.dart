import 'package:flutter/rendering.dart';
import 'package:talabiapp/controller/auth_controller.dart';
import 'package:talabiapp/controller/cart_controller.dart';
import 'package:talabiapp/controller/category_controller.dart';
import 'package:talabiapp/controller/localization_controller.dart';
import 'package:talabiapp/controller/store_controller.dart';
import 'package:talabiapp/controller/splash_controller.dart';
import 'package:talabiapp/controller/wishlist_controller.dart';
import 'package:talabiapp/data/model/response/address_model.dart';
import 'package:talabiapp/data/model/response/category_model.dart';
import 'package:talabiapp/data/model/response/item_model.dart';
import 'package:talabiapp/data/model/response/store_model.dart';
import 'package:talabiapp/helper/date_converter.dart';
import 'package:talabiapp/helper/price_converter.dart';
import 'package:talabiapp/helper/responsive_helper.dart';
import 'package:talabiapp/helper/route_helper.dart';
import 'package:talabiapp/util/app_constants.dart';
import 'package:talabiapp/util/dimensions.dart';
import 'package:talabiapp/util/images.dart';
import 'package:talabiapp/util/styles.dart';
import 'package:talabiapp/view/base/custom_image.dart';
import 'package:talabiapp/view/base/custom_snackbar.dart';
import 'package:talabiapp/view/base/footer_view.dart';
import 'package:talabiapp/view/base/item_view.dart';
import 'package:talabiapp/view/base/item_widget.dart';
import 'package:talabiapp/view/base/menu_drawer.dart';
import 'package:talabiapp/view/base/paginated_list_view.dart';
import 'package:talabiapp/view/base/veg_filter_widget.dart';
import 'package:talabiapp/view/base/web_menu_bar.dart';
import 'package:talabiapp/view/screens/checkout/checkout_screen.dart';
import 'package:talabiapp/view/screens/store/widget/customizable_space_bar.dart';
import 'package:talabiapp/view/screens/store/widget/store_description_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'widget/bottom_cart_widget.dart';

class StoreScreen extends StatefulWidget {
  final Store? store;
  final bool fromModule;
  const StoreScreen({Key? key, required this.store, required this.fromModule})
      : super(key: key);

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    Get.find<StoreController>().hideAnimation();
    Get.find<StoreController>()
        .getStoreDetails(Store(id: widget.store!.id), widget.fromModule)
        .then((value) {
      Get.find<StoreController>().showButtonAnimation();
    });
    if (Get.find<CategoryController>().categoryList == null) {
      Get.find<CategoryController>().getCategoryList(true);
    }
    Get.find<StoreController>()
        .getRestaurantRecommendedItemList(widget.store!.id, false);
    Get.find<StoreController>()
        .getStoreItemList(widget.store!.id, 1, 'all', false);

    scrollController.addListener(() {
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (Get.find<StoreController>().showFavButton) {
          Get.find<StoreController>().changeFavVisibility();
          Get.find<StoreController>().hideAnimation();
        }
      } else {
        if (!Get.find<StoreController>().showFavButton) {
          Get.find<StoreController>().changeFavVisibility();
          Get.find<StoreController>().showButtonAnimation();
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();

    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {

print("this data = == = =${widget.store?.deliveryTime}  = = =  == = = == = = = = == = = = === =");

    return Scaffold(
        appBar: AppBar(
          title: Text(
            "${widget.store?.name}",
            style: robotoMedium.copyWith(
                fontSize: Dimensions.fontSizeLarge,
                color: Theme.of(context).cardColor),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        /*  bottom: PreferredSize(
              child: Container(
                decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)
                        
                      )
                ),
                // alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Text(widget.store?.deliveryTime==null?" ":
           "الطلب يستغرق      ${widget.store?.deliveryTime}",
            style: robotoMedium.copyWith(
                      fontSize: Dimensions.fontSizeLarge,
                      color: Colors.black)),
                    ),
                 Container(
                  alignment: Alignment.center,
                  width: 70,
                  height: 60,
                decoration: BoxDecoration(
                color: Theme.of(context).secondaryHeaderColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        // topRight: Radius.circular(20)
                        
                      ),
                      
                )
                ,
                child: Text("${widget.store?.open==1?"مفتوح":"مغلق"}",style:  robotoMedium.copyWith(
                    fontSize: Dimensions.fontSizeLarge,
                    color: Theme.of(context).cardColor)),)
                  ],
                ) ,
                height: 50,
                width: MediaQuery.of(context).size.width,
              ),
              preferredSize: Size(MediaQuery.of(context).size.width, 60)),

       */ ),
        //  ResponsiveHelper.isDesktop(context) ? const WebMenuBar() : null,
        // endDrawer: const MenuDrawer(),endDrawerEnableOpenDragGesture: false,
        backgroundColor: Theme.of(context).cardColor,
        body: GetBuilder<StoreController>(builder: (storeController) {
          return GetBuilder<CategoryController>(builder: (categoryController) {
            Store? store;
            if (storeController.store != null &&
                storeController.store!.name != null &&
                categoryController.categoryList != null) {
              store = storeController.store;
            }
            storeController.setCategoryList();

            return (storeController.store != null &&
                    storeController.store!.name != null &&
                    categoryController.categoryList != null)
                ? CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    controller: scrollController,
                    slivers: [
/*
                      ResponsiveHelper.isDesktop(context)
                          ? SliverToBoxAdapter(
                              child: Container(
                                color: const Color(0xFF171A29),
                                padding: const EdgeInsets.all(
                                    Dimensions.paddingSizeLarge),
                                alignment: Alignment.center,
                                child: Center(
                                    child: SizedBox(
                                        width: Dimensions.webMaxWidth,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal:
                                                  Dimensions.paddingSizeSmall),
                                          child: Row(children: [
                                            Expanded(
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        Dimensions.radiusSmall),
                                                child: CustomImage(
                                                  fit: BoxFit.cover,
                                                  height: 220,
                                                  image:
                                                      '${Get.find<SplashController>().configModel!.baseUrls!.storeCoverPhotoUrl}/${store!.coverPhoto}',
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                                width: Dimensions
                                                    .paddingSizeLarge),
/*
                      Expanded(child: StoreDescriptionView(store: store)),
*/
                                          ]),
                                        ))),
                              ),
                            )
                          : SliverAppBar(
                              expandedHeight: 250,
                              toolbarHeight: 100,
                              pinned: true,
                              floating: false,
                              elevation: 0.5,
                              backgroundColor: Theme.of(context).cardColor,
                              leading: IconButton(
                                icon: Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Theme.of(context).primaryColor),
                                  alignment: Alignment.center,
                                  child: Icon(Icons.chevron_left,
                                      color: Theme.of(context).cardColor),
                                ),
                                onPressed: () => Get.back(),
                              ),

                              /*flexibleSpace: CustomizableSpaceBar(
                  builder: (context, scrollingRate) {
                    print('--------?>>> $scrollingRate');
                    /// Example content
                    return Padding(
                      padding: EdgeInsets.only(bottom: 0, left: 20 + 40 * scrollingRate),
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Container(
                          height: 100, color: Theme.of(context).cardColor,
                          child: Row(children: [

                            ClipRRect(
                              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                              child: Stack(children: [
                                CustomImage(
                                  image: '${Get.find<SplashController>().configModel!.baseUrls!.storeImageUrl}/${store!.logo}',
                                  height: ResponsiveHelper.isDesktop(context) ? 80 : 60, width: ResponsiveHelper.isDesktop(context) ? 100 : 70, fit: BoxFit.cover,
                                ),

                                storeController.isStoreOpenNow(store.active!, store.schedules) ? const SizedBox() : Positioned(
                                  bottom: 0, left: 0, right: 0,
                                  child: Container(
                                    height: 30,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(Dimensions.radiusSmall)),
                                      color: Colors.black.withOpacity(0.6),
                                    ),
                                    child: Text(
                                      'closed_now'.tr, textAlign: TextAlign.center,
                                      style: robotoRegular.copyWith(color: Colors.white, fontSize: Dimensions.fontSizeSmall),
                                    ),
                                  ),
                                ),
                              ]),
                            ),
                            const SizedBox(width: Dimensions.paddingSizeSmall),

                            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.center, children: [
                              Row(children: [
                                Expanded(child: Text(
                                  store.name!, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.bodyMedium!.color),
                                  maxLines: 1, overflow: TextOverflow.ellipsis,
                                )),
                                const SizedBox(width: Dimensions.paddingSizeSmall),

                                GetBuilder<WishListController>(builder: (wishController) {
                                  bool isWished = wishController.wishStoreIdList.contains(store!.id);
                                  return InkWell(
                                    onTap: () {
                                      if(Get.find<AuthController>().isLoggedIn()) {
                                        isWished ? wishController.removeFromWishList(store!.id, true)
                                            : wishController.addToWishList(null, store, true);
                                      }else {
                                        showCustomSnackBar('you_are_not_logged_in'.tr);
                                      }
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                      ),
                                      padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                                      child: Icon(
                                        isWished ? Icons.favorite : Icons.favorite_border,
                                        color: isWished ? Theme.of(context).primaryColor : Theme.of(context).disabledColor,
                                      ),
                                    ),
                                  );
                                }),
                                const SizedBox(width: Dimensions.paddingSizeSmall),

                              ]),
                              const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                              Text(
                                store.address ?? '', maxLines: 1, overflow: TextOverflow.ellipsis,
                                style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                              ),
                              SizedBox(height: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeExtraSmall : 0),
                              Row(children: [
                                Text('minimum_order'.tr, style: robotoRegular.copyWith(
                                  fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).disabledColor,
                                )),
                                const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                                Text(
                                  PriceConverter.convertPrice(store.minimumOrder), textDirection: TextDirection.ltr,
                                  style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).primaryColor),
                                ),
                              ]),
                            ])),

                          ]),
                        ),
                      ),
                    );
                  },
                ),*/
                              flexibleSpace: FlexibleSpaceBar(
                                titlePadding: EdgeInsets.zero,
                                centerTitle: true,
                                expandedTitleScale: 1.1,
                                title: CustomizableSpaceBar(
                                  builder: (context, scrollingRate) {
                                    return Container(
                                      height: 100,
                                      color: Theme.of(context).cardColor,
                                      child: Container(
                                        color: Theme.of(context)
                                            .cardColor
                                            .withOpacity(scrollingRate),
                                        padding: EdgeInsets.only(
                                          bottom: 0,
                                          left:
                                              Get.find<LocalizationController>()
                                                      .isLtr
                                                  ? 40 * scrollingRate
                                                  : 0,
                                          right:
                                              Get.find<LocalizationController>()
                                                      .isLtr
                                                  ? 0
                                                  : 40 * scrollingRate,
                                        ),
                                        child: Align(
                                          alignment: Alignment.bottomLeft,
                                          child: Container(
                                            height: 100,
                                            color: Theme.of(context)
                                                .cardColor
                                                .withOpacity(
                                                    scrollingRate == 0.0
                                                        ? 1
                                                        : 0),
                                            padding: EdgeInsets.only(
                                              left: Get.find<
                                                          LocalizationController>()
                                                      .isLtr
                                                  ? 20
                                                  : 0,
                                              right: Get.find<
                                                          LocalizationController>()
                                                      .isLtr
                                                  ? 0
                                                  : 20,
                                            ),
                                            child: Row(children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        Dimensions.radiusSmall),
                                                child: Stack(children: [
                                                  CustomImage(
                                                    image:
                                                        '${Get.find<SplashController>().configModel!.baseUrls!.storeImageUrl}/${store!.logo}',
                                                    height: 60 -
                                                        (scrollingRate * 15),
                                                    width: 70 -
                                                        (scrollingRate * 15),
                                                    fit: BoxFit.cover,
                                                  ),
                                                  storeController
                                                          .isStoreOpenNow(
                                                              store.active!,
                                                              store.schedules)
                                                      ? const SizedBox()
                                                      : Positioned(
                                                          bottom: 0,
                                                          left: 0,
                                                          right: 0,
                                                          child: Container(
                                                            height: 30,
                                                            alignment: Alignment
                                                                .center,
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius: const BorderRadius
                                                                      .vertical(
                                                                  bottom: Radius
                                                                      .circular(
                                                                          Dimensions
                                                                              .radiusSmall)),
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      0.6),
                                                            ),
                                                            child: Text(
                                                              'closed_now'.tr,
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: robotoRegular.copyWith(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize:
                                                                      Dimensions
                                                                          .fontSizeSmall),
                                                            ),
                                                          ),
                                                        ),
                                                ]),
                                              ),
                                              const SizedBox(
                                                  width: Dimensions
                                                      .paddingSizeSmall),
                                              Expanded(
                                                  child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                    Row(children: [
                                                      Expanded(
                                                          child: Text(
                                                        store.name!,
                                                        style: robotoMedium.copyWith(
                                                            fontSize: Dimensions
                                                                    .fontSizeLarge -
                                                                (scrollingRate *
                                                                    3),
                                                            color: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodyMedium!
                                                                .color),
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      )),
                                                      const SizedBox(
                                                          width: Dimensions
                                                              .paddingSizeSmall),
                                                    ]),
                                                    const SizedBox(
                                                        height: Dimensions
                                                            .paddingSizeExtraSmall),
                                                    Text(
                                                      store.address ?? '',
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: robotoRegular.copyWith(
                                                          fontSize: Dimensions
                                                                  .fontSizeSmall -
                                                              (scrollingRate *
                                                                  2),
                                                          color: Theme.of(
                                                                  context)
                                                              .disabledColor),
                                                    ),
                                                    SizedBox(
                                                        height: ResponsiveHelper
                                                                .isDesktop(
                                                                    context)
                                                            ? Dimensions
                                                                .paddingSizeExtraSmall
                                                            : 0),
                                                    Row(children: [
                                                      Text('minimum_order'.tr,
                                                          style: robotoRegular
                                                              .copyWith(
                                                            fontSize: Dimensions
                                                                    .fontSizeExtraSmall -
                                                                (scrollingRate *
                                                                    2),
                                                            color: Theme.of(
                                                                    context)
                                                                .disabledColor,
                                                          )),
                                                      const SizedBox(
                                                          width: Dimensions
                                                              .paddingSizeExtraSmall),
                                                      Text(
                                                        PriceConverter
                                                            .convertPrice(store
                                                                .minimumOrder),
                                                        textDirection:
                                                            TextDirection.ltr,
                                                        style: robotoMedium.copyWith(
                                                            fontSize: Dimensions
                                                                    .fontSizeExtraSmall -
                                                                (scrollingRate *
                                                                    2),
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor),
                                                      ),
                                                    ]),
                                                  ])),
                                              GetBuilder<WishListController>(
                                                  builder: (wishController) {
                                                bool isWished = wishController
                                                    .wishStoreIdList
                                                    .contains(store!.id);
                                                return InkWell(
                                                  onTap: () {
                                                    if (Get.find<
                                                            AuthController>()
                                                        .isLoggedIn()) {
                                                      isWished
                                                          ? wishController
                                                              .removeFromWishList(
                                                                  store!.id,
                                                                  true)
                                                          : wishController
                                                              .addToWishList(
                                                                  null,
                                                                  store,
                                                                  true);
                                                    } else {
                                                      showCustomSnackBar(
                                                          'you_are_not_logged_in'
                                                              .tr);
                                                    }
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: Theme.of(context)
                                                          .primaryColor
                                                          .withOpacity(0.1),
                                                      borderRadius: BorderRadius
                                                          .circular(Dimensions
                                                              .radiusDefault),
                                                    ),
                                                    padding: const EdgeInsets
                                                            .all(
                                                        Dimensions
                                                            .paddingSizeExtraSmall),
                                                    child: Icon(
                                                      isWished
                                                          ? Icons.favorite
                                                          : Icons
                                                              .favorite_border,
                                                      color: isWished
                                                          ? Theme.of(context)
                                                              .primaryColor
                                                          : Theme.of(context)
                                                              .disabledColor,
                                                      size: 24 -
                                                          (scrollingRate * 4),
                                                    ),
                                                  ),
                                                );
                                              }),
                                              const SizedBox(
                                                  width: Dimensions
                                                      .paddingSizeSmall),
                                            ]),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                background: CustomImage(
                                  fit: BoxFit.cover,
                                  image:
                                      '${Get.find<SplashController>().configModel!.baseUrls!.storeCoverPhotoUrl}/${store!.coverPhoto}',
                                ),
                              ),
                              actions: const [
                                SizedBox(),
                              ],
                            ),
*/

/*
              SliverToBoxAdapter(child: Center(child: Container(
                width: Dimensions.webMaxWidth,
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                color: Theme.of(context).cardColor,
                child: Column(children: [
                  ResponsiveHelper.isDesktop(context) ? const SizedBox() : StoreDescriptionView(store: store),
                  store.discount != null ? Container(
                    width: context.width,
                    margin: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.radiusSmall), color: Theme.of(context).primaryColor),
                    padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text(
                        store.discount!.discountType == 'percent' ? '${store.discount!.discount}% ${'off'.tr}'
                            : '${PriceConverter.convertPrice(store.discount!.discount)} ${'off'.tr}',
                        style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).cardColor),
                          textDirection: TextDirection.ltr,
                      ),
                      store.discount!.discountType == 'percent' ? Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Text(
                          'enjoy'.tr,
                          style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).cardColor),
                        ),

                        Text(
                            '${store.discount!.discount}% ',
                            style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).cardColor), textDirection: TextDirection.ltr,
                          ),
                        Text(
                            'off_on_all_categories'.tr,
                            style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).cardColor),
                          ),
                        ],
                      ) : Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Text(
                          'enjoy'.tr,
                          style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).cardColor),
                        ),

                        Text(
                          PriceConverter.convertPrice(store.discount!.discount),
                          style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).cardColor), textDirection: TextDirection.ltr,
                        ),
                        Text(
                          ' ${'off_on_all_categories'.tr}',
                          style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).cardColor),
                        ),
                      ]),
                      SizedBox(height: (store.discount!.minPurchase != 0 || store.discount!.maxDiscount != 0) ? 5 : 0),
                      store.discount!.minPurchase != 0 ? Text(
                        '[ ${'minimum_purchase'.tr}: ${PriceConverter.convertPrice(store.discount!.minPurchase)} ]',
                        style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).cardColor), textDirection: TextDirection.ltr,
                      ) : const SizedBox(),
                      store.discount!.maxDiscount != 0 ? Text(
                        '[ ${'maximum_discount'.tr}: ${PriceConverter.convertPrice(store.discount!.maxDiscount)} ]',
                        style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).cardColor), textDirection: TextDirection.ltr,
                      ) : const SizedBox(),
                      Text(
                        '[ ${'daily_time'.tr}: ${DateConverter.convertTimeToTime(store.discount!.startTime!)} '
                            '- ${DateConverter.convertTimeToTime(store.discount!.endTime!)} ]',
                        style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).cardColor),
                      ),
                    ]),
                  ) : const SizedBox(),
                  const SizedBox(height: Dimensions.paddingSizeLarge),

                  storeController.recommendedItemModel != null && storeController.recommendedItemModel!.items!.isNotEmpty ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('recommended_items'.tr, style: robotoMedium),
                      const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                      SizedBox(
                        height: ResponsiveHelper.isDesktop(context) ? 150 : 125,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: storeController.recommendedItemModel!.items!.length,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: ResponsiveHelper.isDesktop(context) ? const EdgeInsets.symmetric(vertical: 20) : const EdgeInsets.symmetric(vertical: 10) ,
                              child: Container(
                                width: ResponsiveHelper.isDesktop(context) ? 500 : 300,
                                padding: const EdgeInsets.only(right: Dimensions.paddingSizeSmall, left: Dimensions.paddingSizeExtraSmall),
                                margin: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                                child: ItemWidget(
                                  isStore: false, item: storeController.recommendedItemModel!.items![index],
                                  store: null, index: index, length: null, isCampaign: false, inStore: true,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ) : const SizedBox(),
                ]),
              ))),
*/
                  
                  
                      (storeController.categoryList!.isNotEmpty)
                          ? SliverPersistentHeader(
                              pinned: true,
                              delegate: SliverDelegate(
                                  height: 250,
                                  child: Center(
                                      child: Container(
                                    width: Dimensions.webMaxWidth,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).cardColor,
                                      // boxShadow: [
                                      //   BoxShadow(
                                      //       color: Colors.grey[
                                      //           Get.isDarkMode ? 700 : 300]!,
                                      //       spreadRadius: 1,
                                      //       blurRadius: 5)
                                      // ],
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        vertical:
                                            Dimensions.paddingSizeExtraSmall),
                                    child: Column(
                                      children: [

/*
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal:
                                                  Dimensions.paddingSizeSmall),
                                          child: Row(children: [
                                            Text('all_products'.tr,
                                                style: robotoBold.copyWith(
                                                    fontSize: Dimensions
                                                        .fontSizeDefault)),
                                            const Expanded(child: SizedBox()),
/*
                                            InkWell(
                                              onTap: () => Get.toNamed(
                                                  RouteHelper
                                                      .getSearchStoreItemRoute(
                                                          store!.id)),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          Dimensions
                                                              .radiusDefault),
                                                  color: Theme.of(context)
                                                      .primaryColor
                                                      .withOpacity(0.1),
                                                ),
                                                padding: const EdgeInsets.all(
                                                    Dimensions
                                                        .paddingSizeExtraSmall),
                                                child: Icon(Icons.search,
                                                    size: 28,
                                                    color: Theme.of(context)
                                                        .primaryColor),
                                              ),
                                            ),
                                          
                                          */
                                            /*
                          storeController.type.isNotEmpty ? VegFilterWidget(
                              type: storeController.type,
                              onSelected: (String type) {
                                storeController.getStoreItemList(storeController.store!.id, 1, type, true);
                              },
                          ) : const SizedBox(),
                          */
                                          ]),
                                        ),
*/

                                      Container(
                                        margin:const EdgeInsets.only(top: 20),
                                        padding:const EdgeInsets.only(right: 15),
                                        width: MediaQuery.of(context).size.width,
                                          alignment: Alignment.centerRight
                                          ,
                                          child: Text("الفئات ..",style: TextStyle(
                                            fontSize: 16,
                                            color: Theme.of(context).primaryColor
                                          ),)
                                          ),
                                        
                                        const SizedBox(height: 10),
                                        SizedBox(
                                          
                                          height: 50,
                                          child: ListView.builder(
                                            
                                            scrollDirection: Axis.horizontal,
                                            itemCount: storeController
                                                .categoryList!.length,
                                            padding: const EdgeInsets.only(
                                                left: Dimensions
                                                    .paddingSizeSmall),
                                            physics:
                                                const BouncingScrollPhysics(),
                                            itemBuilder: (context, index) {
                                              print("${storeController.categoryList![index].image}");
                                              return InkWell(
                                                onTap: () => storeController
                                                    .setCategoryIndex(index),
                                                child: Container(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: Dimensions
                                                          .paddingSizeSmall,
                                                      vertical: Dimensions
                                                          .paddingSizeExtraSmall),
                                                  margin: const EdgeInsets.only(
                                                      right: Dimensions
                                                          .paddingSizeSmall),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            Dimensions
                                                                .radiusDefault),
                                                    color: index ==
                                                            storeController
                                                                .categoryIndex
                                                        ? Theme.of(context)
                                                            .primaryColor
                                                            .withOpacity(0.1)
                                                        : Colors.grey[100],
                                                  ),
                                                  child: Row(
                                                    
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                              if(index>0)   Container(
                                                      height: 50,
                                                      width: 50,
                                                      child:
                                                    Image.network("${AppConstants.baseUrl}/storage/app/public/category/${storeController.categoryList![index].image}",))
                                                    
                                                    ,


                                                        Text(
                                                          storeController
                                                              .categoryList![
                                                                  index]
                                                              .name!,
                                                          style: index ==
                                                                  storeController
                                                                      .categoryIndex
                                                              ? robotoMedium.copyWith(
                                                                fontWeight: FontWeight.bold,
                                                                  fontSize:
                                                                      Dimensions
                                                                          .fontSizeSmall,
                                                                  color: Theme.of(
                                                                          context)
                                                                      .primaryColor)
                                                              : robotoRegular.copyWith(
                                                                  fontSize:
                                                                      Dimensions
                                                                          .fontSizeSmall),
                                                        ),
                                               
                                                      ]),
                                                ),
                                              );
                                            },
                                          ),
                                        ),

                                        Container(
                                          margin: EdgeInsets.only(top: 50),
                                          padding:const EdgeInsets.symmetric(horizontal: 15),
                                          child:Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [


                                   



                                                                                    InkWell(
          onTap: () => Get.toNamed(RouteHelper.getStoreReviewRoute(store!.id)),
          child:          Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                             crossAxisAlignment: CrossAxisAlignment.center,
                                             children: [
                                               Row(
                                                 mainAxisAlignment: MainAxisAlignment.start,children: [
                                                 Icon(
                                                   Icons.star,
                                                   color: Theme.of(context).primaryColor,size: 28)

                                                 ,Text("${storeController
                                                     .store?.avgRating}")
                                               ],),
                                               Row(
                                                 mainAxisAlignment: MainAxisAlignment.center,
                                                 children: [
                                                   Text("${storeController
                                                       .store?.ratingCount}"),
                                                   const Text("التقيمات"),

                                                 ],
                                               )
                                             ],
                                            )
                                      ,
        ),


                                

                                            
                                            // const Expanded(child: SizedBox()),
                                                     InkWell(
          onTap: () => Get.toNamed(RouteHelper.getMapRoute(
            AddressModel(
              id: store!.id, address: store.address, latitude: store.latitude,
              longitude: store.longitude, contactPersonNumber: '', contactPersonName: '', addressType: '',
            ), 'store', Get.find<SplashController>().getModuleConfig(Get.find<SplashController>().module!.moduleType!).newVariation!
          )),
          child:             Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [

                                                  Icon(
                                                    Icons.info,
                                                    color: Theme.of(context).primaryColor,size: 28,),



                                                   

                                                     Text(Get.find<SplashController>().configModel!.moduleConfig!.module!.showRestaurantText!
          ? "عـنـوان الـمـطـعـم": "عـنـوان الـمـتـجـر"),



                                              ],
                                            ),
        ),
                                            
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [

                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.timer,
                                                      color: Theme.of(context).primaryColor,size: 28,),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.redAccent,
                                                      borderRadius: BorderRadius.circular(5)
                                                    ),
                                                     height: 35,
                                                      width: 80,
                                                      alignment: Alignment.center
                                                      ,child: Text("${storeController.store?.deliveryTime}"
                                                  ,style:const TextStyle(color: Colors.white),))


                                                  ],
                                                )



                                                ,const Text("يـسـتـغـرق الـطـلـب"),

                                              ],
                                            )

                                          ],),
                                        )


                                 
                                      ],
                                    ),
                                  ))),
                            )
                          : const SliverToBoxAdapter(child: SizedBox()),


                      SliverToBoxAdapter(
                          child: FooterView(
                              child: Container(
                        width: Dimensions.webMaxWidth,
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                        ),
                        child: PaginatedListView(
                          scrollController: scrollController,
                          onPaginate: (int? offset) =>
                              storeController.getStoreItemList(widget.store!.id,
                                  offset!, storeController.type, false),
                          totalSize: storeController.storeItemModel != null
                              ? storeController.storeItemModel!.totalSize
                              : null,
                          offset: storeController.storeItemModel != null
                              ? storeController.storeItemModel!.offset
                              : null,
                          itemView: ItemsView(
                                              storeName: 
                                              store?.name??"", 

                            isStore: false,
                            stores: storeController.storeModel!.stores,
                            items: 
                            (storeController.categoryList!.isNotEmpty &&
                                    storeController.storeItemModel != null)
                                ? storeController.storeItemModel!.items
                                : 
                                null,
                            inStorePage: true,
                            padding: const EdgeInsets.symmetric(
                              horizontal: Dimensions.paddingSizeSmall,
                              vertical: Dimensions.paddingSizeSmall,
                            ),
                          ),
                        ),
                      ))),

                   
                    ],
                  )
                : const Center(child: CircularProgressIndicator());
          });
        }),
        floatingActionButton:
            GetBuilder<StoreController>(builder: (storeController) {
          return Visibility(
            visible: storeController.showFavButton &&
                Get.find<SplashController>()
                    .configModel!
                    .moduleConfig!
                    .module!
                    .orderAttachment! &&
                (storeController.store != null &&
                    storeController.store!.prescriptionOrder!) &&
                Get.find<SplashController>().configModel!.prescriptionStatus!,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                boxShadow: [
                  BoxShadow(
                      color: Theme.of(context).primaryColor.withOpacity(0.5),
                      blurRadius: 10,
                      offset: const Offset(2, 2))
                ],
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 800),
                  width: storeController.currentState == true
                      ? 0
                      : ResponsiveHelper.isDesktop(context)
                          ? 180
                          : 150,
                  height: 30,
                  curve: Curves.linear,
                  child: Center(
                    child: Text(
                      'prescription_order'.tr,
                      textAlign: TextAlign.center,
                      
                      style: robotoMedium.copyWith(
                          color: Theme.of(context).primaryColor),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => Get.toNamed(
                    RouteHelper.getCheckoutRoute('prescription',
                        storeId: storeController.store!.id),
                    arguments: CheckoutScreen(
                        fromCart: false,
                        cartList: null,
                        storeId: storeController.store!.id),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius:
                          BorderRadius.circular(Dimensions.radiusSmall),
                    ),
                    padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                    child: Image.asset(Images.prescriptionIcon,
                        height: 25, width: 25),
                  ),
                ),
              ]),
            ),
          );
        }),
        bottomNavigationBar:
            GetBuilder<CartController>(builder: (cartController) {
          return cartController.cartList.isNotEmpty &&
                  !ResponsiveHelper.isDesktop(context)
              ? const BottomCartWidget()
              : const SizedBox();
        }));
  }
}

class SliverDelegate extends SliverPersistentHeaderDelegate {
  Widget child;
  double height;

  SliverDelegate({required this.child, this.height = 100});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(SliverDelegate oldDelegate) {
    return oldDelegate.maxExtent != height ||
        oldDelegate.minExtent != height ||
        child != oldDelegate.child;
  }
}

class CategoryProduct {
  CategoryModel category;
  List<Item> products;
  CategoryProduct(this.category, this.products);
}