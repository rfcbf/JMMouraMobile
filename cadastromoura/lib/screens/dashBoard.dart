import 'package:cadastromoura/components/containerSemInternet_widget.dart';
import 'package:cadastromoura/data/Cores.dart';
import 'package:cadastromoura/model/cadastro.dart';
import 'package:cadastromoura/screens/manterCadastro.dart';
import 'package:cadastromoura/services/cadastroService.dart';
import 'package:cadastromoura/services/connectionStatus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Dashboard extends StatefulWidget {
  Dashboard();

  @override
  _Dashboard createState() => _Dashboard();
}

class _Dashboard extends State<Dashboard> {
  int currentIndex;
  StatusConexao _conexao = StatusConexao.getInstance();
  List<Cadastro> cadastros = [];

  Future<List<Cadastro>> _getData() async {
    await CadastroService.getCadsatro().then((response) {
      cadastros = response;
    });

    return cadastros;
  }

  @override
  void initState() {
    super.initState();
    // currentIndex = 0;
    _getData();
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
    );
  }

  Widget _floatButton() {
    return FloatingActionButton(
      onPressed: () {
        print("novo");
        Navigator.push(context, MaterialPageRoute(builder: (context) => ManterCadastro(null, true)));
      },
      backgroundColor: Cores.azul,
      elevation: 8,
      child: Icon(
        Icons.add,
        color: Cores.branco,
      ),
    );
  }

  Widget textoTitulo() => Text("Cadastro - JM Moura",
      style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold, fontStyle: FontStyle.normal));

  Widget bodyContainer(BuildContext context) {
    return Container(
//      color: Colors.amber[100],
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
                  ? buildList() //buildList(snapshot.data)
                  : Center(child: CircularProgressIndicator());
            },
          ),
        ),
      )
    ]));
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
              return Dismissible(
                key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
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
                child: _card(cadastros[index]),
                onDismissed: (direction) {
                  print(cadastros[index].id.toString());
                  // _excluirTodo(todos[index].id.toString());
                  cadastros.removeAt(index);
                },
              );
            }));
  }

  Widget _card(Cadastro cadastro) {
    return Card(
      elevation: 5,
      child: InkWell(
        onTap: () {
          print('visualizar');
          Navigator.push(context, MaterialPageRoute(builder: (context) => ManterCadastro(cadastro, false)));
        },
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            height: 60,
            width: double.infinity,
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
                    Text(cadastro.celular),
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
                    Text(cadastro.dataNasc),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
