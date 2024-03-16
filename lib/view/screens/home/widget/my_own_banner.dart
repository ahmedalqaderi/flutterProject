import 'package:carousel_slider/carousel_slider.dart';
import 'package:talabiapp/controller/banner_controller.dart';
import 'package:talabiapp/controller/item_controller.dart';
import 'package:talabiapp/controller/location_controller.dart';
import 'package:talabiapp/controller/splash_controller.dart';
import 'package:talabiapp/data/model/response/basic_campaign_model.dart';
import 'package:talabiapp/data/model/response/item_model.dart';
import 'package:talabiapp/data/model/response/module_model.dart';
import 'package:talabiapp/data/model/response/store_model.dart';
import 'package:talabiapp/data/model/response/zone_response_model.dart';
import 'package:talabiapp/helper/route_helper.dart';
import 'package:talabiapp/util/dimensions.dart';
import 'package:talabiapp/view/base/custom_image.dart';
import 'package:talabiapp/view/base/custom_snackbar.dart';
import 'package:talabiapp/view/screens/store/store_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:url_launcher/url_launcher_string.dart';

class MyOwnBanner extends StatefulWidget {
  final bool isFeatured;
  bool isShowIndicator;
  bool isUnderPanner;
  double heigh;
    MyOwnBanner({Key? key,this.isShowIndicator=false,this.heigh=290,this.isUnderPanner=false ,required this.isFeatured}) : super(key: key);

  @override
  State<MyOwnBanner> createState() => _MyOwnBannerState();
}

