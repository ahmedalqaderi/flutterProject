import 'package:talabiapp/controller/splash_controller.dart';
import 'package:talabiapp/data/model/response/item_model.dart';
import 'package:talabiapp/data/model/response/store_model.dart';
import 'package:talabiapp/helper/responsive_helper.dart';
import 'package:talabiapp/util/dimensions.dart';
import 'package:talabiapp/util/styles.dart';
import 'package:talabiapp/view/base/no_data_screen.dart';
import 'package:talabiapp/view/base/item_shimmer.dart';
import 'package:talabiapp/view/base/item_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:talabiapp/view/screens/home/theme1/store_widget.dart';

import '../../controller/item_controller.dart';
import '../../data/model/response/config_model.dart';
import 'custom_image.dart';

class ItemsView extends StatefulWidget {
  final List<Item?>? items;
  final List<Store?>? stores;
  final bool isStore;
  final EdgeInsetsGeometry padding;
  final bool isScrollable;
  final int shimmerLength;
  final String? noDataText;
  final bool isCampaign;
  final bool inStorePage;
  final bool isFeatured;
  final bool showTheme1Store;
  final bool isWishList;
  final String storeName;
  const ItemsView({Key? key,required this.storeName,this.isWishList=false,required this.stores, required this.items, required this.isStore, this.isScrollable = false,
    this.shimmerLength = 20, this.padding = const EdgeInsets.all(Dimensions.paddingSizeSmall), this.noDataText,
    this.isCampaign = false, this.inStorePage = false, this.isFeatured = false, this.showTheme1Store = false}) : super(key: key);

  @override
  State<ItemsView> createState() => _ItemsViewState();
}

class _ItemsViewState extends State<ItemsView> {
  
