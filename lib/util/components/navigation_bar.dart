import 'package:boilerplate_flutter/config/theme.dart';
import 'package:flutter/material.dart';

class NavigationBar extends StatefulWidget {
  const NavigationBar(
      {required bool isDriver,
      required int currentIndex,
      required Function(int) onTap})
      : _isDriver = isDriver,
        _currentIndex = currentIndex,
        _onTap = onTap,
        super();

  final bool _isDriver;
  final int _currentIndex;
  final Function(int) _onTap;

  @override
  _NavigationBarState createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavigationBar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      showSelectedLabels: true,
      backgroundColor: Colors.white,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
      currentIndex: widget._currentIndex,
      onTap: widget._onTap,
      selectedItemColor: RideColors.primaryColor,
      unselectedItemColor: RideColors.white[64],
      selectedLabelStyle: TextStyle(color: RideColors.primaryColor),
      unselectedLabelStyle: TextStyle(color: RideColors.white[64]),
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(
            Icons.calendar_today,
          ),
          activeIcon: Icon(
            Icons.calendar_today,
          ),
          label: 'Viagens',
          backgroundColor: RideColors.white[64],
        ),
        // if (widget._isDriver)
        BottomNavigationBarItem(
            icon: Icon(
              Icons.directions_car,
            ),
            activeIcon: Icon(
              Icons.directions_car,
            ),
            label: 'Motorista',
          ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.assignment_outlined,
          ),
          activeIcon: Icon(
            Icons.assignment_outlined,
          ),
          label: 'Historico',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.account_circle,
          ),
          activeIcon: Icon(
            Icons.account_circle,
          ),
          label: 'Perfil',
        ),
      ],
    );
  }
}
