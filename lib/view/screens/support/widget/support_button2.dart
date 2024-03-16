import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:talabiapp/util/dimensions.dart';
import 'package:talabiapp/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SupportButtons extends StatelessWidget {
  final IconData FontAwesomeIcons;
  final String? title;
  final String? info;
  final Color color;
  final Function onTap;
  const SupportButtons({Key? key, required this.FontAwesomeIcons, this.title, this.info, required this.color, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap as void Function()?,
      child: Container(
        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
        // decoration: BoxDecoration(
        //   borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
        //   color: Theme.of(context).cardColor,
        //   boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 800 : 200]!, spreadRadius: 1, blurRadius: 5)],
        // ),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [

          Container(
            height: 40, width: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withOpacity(0.2),
            ),
            child: Center(
              child: FaIcon(
                FontAwesomeIcons,
                 color: color, size: 20
              ),
            ),
          ),
          const SizedBox(width: Dimensions.paddingSizeSmall),

          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
           if(title!=null)
            Text(title!, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: color)),
            const SizedBox(height: Dimensions.paddingSizeExtraSmall),
          if(info!=null) 
            Text(info!, style: robotoRegular, maxLines: 1, overflow: TextOverflow.ellipsis),
          ]),

        ]),
      ),
    );
  }
}
