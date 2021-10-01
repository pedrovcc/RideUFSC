import 'package:boilerplate_flutter/config/theme.dart';
import 'package:flutter/material.dart';

class CreateRideListEmpty extends StatelessWidget {
  const CreateRideListEmpty({required this.onPressCreateRide}) : super();

  final Function() onPressCreateRide;

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
              'Criar uma viagem',
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
                'Crie uma viajem para dar carona aos alunos da UFSC',
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
            Container(
              decoration: new BoxDecoration(
                  color: RideColors.primaryColor,
                  borderRadius: BorderRadius.all(Radius.circular(4))),
              child: TextButton(
                child: Icon(
                  Icons.add,
                  size: 40,
                  color: RideColors.white,
                ),
                onPressed: () {
                  onPressCreateRide();
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
