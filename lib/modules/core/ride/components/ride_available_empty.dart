import 'package:boilerplate_flutter/config/theme.dart';
import 'package:flutter/material.dart';

class RideAvailableListEmpty extends StatelessWidget {
  const RideAvailableListEmpty() : super();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 64),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Image.asset(
                'assets/images/blueCar.png',
                width: 150,
                height: 150,
              ),
            ),
            SizedBox(height: 40),
            Text(
              'Não há carona disponivel ',
              style: TextStyle(
                color: RideColors.primaryColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 6,
            ),
            Container(
              width: 238,
              child: Text(
                'Espere até um motorista disponibilizar uma viagem ',
                style: TextStyle(
                  color: RideColors.primaryColor,
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 100,
            ),
          ],
        ),
      ),
    );
  }
}
