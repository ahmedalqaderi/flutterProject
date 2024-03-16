import 'package:talabiapp/controller/category_controller.dart';
import 'package:talabiapp/controller/splash_controller.dart';
import 'package:talabiapp/helper/responsive_helper.dart';
import 'package:talabiapp/helper/route_helper.dart';
import 'package:talabiapp/util/dimensions.dart';
import 'package:talabiapp/util/styles.dart';
import 'package:talabiapp/view/base/custom_image.dart';
import 'package:talabiapp/view/base/title_widget.dart';
import 'package:talabiapp/view/screens/home/widget/category_pop_up.dart';
import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:get/get.dart';

class CategoryView1 extends StatelessWidget {
   const CategoryView1({Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScrollController scrollController = ScrollController();

    return GetBuilder<CategoryController>(builder: (categoryController) {
      return (categoryController.categoryList != null && categoryController.categoryList!.isEmpty) ? const SizedBox() : Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: TitleWidget(title: 'categories'.tr, onTap: () => Get.toNamed(RouteHelper.getCategoryRoute())),
          ),
          Row(
            children: [

              Expanded(
                child: Container(
                  // color: Colors.green,
                  height: 170,
                  child: categoryController.categoryList != null ? GridView.builder(
                    gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount:2
                        ,
                      crossAxisSpacing: 3,
                      mainAxisExtent: 100,

                    ),
                    shrinkWrap: true,

                    controller: scrollController,
                    itemCount: categoryController.categoryList!.length > 15 ? 15 : categoryController.categoryList!.length,
                    padding: const EdgeInsets.only(left: Dimensions.paddingSizeSmall),
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: InkWell(
                          onTap: () => Get.toNamed(RouteHelper.getCategoryItemRoute(
                            categoryController.categoryList![index].id, categoryController.categoryList![index].name!,
                          )),
                          child: SizedBox(
                            width: 25,
                            child: Container(
                              height: 65, width: 25,
                              margin: EdgeInsets.only(
                                left: index == 0 ? 0 : Dimensions.paddingSizeExtraSmall,
                                right: Dimensions.paddingSizeExtraSmall,
                              ),
                              child: Stack(children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: CustomImage(
                                    image: '${Get.find<SplashController>().configModel!.baseUrls!.categoryImageUrl}/${categoryController.categoryList?[index].image}',
                                    height: 80, width:MediaQuery.of(context).size.width, fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(bottom: 0, left: 0, right: 0, top: 0,child: Container(
                                  height: MediaQuery.of(context).size.height,
                                  width: 75,
                                  padding: EdgeInsets.only(top: 30),
                                  decoration: BoxDecoration(
                                    borderRadius:  BorderRadius.circular(10),
                                    color: Theme.of(context).primaryColor.withOpacity(0.8),
                                  ),
                                  child: Text(
                                    categoryController.categoryList![index].name!, maxLines: 1, overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                    style: robotoMedium.copyWith(fontSize:12, color: Colors.white),
                                  ),
                                )),
                              ]),
                            ),
                          ),
                        ),
                      );
                    },
                  )
                  // : Container(child: Text("sdfas"),
                  :       Container(
                                  padding: EdgeInsets.only(right: 15,left: 15),

                height: 150,
                width: MediaQuery.of(context).size.width,
                child: GridView.builder(
                  shrinkWrap: true,
                // physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.horizontal,
                       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount:2,

                          // childAspectRatio: 100,
                        crossAxisSpacing: 3,
                        mainAxisSpacing: 5,
                        mainAxisExtent: 80,
              
                      ),
                      itemCount: 10,
                  itemBuilder:(context, index) {
                    return CategoryAllShimmer(categoryController: categoryController);
                  }
                ),
              )
                  // : CategoryShimmer(categoryController: categoryController),
                ),
              ),

              ResponsiveHelper.isMobile(context) ? const SizedBox() : categoryController.categoryList != null ? Column(
                children: [
                  InkWell(
                    onTap: (){
                      showDialog(context: context, builder: (con) => Dialog(child: SizedBox(height: 550, width: 600, child: CategoryPopUp(
                        categoryController: categoryController,
                      ))));
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                      child: CircleAvatar(
                        radius: 35,
                        backgroundColor: Theme.of(context).primaryColor,
                        child: Text('view_all'.tr, style: TextStyle(fontSize: Dimensions.paddingSizeDefault, color: Theme.of(context).cardColor)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10,)
                ],
              ):
              Container(
                                  padding: EdgeInsets.only(right: 15,left: 15),

                height: 150,
                width: MediaQuery.of(context).size.width,
                child: GridView.builder(
                  shrinkWrap: true,
                // physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.horizontal,
                       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount:2,

                          // childAspectRatio: 100,
                        crossAxisSpacing: 3,
                        mainAxisSpacing: 5,
                        mainAxisExtent: 80,
              
                      ),
                      itemCount: 10,
                  itemBuilder:(context, index) {
                    return CategoryAllShimmer(categoryController: categoryController);
                  }
                ),
              )
            ],
          ),

        ],
      );
    });
  }
}

class CategoryShimmer extends StatelessWidget {
  final CategoryController categoryController;
  const CategoryShimmer({Key? key, required this.categoryController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 75,
      child: ListView.builder(
        itemCount: 14,
        padding: const EdgeInsets.only(left: Dimensions.paddingSizeSmall),
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 1),
            child: SizedBox(
              width: 75,
              child: Container(
                height: 65, width: 65,
                margin: EdgeInsets.only(
                  left: index == 0 ? 0 : Dimensions.paddingSizeExtraSmall,
                  right: Dimensions.paddingSizeExtraSmall,
                ),
                child: Shimmer(
                  duration: const Duration(seconds: 2),
                  enabled: categoryController.categoryList == null,
                  child: Container(
                    height: 65, width: 65,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class CategoryAllShimmer extends StatelessWidget {
  final CategoryController categoryController;
  const CategoryAllShimmer({Key? key, required this.categoryController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
        color: Theme.of(context).secondaryHeaderColor,
        borderRadius:  BorderRadius.circular(10)
      ),
    );
  }
}