  var currency=Get.find<SplashController>();
  @override
  Widget build(BuildContext context) {
    print("this the store name ${widget.storeName} ==  = == == ");
    BaseUrls? baseUrls = Get.find<SplashController>().configModel!.baseUrls;


    bool isNull = true;
    int length = 0;
    if(widget.isStore) {
      isNull = widget.stores == null;
      if(!isNull) {
        length = widget.stores!.length;
      }
    }else {
      isNull = widget.items == null;
      if(!isNull) {
        length = widget.items!.length;
      }
    }


    return Container(
     //  color: Colors.green,
      // margin: EdgeInsets.symmetric(horizontal: 15),
      // height: MediaQuery.of(context).size.height,
      // width: MediaQuery.of(context),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center
          ,children: [
    
        !isNull ? length > 0 ?
        //  GridView.builder(
       !widget.isStore&&currency.module?.id!=1?
      // !widget.isStore?
            Padding(
              padding: const EdgeInsets.only(top:6.0),
              child: GridView.builder(
                
           physics:   
          //  widget.isScrollable ? const BouncingScrollPhysics() :
              const NeverScrollableScrollPhysics(),
    shrinkWrap: true
   , gridDelegate:
          // SliverGridDelegateWithFixedCrossAxisCount(
          //               childAspectRatio: 1,
          //               crossAxisCount: ResponsiveHelper.isDesktop(context) ? 8 : 2,
          //               mainAxisSpacing: 0,
          //               crossAxisSpacing: 0,
          //             ),
   const SliverGridDelegateWithMaxCrossAxisExtent(
    // crossAxisCount: 3,
    // mainAxisExtent: 190,
                // crossAxisSpacing: 5,
                // mainAxisSpacing: 1,
                maxCrossAxisExtent: 200,
                // childAspectRatio: 135/185,
                 //crossAxisSpacing: 20,
                // mainAxisSpacing: 20,
                // mainAxisExtent: 20
    ),
                padding:const EdgeInsets.symmetric(horizontal: 15),
                itemCount:widget.items!.length ,
                itemBuilder: (context, index) {
                 return
                  InkWell(
      onTap: () {
      
          Get.find<ItemController>().navigateToItemPage(widget.items?[index], context, inStore: true, isCampaign: false);
 
      },
      child: Container(
        height: 180,
      
        margin:const EdgeInsets.only(right: 10,left: 10),
        // color: Colors.grey,
        width: 180,
        child: SingleChildScrollView(
          physics:const NeverScrollableScrollPhysics(),

          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(10)

                  ),
                  // padding: EdgeInsets.only(right: 15,left: 15),

                  height: 110,
                  // alignment: Alignment.center,
                  width: 150,  //note:(170)
                  child: Stack(
                      fit: StackFit.expand,children:  [

                     Positioned(
                    top:0,
                    bottom: 0
                    ,right: 0,
                    left: 0
                    ,child: Container(
                       margin:const EdgeInsets.only(right: 15,left: 15,bottom: 15,top: 15),
                      child: CustomImage(
                           image:   "${baseUrls!.itemImageUrl}/${widget.items![index]!.image}",
                         height: 80 , fit: BoxFit.fill,width: 80,),
                    ),
                     ),
                    Positioned(
                      bottom: 5,right: 5,
                      child: Container(
                        // alignment: ,
                        decoration:const BoxDecoration(
                            color: Colors.white
                            ,shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 8,
                              offset: Offset(2,3)

                            )
                          ]
                        ),
                        height: 30,width: 30,child:const Icon(Icons.add,),),
                    )
                  ]),

                ),
                // Container(
                //   alignment: Alignment.topRight,
                //   margin:const EdgeInsets.only(top: 2),
                //   width:180,
                //   child: Text(
                //   "${widget.items?[index]?.price}"
                //     ,style: robotoMedium.copyWith(fontSize: 16,color: const Color.fromARGB(255, 6, 0, 0)),

                //     textAlign: TextAlign.start,
                //   ),
                // ),
                Container(
                  alignment: Alignment.topRight,
                  width: MediaQuery.of(context).size.width,
                  margin:const EdgeInsets.only(bottom: 2),//note:(between price and name)
                  child: Text(
                    "${widget.items?[index]?.description!=null&&widget.items![index]!.description!.length>20?
                    "${widget.items?[index]?.description?.substring(0,18)}"+"....":widget.items?[index]?.description }"

                    ,style: robotoMedium.copyWith(
                      fontSize: 12,color: Colors.black),
                    maxLines: 2, overflow: TextOverflow.ellipsis,//note:(we make width to two line )

                    textAlign: TextAlign.start,
                  ),
                ),
                 Container(
                  alignment: Alignment.topRight,
                  //margin:const EdgeInsets.only(top: 2)  //(المسافه بين الصنف و السعر)
                  margin:const EdgeInsets.only(bottom: 2),
                  width:180,
                  child: Text(
                  "${widget.items?[index]?.price }${currency.configModel?.currencySymbol??""}" //note:("=============")
                    ,style: robotoMedium.copyWith(fontSize: 14,color: const Color.fromARGB(255, 6, 0, 0)),

                    textAlign: TextAlign.start,
                  ),
                ),
              ],
          ),
        ),),);


                },
    ),
            ):

          ListView.builder(
          key: UniqueKey(),
          // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          //   crossAxisSpacing: Dimensions.paddingSizeLarge,
          //   mainAxisSpacing: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeLarge : 0.01,
          //   childAspectRatio: ResponsiveHelper.isDesktop(context) ? 4 : widget.showTheme1Store ? 2 : 3.5,
          //   crossAxisCount: ResponsiveHelper.isMobile(context) ? 1 : 2,
          // ),
          physics: widget.isScrollable ? const BouncingScrollPhysics() : const NeverScrollableScrollPhysics(),
          shrinkWrap: widget.isScrollable ? false : true,
          itemCount: length,
          padding: widget.padding,
          itemBuilder: (context, index) {

            print("this the store length ${widget.stores?.length}  =  = = = = ==  == 00");
            return   currency.module?.id==1&&!widget.isStore?   ItemWidget(
              storeName: widget.storeName,
              currency: "${currency.configModel?.currencySymbol??" "}",
              isStore: widget.isStore, item: widget.isStore ? null : widget.items![index], isFeatured: widget.isFeatured,
              store: widget.isStore?widget.stores![index]:null , index: index, length: length, isCampaign: widget.isCampaign,
              inStore: widget.inStorePage,
            ):


              StoreWidget(


              store: widget.stores![index],
                index: index,
              inStore: widget.inStorePage,
            );
          },
        ) : NoDataScreen(
          text: widget.noDataText ?? (widget.isStore ? Get.find<SplashController>().configModel!.moduleConfig!.module!.showRestaurantText!
              ? 'no_restaurant_available'.tr : 'no_store_available'.tr : 'no_item_available'.tr),
        ) :
        ListView.builder(
          key: UniqueKey(),
          // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          //   crossAxisSpacing: Dimensions.paddingSizeLarge,
          //   mainAxisSpacing: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeLarge : 0.01,
          //   childAspectRatio: ResponsiveHelper.isDesktop(context) ? 4 : widget.showTheme1Store ? 1.9 : 4,
          //   crossAxisCount: ResponsiveHelper.isMobile(context) ? 1 : 2,
          // ),
          physics: widget.isScrollable ? const BouncingScrollPhysics() : const NeverScrollableScrollPhysics(),
          shrinkWrap: widget.isScrollable ? false : true,
          itemCount: widget.shimmerLength,
          padding: widget.padding,
          itemBuilder: (context, index) {
            return widget.showTheme1Store ? StoreShimmer(isEnable: isNull)
                : ItemShimmer(isEnabled: isNull, isStore: widget.isStore, hasDivider: index != widget.shimmerLength-1);
          },
        ),
    
      ]),
    );
  }
}
