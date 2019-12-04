import 'package:cadastromoura/components/alert_widget.dart';
import 'package:cadastromoura/screens/dashBoard.dart';
import 'package:cadastromoura/services/connectionStatus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:splashscreen/splashscreen.dart';

import 'data/Cores.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  StatusConexao _conexao = StatusConexao.getInstance();
  _conexao.initialize();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  StatusConexao _conexao = StatusConexao.getInstance();
  BuildContext _scaffoldContext;

  @override
  void initState() {
    super.initState();
    _conexao.connectionChange.listen(connectionChanged);

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  void dispose() {
    _conexao.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  void connectionChanged(dynamic hasConnection) {
    if (hasConnection) {
      _conexao.count = 0;
      _conexao.hasConnection = true;
    } else {
      _conexao.count = 0;
      _conexao.hasConnection = false;
    }

    if (_conexao.primeiraVez) {
      _conexao.primeiraVez = false;
      _conexao.count++;
    } else {
      if (_conexao.count == 0) {
        setState(() {});
        if (_conexao.hasConnection) {
          _conexao.count++;

          AlertaComConexao(context: _scaffoldContext).exibir();
        } else {
          _conexao.count++;
          AlertaSemConexao(context: _scaffoldContext).exibir();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Montserrat',
        primarySwatch: Cores.azul,
        hintColor: Colors.grey,
        errorColor: Colors.red,
      ),
      home: splashScreen(context),
    );
  }

  splashScreen(BuildContext context) {
    // bool ispad = isIpad();

    return SplashScreen(
      seconds: 5,
      navigateAfterSeconds: Builder(builder: (BuildContext context) {
        _scaffoldContext = context;
        return Dashboard();
      }),
      title: new Text(
        'Cadastro - JM Moura',
        style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0, color: Cores.branco),
      ),
      image: Image(
        image: AssetImage('assets/images/logo.png'),
        // color: Cores.branco,
      ),
      gradientBackground: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          // Colors are easy thanks to Flutter's Colors class.
          Cores.azul,
          Cores.azul,
        ],
      ),
      styleTextUnderTheLoader: new TextStyle(),
      photoSize: 100.0,
      loaderColor: Cores.branco,
      loadingText: Text(
        'Carregando...',
        style: TextStyle(color: Cores.branco),
      ),
    );
  }
}
