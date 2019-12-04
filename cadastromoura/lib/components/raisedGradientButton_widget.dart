import 'package:cadastromoura/data/Cores.dart';
import 'package:flutter/material.dart';

class RaisedGradientButton extends StatelessWidget {
  final Widget texto;
  final Gradient gradient;
  final double width;
  final double height;
  final double elevation;
  final double radius;
  final Widget icone;
  final AssetImage assetImage;
  final bool disabled;
  final Function onPressed;

  const RaisedGradientButton(
      {Key key,
      @required this.texto,
      this.gradient,
      this.width = double.infinity,
      this.height = 50.0,
      this.elevation = 0,
      this.radius = 0,
      this.icone,
      this.assetImage,
      this.onPressed,
      this.disabled = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Image image;

    if (assetImage != null) {
      image = new Image(
        image: assetImage,
        height: height - 10,
        width: width - 10,
        fit: BoxFit.fill,
      );
    }

    return InkWell(
      child: Material(
        elevation: elevation,
        borderRadius: BorderRadius.all(Radius.circular(radius)),
        child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              gradient: !disabled
                  ? gradient
                  : LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [
                      Cores.cinza,
                      Cores.cinza,
                    ]),
              borderRadius: BorderRadius.all(Radius.circular(radius)),
            ),
            child: icone != null
                ? Stack(
                    children: <Widget>[
                      Center(child: texto),
                      Positioned(
                        top: 0,
                        left: 0,
                        width: 40,
                        height: height,
                        child: icone,
                      ),
                    ],
                  )
                : image != null
                    ? Stack(
                        children: <Widget>[
                          Center(child: texto),
                          Positioned(
                            top: height / 3.5,
                            left: 7,
                            width: 25,
                            height: 25,
                            child: image,
                          ),
                        ],
                      )
                    : Center(child: texto)),
      ),
      onTap: !disabled ? onPressed : null,
    );
  }
}
