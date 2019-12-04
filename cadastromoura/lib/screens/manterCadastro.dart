import 'package:cadastromoura/components/alert_widget.dart';
import 'package:cadastromoura/components/containerSemInternet_widget.dart';
import 'package:cadastromoura/components/raisedGradientButton_widget.dart';
import 'package:cadastromoura/data/Cores.dart';
import 'package:cadastromoura/data/UF.dart';
import 'package:cadastromoura/model/cadastro.dart';
import 'package:cadastromoura/services/connectionStatus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class ManterCadastro extends StatefulWidget {
  final Cadastro cadastro;
  final bool novo;

  ManterCadastro(this.cadastro, this.novo);

  @override
  _ManterCadastroState createState() => _ManterCadastroState();
}

class _ManterCadastroState extends State<ManterCadastro> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  StatusConexao _conexao = StatusConexao.getInstance();
  bool _validacao = false;

  @override
  void initState() {
    Intl.defaultLocale = 'pt_BR';
    initializeDateFormatting(Intl.defaultLocale);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _conexao.hasConnection
        ? Container(
            color: Cores.fundoTela,
            child: SafeArea(
              bottom: false,
              top: false,
              child: Scaffold(
                  key: _scaffoldKey,
                  appBar: AppBar(
                    title: Text('Cadastro'),
                    backgroundColor: Cores.azul,
                    elevation: 2,
                    actions: <Widget>[
                      IconButton(
                        padding: EdgeInsets.only(right: 20),
                        color: Cores.branco,
                        icon: Icon(Icons.save),
                        focusColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        onPressed: () async {
                          if (_fbKey.currentState.saveAndValidate()) {
                            setState(() {
                              _validacao = true;
                            });

                            print(_fbKey.currentState.value);

                            // DocumentSnapshot docHorario =
                            //     await Horarios.recuperaHorario(documentID: _fbKey.currentState.value['horario']);
                            // String formatacao = docHorario.data['horaInicial'] + ' às ' + docHorario.data['horaFinal'];

                            // Agenda.incluirAgandamento(
                            //     data: _fbKey.currentState.value['dataAgendamento'],
                            //     horario: _fbKey.currentState.value['horario'],
                            //     obs: _fbKey.currentState.value['obsmarcacao'],
                            //     usuario: widget.user.firebaseUser.uid,
                            //     nomeCliente: widget.user.userData['nome'],
                            //     horaInicial: docHorario.data['horaInicial'],
                            //     horaFinal: docHorario.data['horaFinal'],
                            //     descHorario: formatacao,
                            //     onSucess: sucesso,
                            //     onFail: erro);

                            // Map<String, dynamic> dados = {
                            //   "qtdAgenda": widget.user.userData['qtdAgenda'] + 1,
                            // };

                            // widget.user.atualizarQuantitativo(
                            //   userData: dados,
                            //   documentID: widget.user.firebaseUser.uid,
                            // );

                            Navigator.pop(context);
                          } else {
                            print(_fbKey.currentState.value);
                            erro();
                          }
                          // print(_fbKey.currentState.value['contact_person'].runtimeType);
                        },
                      ),
                    ],
                  ),
                  body: _tela(context)),
            ),
          )
        : SemInternet();
  }

  Widget _tela(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            FormBuilder(
              // context,
              key: _fbKey,
              autovalidate: _validacao,
              readOnly: false,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: FormBuilderTextField(
                      style: TextStyle(color: Cores.preto),
                      attribute: "nome",
                      initialValue: widget.novo ? '' : widget.cadastro.nome,
                      showCursor: false,
                      readOnly: false,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        labelText: "Nome",
                        labelStyle: TextStyle(color: Cores.azul),
                        errorStyle: TextStyle(color: Cores.vermelho),
                        errorBorder:
                            UnderlineInputBorder(borderSide: const BorderSide(color: Cores.vermelho, width: 1.0)),
                        focusedErrorBorder:
                            UnderlineInputBorder(borderSide: const BorderSide(color: Cores.vermelho, width: 1.0)),
                      ),
                      validators: [
                        FormBuilderValidators.required(
                          errorText: "Favor preencher o campo Nome",
                        ),
                        FormBuilderValidators.minLength(5, errorText: 'No mínimo 5 letras')
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: FormBuilderTextField(
                      style: TextStyle(color: Cores.preto),
                      attribute: "endereco",
                      initialValue: widget.novo ? '' : widget.cadastro.endereco,
                      showCursor: false,
                      readOnly: false,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        labelText: "Endereço",
                        labelStyle: TextStyle(color: Cores.azul),
                        errorStyle: TextStyle(color: Cores.vermelho),
                        errorBorder:
                            UnderlineInputBorder(borderSide: const BorderSide(color: Cores.vermelho, width: 1.0)),
                        focusedErrorBorder:
                            UnderlineInputBorder(borderSide: const BorderSide(color: Cores.vermelho, width: 1.0)),
                      ),
                      validators: [
                        FormBuilderValidators.required(
                          errorText: "Favor preencher o campo Endereço",
                        ),
                        FormBuilderValidators.minLength(5, errorText: 'No mínimo 5 letras')
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: FormBuilderTextField(
                            style: TextStyle(color: Cores.preto),
                            attribute: "bairro",
                            initialValue: widget.novo ? '' : widget.cadastro.bairro,
                            showCursor: false,
                            textCapitalization: TextCapitalization.characters,
                            readOnly: false,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              counterStyle: TextStyle(color: Cores.fundoTela),
                              labelText: "Bairro",
                              labelStyle: TextStyle(color: Cores.azul),
                              errorStyle: TextStyle(color: Cores.vermelho),
                              errorBorder:
                                  UnderlineInputBorder(borderSide: const BorderSide(color: Cores.vermelho, width: 1.0)),
                              focusedErrorBorder:
                                  UnderlineInputBorder(borderSide: const BorderSide(color: Cores.vermelho, width: 1.0)),
                            ),
                            validators: [
                              FormBuilderValidators.required(
                                errorText: "Favor preencher o campo Bairro",
                              ),
                              FormBuilderValidators.minLength(3, errorText: 'No mínimo 3 letras')
                            ],
                          ),
                        ),
                        Expanded(
                          child: FormBuilderTextField(
                            style: TextStyle(color: Cores.preto),
                            attribute: "cidade",
                            initialValue: widget.novo ? '' : widget.cadastro.cidade,
                            keyboardType: TextInputType.text,
                            readOnly: false,
                            showCursor: false,
                            textCapitalization: TextCapitalization.sentences,
                            decoration: InputDecoration(
                              counterStyle: TextStyle(color: Cores.fundoTela),
                              labelText: "Cidade",
                              labelStyle: TextStyle(color: Cores.azul),
                              errorStyle: TextStyle(color: Cores.vermelho),
                              errorBorder:
                                  UnderlineInputBorder(borderSide: const BorderSide(color: Cores.vermelho, width: 1.0)),
                              focusedErrorBorder:
                                  UnderlineInputBorder(borderSide: const BorderSide(color: Cores.vermelho, width: 1.0)),
                            ),
                            validators: [
                              FormBuilderValidators.required(
                                errorText: "Favor preencher o campo Cidade",
                              ),
                              FormBuilderValidators.minLength(3, errorText: 'No mínimo 3 letras')
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Expanded(
                          child: FormBuilderDropdown(
                            attribute: "estados",
                            initialValue: widget.novo ? '' : widget.cadastro.estado,

                            decoration: InputDecoration(
                              labelText: "Estados",
                              labelStyle: TextStyle(color: Cores.azul),
                              errorStyle: TextStyle(color: Cores.vermelho),
                              errorBorder:
                                  UnderlineInputBorder(borderSide: const BorderSide(color: Cores.vermelho, width: 1.0)),
                              focusedErrorBorder:
                                  UnderlineInputBorder(borderSide: const BorderSide(color: Cores.vermelho, width: 1.0)),
                            ),
                            // initialValue: '',
                            // hint: Text('Seleci'),
                            validators: [
                              FormBuilderValidators.required(
                                errorText: "Favor selecionar o horário",
                              )
                            ],
                            items: estados
                                .map((f) => DropdownMenuItem(
                                      value: f,
                                      child: Text('$f'),
                                    ))
                                .toList(),
                          ),
                        ),
                        Expanded(
                          child: FormBuilderTextField(
                            style: TextStyle(color: Cores.preto),
                            attribute: "cep",
                            initialValue: widget.novo ? '' : widget.cadastro.cep,
                            keyboardType: TextInputType.text,
                            readOnly: false,
                            showCursor: false,
                            textCapitalization: TextCapitalization.sentences,
                            decoration: InputDecoration(
                              counterStyle: TextStyle(color: Cores.fundoTela),
                              labelText: "CEP",
                              labelStyle: TextStyle(color: Cores.azul),
                              errorStyle: TextStyle(color: Cores.vermelho),
                              errorBorder:
                                  UnderlineInputBorder(borderSide: const BorderSide(color: Cores.vermelho, width: 1.0)),
                              focusedErrorBorder:
                                  UnderlineInputBorder(borderSide: const BorderSide(color: Cores.vermelho, width: 1.0)),
                            ),
                            validators: [
                              FormBuilderValidators.required(
                                errorText: "Favor preencher o campo estado",
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            child: FormBuilderTextField(
                          style: TextStyle(color: Cores.preto),
                          attribute: "data",
                          initialValue: widget.novo ? '' : widget.cadastro.dataNasc,
                          showCursor: false,
                          textCapitalization: TextCapitalization.characters,
                          readOnly: false,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            counterStyle: TextStyle(color: Cores.fundoTela),
                            labelText: "Data de Nascimento",
                            labelStyle: TextStyle(color: Cores.azul),
                            errorStyle: TextStyle(color: Cores.vermelho),
                            errorBorder:
                                UnderlineInputBorder(borderSide: const BorderSide(color: Cores.vermelho, width: 1.0)),
                            focusedErrorBorder:
                                UnderlineInputBorder(borderSide: const BorderSide(color: Cores.vermelho, width: 1.0)),
                          ),
                        )),
                        Expanded(
                            child: FormBuilderTextField(
                          style: TextStyle(color: Cores.preto),
                          attribute: "telefone",
                          initialValue: widget.novo ? '' : widget.cadastro.celular,
                          showCursor: false,
                          textCapitalization: TextCapitalization.characters,
                          keyboardType: TextInputType.phone,
                          readOnly: false,
                          decoration: InputDecoration(
                            counterStyle: TextStyle(color: Cores.fundoTela),
                            labelText: "Telefone",
                            labelStyle: TextStyle(color: Cores.azul),
                            errorStyle: TextStyle(color: Cores.vermelho),
                            errorBorder:
                                UnderlineInputBorder(borderSide: const BorderSide(color: Cores.vermelho, width: 1.0)),
                            focusedErrorBorder:
                                UnderlineInputBorder(borderSide: const BorderSide(color: Cores.vermelho, width: 1.0)),
                          ),
                        )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            !widget.novo
                ? Container(
                    margin: EdgeInsets.fromLTRB(25, 5, 25, 5),
                    child: RaisedGradientButton(
                        texto: Text('Excluir Cadastro',
                            style: TextStyle(color: Cores.branco, fontSize: 15, fontWeight: FontWeight.bold)),
                        gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [
                          Cores.vermelho,
                          Cores.vermelho,
                        ]),
                        elevation: 3,
                        radius: 10,
                        height: 60,
                        icone: Icon(
                          Icons.delete,
                          color: Cores.branco,
                          size: 20,
                        ),
                        onPressed: () {
                          AlertLimparTela(
                              context: context,
                              msg: "Deseja excluir o cadastro?",
                              title: "JM Moura",
                              onPressed: () {
                                Navigator.pop(context);
                              }).exibir();
                        }),
                  )
                : Container()
          ],
        ),
      ),
    );
  }

  void erro() {
    AlertaRodape(
      context: context,
      titulo: 'Manutenção:',
      msg: 'Erro ao efetuar a operação.',
      backgroundColor: Cores.erroScaffold,
      icone: Icons.block,
    ).exibir();
  }
}
