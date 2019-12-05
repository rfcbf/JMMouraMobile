import 'package:cadastromoura/data/Cores.dart';
import 'package:flutter/material.dart';
// import 'package:wedjaunhas/data/cores.dart';

class CircularImage extends StatefulWidget {
  final double _width;
  final double _height;

  CircularImage(this._width, this._height);

  @override
  _CircularImageState createState() => new _CircularImageState();
}

class _CircularImageState extends State<CircularImage> {
  bool eWeb = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      color: Cores.branco,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: widget._width,
        height: widget._height,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Cores.azul,
        ),
        child: Center(
            child: Icon(
          Icons.phone,
          color: Cores.branco,
        )),
      ),
    );
  }
}
