import 'package:cadastromoura/data/Cores.dart';
import 'package:flutter/material.dart';

class SemCliente extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: double.infinity,
        color: Cores.fundoTela,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                width: 150,
                height: 150,
                decoration: new BoxDecoration(
                    shape: BoxShape.circle,
                    color: Cores.azul,
                    image: DecorationImage(fit: BoxFit.contain, image: AssetImage('assets/images/logo.png')))),
            SizedBox(
              height: 30,
            ),
            Text(
              'Sem cliente cadastrado',
              style: TextStyle(color: Cores.azul, fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ],
        ));
  }
}
