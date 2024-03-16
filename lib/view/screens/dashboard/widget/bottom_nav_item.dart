import 'package:flutter/material.dart';

class BottomNavItem extends StatelessWidget {
  final IconData iconData;
  final Function? onTap;
  final bool isSelected;
  final String name;
  const BottomNavItem({Key? key, required this.name,required this.iconData, this.onTap, this.isSelected = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        child: Column(
          children: [
            InkWell(
              onTap: ()=>onTap,
              child: Column(
                children: [
                  Icon(iconData, color: isSelected ? Theme.of(context).primaryColor : Colors.grey, size: 25)
                  ,Text(name,style: TextStyle(color: Theme.of(context).primaryColor),),


                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
