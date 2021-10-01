import 'package:boilerplate_flutter/config/theme.dart';
import 'package:flutter/material.dart';

class HistoryListEmpty extends StatelessWidget {
  const HistoryListEmpty() : super();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 64),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Icon(
                Icons.assignment,
                size: 150,
              ),
            ),
            SizedBox(height: 40),
            Text(
              'Histórico de viagens está vazio ',
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
                'Ao alocar uma viagem ela irá aparecer no historico ',
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
