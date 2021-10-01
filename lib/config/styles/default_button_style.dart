import 'package:boilerplate_flutter/config/theme.dart';
import 'package:flutter/material.dart';

double getElevation(Set<MaterialState> states) => 0.0;

Color getColor(Set<MaterialState> states) {
  const Set<MaterialState> interactiveStates = <MaterialState>{
    MaterialState.pressed,
    MaterialState.hovered,
    MaterialState.focused,
  };
  const Set<MaterialState> disabledStates = <MaterialState>{
    MaterialState.disabled,
    MaterialState.error
  };
  if (states.any(interactiveStates.contains)) {
    return Colors.greenAccent;
  } else if (states.any(disabledStates.contains)) {
    return Colors.grey;
  }
  return RideColors.primaryColor;
}

OutlinedBorder getBorder(Set<MaterialState> states) => RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(4),
      ),
    );

ButtonStyle getDefaultButtonStyle() => ButtonStyle(
      backgroundColor: MaterialStateProperty.resolveWith(getColor),
      elevation: MaterialStateProperty.resolveWith(getElevation),
      shape: MaterialStateProperty.resolveWith(getBorder),
    );
