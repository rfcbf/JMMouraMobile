import 'package:cadastromoura/data/Cores.dart';
import 'package:flutter/material.dart';

class SemInternet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: double.infinity,
        color: Cores.fundoTela,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.wifi,
              color: Cores.azul,
              size: 80,
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              'Sem conexão com a internet.',
              style: TextStyle(color: Cores.azul, fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ],
        ));
  }
}
