import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:talabiapp/controller/order_controller.dart';
import 'package:talabiapp/helper/responsive_helper.dart';
import 'package:talabiapp/util/dimensions.dart';
import 'package:talabiapp/util/images.dart';
import 'package:talabiapp/util/styles.dart';
import 'package:talabiapp/view/screens/checkout/widget/payment_button_new.dart';
class PaymentMethodBottomSheet extends StatefulWidget {
  final bool isCashOnDeliveryActive;
  final bool isDigitalPaymentActive;
  final bool isWalletActive;
  final bool isJwaliActive;
  final int? storeId;
     Function? showingJwaliForm;
    PaymentMethodBottomSheet({Key? key, this.showingJwaliForm,required this.isCashOnDeliveryActive,required this.isJwaliActive, required this.isDigitalPaymentActive, required this.isWalletActive, required this.storeId}) : super(key: key);

  @override
  State<PaymentMethodBottomSheet> createState() => _PaymentMethodBottomSheetState();
}

class _PaymentMethodBottomSheetState extends State<PaymentMethodBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return
     Container(
      width: 550,
      margin: EdgeInsets.only(top: GetPlatform.isWeb ? 0 : 30),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: ResponsiveHelper.isMobile(context) ? const BorderRadius.vertical(top: Radius.circular(Dimensions.radiusExtraLarge))
            : const BorderRadius.all(Radius.circular(Dimensions.radiusExtraLarge)),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeLarge),
        child: GetBuilder<OrderController>(
          builder: (orderController) {
            return Column(children: [

              !ResponsiveHelper.isDesktop(context) ? Container(
                height: 4, width: 35,
                margin: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
                decoration: BoxDecoration(color: Theme.of(context).disabledColor, borderRadius: BorderRadius.circular(10)),
              ) : const SizedBox(),

              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('choose_payment_method'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault)),
                IconButton(
                  onPressed: ()=> Get.back(),
                  icon: Icon(Icons.clear, color: Theme.of(context).disabledColor),
                )
              ]),

              const SizedBox(height: Dimensions.paddingSizeSmall),
              widget.isCashOnDeliveryActive ? PaymentButtonNew(
                icon: Images.codIcon,
                title: 'cash_on_delivery'.tr,
                isSelected: orderController.paymentMethodIndex == 0,
                onTap: () {
                  orderController.setPaymentMethod(0);
                  Get.back();
                },
              ) : const SizedBox(),
              SizedBox(height: widget.isCashOnDeliveryActive ? Dimensions.paddingSizeSmall : 0),

              widget.storeId == null && widget.isDigitalPaymentActive ? PaymentButtonNew(
                icon: Images.digitalPayment,
                title: 'digital_payment'.tr,
                isSelected: orderController.paymentMethodIndex == 1,
                onTap: (){
                  orderController.setPaymentMethod(1);
                  Get.back();
                },
              ) : const SizedBox(),
              SizedBox(height: widget.storeId == null && widget.isDigitalPaymentActive ? Dimensions.paddingSizeSmall : 0),

              widget.storeId == null && widget.isWalletActive ? PaymentButtonNew(
                icon: Images.wallet,
                title: 'wallet_payment'.tr,
                isSelected: orderController.paymentMethodIndex == 2,
                onTap: () {
                  orderController.setPaymentMethod(2);
                  Get.back();
                },
              ) : const SizedBox(),

//  storeId == null &&
  // isJwaliActive ?
   PaymentButtonNew(
                icon: Images.jwali,
                title: 'jwali'.tr,
                isSelected: orderController.paymentMethodIndex == 3,
                onTap: () {
                    //  widget.showingJwaliForm;
                   orderController.setPaymentMethod(3);
                  // print("this the order change state${orderController.sh}")
                  Get.back();
                     orderController.changeIsShwoingJwali(true);

                },
              ),


                 PaymentButtonNew(
                icon: Images.jwali,
                title: 'فلوسك',
                isSelected: orderController.paymentMethodIndex == 4,
                onTap: () {
                    //  widget.showingJwaliForm;
                   orderController.setPaymentMethod(4);
                  // print("this the order change state${orderController.sh}")
                  Get.back();
                     orderController.changeIsShwoingJwalii(true);

                },
              )  



              // : const SizedBox(),

            ]);
          }
        ),
      ),
    );
  }
}
