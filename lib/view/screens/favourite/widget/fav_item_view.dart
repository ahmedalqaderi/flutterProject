import 'package:talabiapp/controller/wishlist_controller.dart';
import 'package:talabiapp/util/dimensions.dart';
import 'package:talabiapp/view/base/footer_view.dart';
import 'package:talabiapp/view/base/item_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FavItemView extends StatelessWidget {
  final bool isStore;
  final bool isSearch;
  const FavItemView({Key? key, required this.isStore, this.isSearch = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<WishListController>(builder: (wishController) {
    print("this the size of wishlist is ${wishController.wishItemIdList.length} = = = = = = ==");


        return RefreshIndicator(
          onRefresh: () async {
            await wishController.getWishList();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: FooterView(
              child: SizedBox(
                width: Dimensions.webMaxWidth,
                child: ItemsView(
                  storeName: "",
                  isWishList: true,
                  isStore: isStore, items: wishController.wishItemList, stores: wishController.wishStoreList,
                  noDataText: 'no_wish_data_found'.tr, isFeatured: true,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
