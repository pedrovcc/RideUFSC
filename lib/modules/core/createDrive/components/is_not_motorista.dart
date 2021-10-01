import 'package:boilerplate_flutter/config/theme.dart';
import 'package:flutter/material.dart';

class IsNotMotorista extends StatelessWidget {
  const IsNotMotorista() : super();

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
                'assets/images/redCar.png',
                width: 150,
                height: 150,
              ),
            ),
            SizedBox(height: 40),
            Text(
              'Você Não é um motorista!',
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
                'Para entrar nessa sessão será necessario primeiro se tornar um motorista, ao editar o perfil você consegue ser um motorista.',
                style: TextStyle(
                  color: RideColors.primaryColor,
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
