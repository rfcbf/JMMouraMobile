import 'package:cadastromoura/data/Cores.dart';
import 'package:flutter/material.dart';
import 'package:flushbar/flushbar.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class Alerta {
  final String titulo;
  final String msg;
  final Color corFundo;
  final Color corIcone;
  final BuildContext context;

  Alerta({this.context, this.titulo, this.msg, this.corFundo, this.corIcone});

  void exibir() {
    Flushbar(
      title: titulo,
      flushbarStyle: FlushbarStyle.GROUNDED,
      backgroundColor: corFundo,
      isDismissible: false,
      icon: Icon(
        Icons.info_outline,
        size: 28.0,
        color: corIcone,
      ),
      message: msg,
      duration: Duration(seconds: 3),
    )..show(context);
  }
}

class AlertLimparTela {
  final BuildContext context;
  final Function onPressed;
  final String title;
  final String msg;

  AlertLimparTela({@required this.context, this.title = "JM Moura", @required this.msg, @required this.onPressed});

  var alertStyle = AlertStyle(
    animationType: AnimationType.fromTop,
    isCloseButton: false,
    isOverlayTapDismiss: false,
    descStyle: TextStyle(fontSize: 15),
    animationDuration: Duration(milliseconds: 300),
    alertBorder: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
      side: BorderSide(
        color: Cores.branco,
      ),
    ),
    titleStyle: TextStyle(
      fontSize: 18,
    ),
  );

  void exibir() {
    Alert(
      context: context,
      style: alertStyle,
      type: AlertType.warning,
      title: this.title,
      desc: this.msg,
      buttons: [
        DialogButton(
          child: Text(
            "SIM",
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
          onPressed: this.onPressed,
          color: Cores.azul,
          radius: BorderRadius.circular(10.0),
        ),
        DialogButton(
          child: Text(
            "NÃO",
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
          onPressed: () => Navigator.pop(context),
          color: Cores.vermelho,
          radius: BorderRadius.circular(10.0),
        )
      ],
    ).show();
  }
}

class AlertGeralOK {
  final BuildContext context;
  final String title;
  final String msg;

  AlertGeralOK({@required this.context, this.title = "JM Moura", @required this.msg});

  var alertStyle = AlertStyle(
    animationType: AnimationType.fromTop,
    isCloseButton: false,
    isOverlayTapDismiss: false,
    descStyle: TextStyle(fontSize: 15),
    animationDuration: Duration(milliseconds: 300),
    alertBorder: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
      side: BorderSide(
        color: Cores.branco,
      ),
    ),
    titleStyle: TextStyle(
      fontSize: 18,
    ),
  );

  void exibir() {
    Alert(
      context: context,
      style: alertStyle,
      type: AlertType.warning,
      title: this.title,
      desc: this.msg,
      buttons: [
        DialogButton(
          child: Text(
            "OK",
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
          onPressed: () => Navigator.pop(context),
          color: Cores.vermelho,
          radius: BorderRadius.circular(10.0),
        )
      ],
    ).show();
  }
}

class AlertaRodape {
  final BuildContext context;
  final String titulo;
  final Color backgroundColor;
  final IconData icone;
  final String msg;

  AlertaRodape({this.context, this.titulo, this.backgroundColor, this.icone, this.msg});

  void exibir() {
    Flushbar(
      title: this.titulo,
      flushbarStyle: FlushbarStyle.GROUNDED,
      backgroundColor: this.backgroundColor,
      isDismissible: false,
      icon: Icon(
        this.icone,
        size: 28.0,
        color: Cores.branco,
      ),
      message: this.msg,
      duration: Duration(seconds: 4),
    )..show(context);
  }
}

class AlertaComConexao {
  final BuildContext context;

  AlertaComConexao({this.context});

  void exibir() {
    Flushbar(
      title: 'Conexão restabelecida',
      flushbarStyle: FlushbarStyle.GROUNDED,
      backgroundColor: Cores.azul,
      isDismissible: false,
      icon: Icon(
        Icons.wifi,
        size: 28.0,
        color: Cores.branco,
      ),
      message: 'Conexão com a internet restabelecida',
      duration: Duration(seconds: 4),
    )..show(context);
  }
}

class AlertaSemConexao {
  final BuildContext context;

  AlertaSemConexao({this.context});

  void exibir() {
    Flushbar(
      title: 'Conexão perdida',
      flushbarStyle: FlushbarStyle.GROUNDED,
      backgroundColor: Cores.vermelho,
      isDismissible: false,
      icon: Icon(
        Icons.wifi,
        size: 28.0,
        color: Cores.branco,
      ),
      message: 'No momento estamos sem conexão com internet.',
      duration: Duration(seconds: 4),
    )..show(context);
  }
}
