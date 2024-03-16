import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:talabiapp/controller/store_controller.dart';
import 'package:talabiapp/util/dimensions.dart';
import 'package:talabiapp/util/styles.dart';
import 'package:talabiapp/view/screens/favourite/favourite_screen.dart';

class FilterView extends StatelessWidget {
  const FilterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StoreController>(builder: (storeController) {
      return
          storeController.storeModel != null||
        storeController.storeIndex != null
              ?
          Container(
        height: 70,
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.bottomCenter,
        margin: EdgeInsets.only( top: 30),
        child: ListView(scrollDirection: Axis.horizontal, children:
            // return
            [
              SizedBox(width: 15,),
          InkWell(
            onTap: (() {
              storeController.setStoreType('all');
            }),
            child: Column(
              children: [
                Container(
                  height: 40,
                  width: 60,
                  decoration: BoxDecoration(
                    // borderRadius: BorderRadiusDirectional.circular(15),
                    // color: storeController.storeType == 'all'
      color: storeController.storeIndex == 'all'
                        ? Colors.grey.shade400
                        : null,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'all'.tr,
                    style: robotoMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      // fontSize: ,
                      // color: storeController.storeType == 'all'
                      color: 
                           Theme.of(context).primaryColor
                         ,
                    ),
                  ),
                ),

                // if(storeController.storeIndex == 'all')
                  Container(
                 height: 3,
                 width: 60,
                 color: Theme.of(context).secondaryHeaderColor,
               )
              ],
            ),
          ),
                       SizedBox(width: 15,),

         InkWell(
            onTap: () {
              storeController.setStoreType('take_away');
            },
            child: Column(
              children: [
                Container(
                  height: 40,
                  width: 60,
                  decoration: BoxDecoration(
                    // borderRadius: BorderRadiusDirectional.only(15),
                    // color: storeController.storeType == 'take_away'
      color: storeController.storeIndex == 'take_away'
                        ?Colors.grey.shade400
                        : null,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'take_away'.tr,
                    style: robotoMedium.copyWith(
                      fontWeight: FontWeight.bold,
       color: 
                          Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              // if(storeController.storeIndex == 'take_away')
                Container(

                  height: 3,
                  width: 60,
                  color: Theme.of(context).secondaryHeaderColor,
                )
              ],
            ),
          ),
                       SizedBox(width: 15,),

          InkWell(
            onTap: () {
              storeController.setStoreType('delivery');
            },
            child: Column(
              children: [
                Container(
                  height: 40,
                  width: 60,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      // color: storeController.storeType == 'delivery'
      color: storeController.storeIndex == 'delivery'
                          ? Colors.grey.shade400
                          : null,
                      // borderRadius: BorderRadiusDirectional.circular(15)),
      ),
                  child: Text(
                    'delivery'.tr,
                    style: robotoMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      // color: storeController.storeType == 'delivery'
                      color:  Theme.of(context).primaryColor
                          ,
                    ),
                  ),
                ),
                // if(storeController.storeIndex == 'delivery')
                  Container(

                    height: 3,
                    width: 60,
                    color: Theme.of(context).secondaryHeaderColor,
                  )

              ],
            ),
          ),
        

                       SizedBox(width: 15,),
          InkWell(
            onTap: () {
               Get.to(FavouriteScreen(index: 1,));
            },
            child: Column(
              children: [
                Container(
                  height: 40,
                  width: 60,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      // color: storeController.storeType == 'delivery'
      // color: storeController.storeIndex == 'delivery'
                          // ? Colors.grey.shade400
                          // : null,
                      // borderRadius: BorderRadiusDirectional.circular(15)),
      ),
                  child: Text(
                    'favorite'.tr,
                    style: robotoMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      // color: storeController.storeType == 'delivery'
                      color:  Theme.of(context).primaryColor
                          ,
                    ),
                  ),
                ),
                // if(storeController.storeIndex == 'delivery')
                  Container(

                    height: 3,
                    width: 60,
                    color: Theme.of(context).secondaryHeaderColor,
                  )

              ],
            ),
          ),
        
        
        
        
        ]),
      )

      // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
      // child: const Padding(
      //   padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
      //   child: Icon(Icons.filter_list),
      // ),
      //   onSelected: (dynamic value) => storeController.setStoreType(value),
      // )
      : const SizedBox(
        height: 10,
      );
      /*
      PopupMenuButton(
        itemBuilder: (context) {
          return [
            PopupMenuItem(value: 'all', textStyle: robotoMedium.copyWith(
              color: storeController.storeType == 'all'
                  ? Theme.of(context).textTheme.bodyLarge!.color : Theme.of(context).disabledColor,
            ), child: Text('all'.tr)),
            PopupMenuItem(value: 'take_away', textStyle: robotoMedium.copyWith(
              color: storeController.storeType == 'take_away'
                  ? Theme.of(context).textTheme.bodyLarge!.color : Theme.of(context).disabledColor,
            ), child: Text('take_away'.tr)),
            PopupMenuItem(value: 'delivery', textStyle: robotoMedium.copyWith(
              color: storeController.storeType == 'delivery'
                  ? Theme.of(context).textTheme.bodyLarge!.color : Theme.of(context).disabledColor,
            ), child: Text('delivery'.tr)),
          ];
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
          child: Icon(Icons.filter_list),
        ),
        onSelected: (dynamic value) => storeController.setStoreType(value),
      ) : const SizedBox();
  */
    });
  }
}