class _MyOwnBannerState extends State<MyOwnBanner> {
  @override
  Widget build(BuildContext context) {

    return GetBuilder<BannerController>(builder: (bannerController) {
      List<String?>? bannerList = widget.isFeatured ? bannerController.featuredBannerListt : bannerController.bannerImageList;
      List<dynamic>? bannerDataList = widget.isFeatured ? bannerController.featuredBannerDataListt : bannerController.bannerDataList;

      return (bannerList != null && bannerList.isEmpty) ? const SizedBox() : Container(
        width: MediaQuery.of(context).size.width,
        height:   this.widget.heigh  ,
        // padding: const EdgeInsets.only(top: Dimensions.paddingSizeDefault),
        // color: Colors.green
        child: bannerList != null ? 
        
     widget.isUnderPanner?
        Stack(
          fit: StackFit.expand,
            children: [
              CarouselSlider.builder(
                    options: CarouselOptions(
                      autoPlay: true,
                      // enlargeCenterPage: true,
                      disableCenter: true,
                      viewportFraction: 1,
                      autoPlayInterval: const Duration(seconds: 7),
                      onPageChanged: (index, reason) {
                        bannerController.setCurrentIndex(index, true);
                      },
                    ),
                    itemCount: bannerList.isEmpty ? 1 : bannerList.length,
                    itemBuilder: (context, index, _) {
                      String? baseUrl = bannerDataList![index] is BasicCampaignModel ? Get.find<SplashController>()
                          .configModel!.baseUrls!.campaignImageUrl  : Get.find<SplashController>().configModel!.baseUrls!.bannerImageUrl;
                      return InkWell(
                        onTap: () async {
                          if(bannerDataList[index] is Item) {
                            Item? item = bannerDataList[index];
                            Get.find<ItemController>().navigateToItemPage(item, context);
                          }else if(bannerDataList[index] is Store) {
                            Store? store = bannerDataList[index];
                            if(widget.isFeatured && (Get.find<LocationController>().getUserAddress()!.zoneData != null && Get.find<LocationController>().getUserAddress()!.zoneData!.isNotEmpty)) {
                              for(ModuleModel module in Get.find<SplashController>().moduleList!) {
                                if(module.id == store!.moduleId) {
                                  Get.find<SplashController>().setModule(module);
                                  break;
                                }
                              }
                              ZoneData zoneData = Get.find<LocationController>().getUserAddress()!.zoneData!.firstWhere((data) => data.id == store!.zoneId);
        
                              Modules module = zoneData.modules!.firstWhere((module) => module.id == store!.moduleId);
                              Get.find<SplashController>().setModule(ModuleModel(id: module.id, moduleName: module.moduleName, moduleType: module.moduleType, themeId: module.themeId, storesCount: module.storesCount));
                            }
                            Get.toNamed(
                              RouteHelper.getStoreRoute(store!.id, widget.isFeatured ? 'module' : 'banner'),
                              arguments: StoreScreen(store: store, fromModule: widget.isFeatured),
                            );
                          }else if(bannerDataList[index] is BasicCampaignModel) {
                            BasicCampaignModel campaign = bannerDataList[index];
                            Get.toNamed(RouteHelper.getBasicCampaignRoute(campaign));
                          }else {
                            String url = bannerDataList[index];
                            if (await canLaunchUrlString(url)) {
                              await launchUrlString(url, mode: LaunchMode.externalApplication);
                            }else {
                              showCustomSnackBar('unable_to_found_url'.tr);
                            }
                          }
                        },
                        child: Container(
                          height:widget.heigh,
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                            boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 800 : 200]!,
                             spreadRadius: 1, blurRadius: 5)],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                            child: GetBuilder<SplashController>(builder: (splashController) {
                              return CustomImage(
                                image: '$baseUrl/${bannerList[index]}',
                          height:widget.heigh,
                                fit: BoxFit.fill,
                              );
                            }),
                          ),
                        ),
                      );
                    },
                  ),
           if(widget.isShowIndicator)
             Positioned(
              bottom: 0,
              right: 0,
              left: 0,
               child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: bannerList.map((bnr) {
                    int index = bannerList.indexOf(bnr);
                    return TabPageSelectorIndicator(
                      backgroundColor: index == bannerController.currentIndex ? Theme.of(context).secondaryHeaderColor
                          : Theme.of(context).secondaryHeaderColor.withOpacity(0.5),
                      borderColor: Theme.of(context).colorScheme.background,
                      size: index == bannerController.currentIndex ? 10 : 7,
                    );
                  }).toList(),
                ),
             ),
           
            ],
          ):SizedBox(
          child:
          Column(
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CarouselSlider.builder(
                options: CarouselOptions(
                  autoPlay: true,
                  // enlargeCenterPage: true,
                  disableCenter: true,
                  viewportFraction: 1,
                  autoPlayInterval: const Duration(seconds: 7),
                  onPageChanged: (index, reason) {
                    bannerController.setCurrentIndex(index, true);
                  },
                ),
                itemCount: bannerList.isEmpty ? 1 : bannerList.length,
                itemBuilder: (context, index, _) {
                  String? baseUrl = bannerDataList![index] is BasicCampaignModel ? Get.find<SplashController>()
                      .configModel!.baseUrls!.campaignImageUrl  : Get.find<SplashController>().configModel!.baseUrls!.bannerImageUrl;
                  return InkWell(
                    onTap: () async {
                      if(bannerDataList[index] is Item) {
                        Item? item = bannerDataList[index];
                        Get.find<ItemController>().navigateToItemPage(item, context);
                      }else if(bannerDataList[index] is Store) {
                        Store? store = bannerDataList[index];
                        if(widget.isFeatured && (Get.find<LocationController>().getUserAddress()!.zoneData != null && Get.find<LocationController>().getUserAddress()!.zoneData!.isNotEmpty)) {
                          for(ModuleModel module in Get.find<SplashController>().moduleList!) {
                            if(module.id == store!.moduleId) {
                              Get.find<SplashController>().setModule(module);
                              break;
                            }
                          }
                          ZoneData zoneData = Get.find<LocationController>().getUserAddress()!.zoneData!.firstWhere((data) => data.id == store!.zoneId);
        
                          Modules module = zoneData.modules!.firstWhere((module) => module.id == store!.moduleId);
                          Get.find<SplashController>().setModule(ModuleModel(id: module.id, moduleName: module.moduleName, moduleType: module.moduleType, themeId: module.themeId, storesCount: module.storesCount));
                        }
                        Get.toNamed(
                          RouteHelper.getStoreRoute(store!.id, widget.isFeatured ? 'module' : 'banner'),
                          arguments: StoreScreen(store: store, fromModule: widget.isFeatured),
                        );
                      }else if(bannerDataList[index] is BasicCampaignModel) {
                        BasicCampaignModel campaign = bannerDataList[index];
                        Get.toNamed(RouteHelper.getBasicCampaignRoute(campaign));
                      }else {
                        String url = bannerDataList[index];
                        if (await canLaunchUrlString(url)) {
                          await launchUrlString(url, mode: LaunchMode.externalApplication);
                        }else {
                          showCustomSnackBar('unable_to_found_url'.tr);
                        }
                      }
                    },
                    child: Container(
                      height:widget.heigh,
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                        boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 800 : 200]!,
                         spreadRadius: 1, blurRadius: 5)],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                        child: GetBuilder<SplashController>(builder: (splashController) {
                          return CustomImage(
                            image: '$baseUrl/${bannerList[index]}',
                      height:widget.heigh,
                            fit: BoxFit.fill,
                          );
                        }),
                      ),
                    ),
                  );
                },
              ),
        
              // const SizedBox(height: Dimensions.paddingSizeExtraSmall),
               Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: bannerList.map((bnr) {
                  int index = bannerList.indexOf(bnr);
                  return TabPageSelectorIndicator(
                    backgroundColor: index == bannerController.currentIndex ? Theme.of(context).secondaryHeaderColor
                        : Theme.of(context).secondaryHeaderColor.withOpacity(0.5),
                    borderColor: Theme.of(context).colorScheme.background,
                    size: index == bannerController.currentIndex ? 10 : 7,
                  );
                }).toList(),
              ),
        
            ],
          )   
        
      ) : Shimmer(
          duration: const Duration(seconds: 2),
          enabled: bannerList == null,
          child: Container(margin: const EdgeInsets.symmetric(horizontal: 10), decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
            color: Colors.grey[300],
          )),
        ),
      );
    });
  }
}
