import 'package:talabiapp/controller/order_controller.dart';
import 'package:talabiapp/util/dimensions.dart';
import 'package:talabiapp/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentButtonNew extends StatelessWidget {
  final String icon;
  final String title;
  final bool isSelected;
  final bool isJawali;
  
  final Function onTap;
  const PaymentButtonNew({Key? key, this.isJawali=false,required this.isSelected, required this.icon, required this.title, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrderController>(builder: (orderController) {
      return Padding(
        padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
        child: InkWell(
          onTap: onTap as void Function()?,
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? Theme.of(context).primaryColor : Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
              boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 800 : 200]!, blurRadius: 5, spreadRadius: 1)],
            ),
            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            child: Row(children: [
              Image.asset(
                icon, width: 30, height: 30,
                color:isJawali?null: isSelected ? Theme.of(context).cardColor : Theme.of(context).disabledColor,
              ),
              const SizedBox(width: Dimensions.paddingSizeSmall),

              Expanded(
                child: Text(
                  title,
                  style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: isSelected ? Colors.white : Colors.black),
                ),
              ),
            ]),

          ),
        ),
      );
    });
  }
}
