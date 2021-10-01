import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MenuItem extends StatelessWidget {
  MenuItem({
    required this.menuItemDescriptor,
    required this.onPressed,
    key,
  }) : super(key: key);

  final MenuItemDescriptor menuItemDescriptor;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      height: 64,
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              child: SvgPicture.asset(
                'assets/icons/${menuItemDescriptor.iconFileName}.svg',
                color: menuItemDescriptor.iconColor,
              ),
            ),
            SizedBox(
              width: 26,
            ),
            Text(
              '${menuItemDescriptor.title}',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MenuItemDescriptor extends Equatable {
  MenuItemDescriptor(
      {required this.title,
      required this.iconColor,
      required this.iconFileName,
      required this.actionId})
      : super();
  final String title;
  final String iconFileName;
  final Color iconColor;
  final String actionId;

  @override
  List<Object> get props => [title, iconFileName, iconColor, actionId];
}
