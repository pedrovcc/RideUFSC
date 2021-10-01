import 'package:boilerplate_flutter/config/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NavigationBar extends StatefulWidget {
  const NavigationBar({
    required int currentIndex,
    required Function(int) onTap,
  })  : _currentIndex = currentIndex,
        _onTap = onTap,
        super();

  final int _currentIndex;
  final Function(int) _onTap;
  @override
  _NavigationBarState createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavigationBar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      showSelectedLabels: false,
      backgroundColor: Colors.white,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
      currentIndex: widget._currentIndex,
      onTap: widget._onTap,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/icons/ic_home.svg',
            color: RideColors.white[64],
          ),
          activeIcon: SvgPicture.asset(
            'assets/icons/ic_home.svg',
            color: RideColors.primaryColor,
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/icons/ic_order.svg',
            color: RideColors.white[64],
          ),
          activeIcon: SvgPicture.asset(
            'assets/icons/ic_order.svg',
            color: Theme.of(context).primaryColor,
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/icons/ic_account.svg',
            color: RideColors.white[64],
          ),
          activeIcon: SvgPicture.asset(
            'assets/icons/ic_account.svg',
            color: Theme.of(context).primaryColor,
          ),
          label: '',
        ),
      ],
    );
  }
}
