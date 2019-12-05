import 'package:cadastromoura/components/alert_widget.dart';
import 'package:cadastromoura/components/circularImage_widget.dart';
import 'package:cadastromoura/components/containerSemInternet_widget.dart';
import 'package:cadastromoura/components/semCliente_widget.dart';
import 'package:cadastromoura/data/Cores.dart';
import 'package:cadastromoura/model/cadastro.dart';
import 'package:cadastromoura/screens/manterCadastro.dart';
import 'package:cadastromoura/services/cadastroService.dart';
import 'package:cadastromoura/services/connectionStatus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:circular_profile_avatar/circular_profile_avatar.dart';

class Dashboard extends StatefulWidget {
  Dashboard();

  @override
  _Dashboard createState() => _Dashboard();
}

class _Dashboard extends State<Dashboard> {
  int currentIndex;
  StatusConexao _conexao = StatusConexao.getInstance();
  List<Cadastro> cadastros = [];
  bool _dadosRecuperados = false;

  Future<List<Cadastro>> _getData() async {
    await CadastroService.getCadsatro().then((response) {
      cadastros = response;
    }).catchError((onError) {
      return null;
    });

    return cadastros;
  }

  @override
  void initState() {
    super.initState();
    _chamaRecuperaDados();
    // currentIndex = 0;
  }

  Future<void> _chamaRecuperaDados() async {
    await _getData().then((result) async {
      setState(() {
        _dadosRecuperados = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return _scaffold();
  }

  Widget _scaffold() {
    return Scaffold(
      backgroundColor: Cores.fundoTela,
      appBar: AppBar(
        backgroundColor: Cores.azul,
        elevation: 0,
        centerTitle: false,
        title: textoTitulo(),
        flexibleSpace: imagemLogin(),
      ),
      body: _conexao.hasConnection ? bodyContainer(context) : SemInternet(),
      floatingActionButton: _floatButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: Container(
        color: Cores.azul,
        height: 60,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Total de Clientes: ${cadastros.length}',
                style: TextStyle(color: Cores.branco, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _floatButton() {
    return FloatingActionButton(
      onPressed: () async {
        await Navigator.push(context, MaterialPageRoute(builder: (context) => ManterCadastro(null, true)));
        setState(() {
          _chamaRecuperaDados();
        });
      },
      backgroundColor: Cores.azul,
      elevation: 8,
      child: Icon(
        Icons.add,
        color: Cores.branco,
      ),
    );
  }

  Widget textoTitulo() => Text("Clientes - JM Moura",
      style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold, fontStyle: FontStyle.normal));

  Widget bodyContainer(BuildContext context) {
    return _dadosRecuperados
        ? Container(
            child: Column(children: <Widget>[
            Expanded(
              child: RefreshIndicator(
                displacement: 0.8,
                onRefresh: _getData,
                child: FutureBuilder(
                  future: _getData(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) print(snapshot.error);

                    return snapshot.hasData
                        ? cadastros.length > 0 ? buildList() : SemCliente()
                        : Center(child: CircularProgressIndicator());
                  },
                ),
              ),
            )
          ]))
        : Center(child: CircularProgressIndicator());
  }

  Widget imagemLogin() {
    return Positioned(
        bottom: 3,
        right: 15,
        child: Container(
            width: 50,
            height: 50,
            decoration: new BoxDecoration(
                shape: BoxShape.circle,
                color: Cores.azul,
                image: DecorationImage(fit: BoxFit.contain, image: AssetImage('assets/images/logo.png')))));
  }

  Widget buildList() {
    return Container(
        child: ListView.builder(
            padding: EdgeInsets.only(top: 10.0),
            itemCount: cadastros.length,
            itemBuilder: (context, index) {
              return _card(cadastros[index], index);
            }));
  }

  Widget _card(Cadastro cadastro, index) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
      child: Card(
          elevation: 5,
          child: Dismissible(
            key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
            onDismissed: (direction) async {
              AlertaExclusao(context: context).exibir();
              await CadastroService.delete(cadastro.id.toString());
              setState(() {
                cadastros.removeAt(index);
              });
            },
            background: Container(
                color: Colors.red,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                )),
            direction: DismissDirection.endToStart,
            child: InkWell(
              onTap: () async {
                await Navigator.push(context, MaterialPageRoute(builder: (context) => ManterCadastro(cadastro, false)));
                setState(() {
                  _chamaRecuperaDados();
                });
              },
              child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    height: 60,
                    width: double.infinity,
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width / 1.35,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                cadastro.nome,
                                style: TextStyle(color: Cores.azul, fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    'Celular:',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  cadastro.celular == null
                                      ? Text("Sem telefone", style: TextStyle(color: Cores.vermelho))
                                      : Text(cadastro.celular),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    'Data de Nascimento:',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  cadastro.dataNasc == null
                                      ? Text("Sem data nascimento", style: TextStyle(color: Cores.vermelho))
                                      : Text(cadastro.dataNasc),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: cadastro.celular == null
                              ? Container()
                              : InkWell(
                                  borderRadius: BorderRadius.circular(25),
                                  onTap: () async {
                                    var url = 'tel:${cadastro.celular}';
                                    if (await canLaunch(url)) {
                                      await launch(url);
                                    } else {
                                      throw 'Could not launch $url';
                                    }
                                  },
                                  child: Container(
                                    child: Center(child: CircularImage(50, 50)),
                                  ),
                                ),
                        )
                      ],
                    ),
                  )),
            ),
          )),
    );
  }
}
