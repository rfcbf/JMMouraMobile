import 'package:cadastromoura/components/alert_widget.dart';
import 'package:cadastromoura/components/containerSemInternet_widget.dart';
import 'package:cadastromoura/components/raisedGradientButton_widget.dart';
import 'package:cadastromoura/data/Cores.dart';
// import 'package:cadastromoura/data/UF.dart';
import 'package:cadastromoura/model/cadastro.dart';
import 'package:cadastromoura/services/cadastroService.dart';
import 'package:cadastromoura/services/cepService.dart';
import 'package:cadastromoura/services/connectionStatus.dart';
import 'package:cadastromoura/services/funcoes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

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
  bool _operacao = false;

  TextEditingController _cidadeController = TextEditingController();
  TextEditingController _enderecoController = TextEditingController();
  TextEditingController _bairroController = TextEditingController();
  TextEditingController _estadoController = TextEditingController();

  var maskTelefone = MaskTextInputFormatter(mask: '(##) #####-####', filter: {"#": RegExp(r'[0-9]')});
  var maskData = MaskTextInputFormatter(mask: '##/##/####', filter: {"#": RegExp(r'[0-9]')});
  var masCep = MaskTextInputFormatter(mask: '#####-###', filter: {"#": RegExp(r'[0-9]')});

  @override
  void initState() {
    Intl.defaultLocale = 'pt_BR';
    initializeDateFormatting(Intl.defaultLocale);

    super.initState();

    if (!widget.novo) {
      _cidadeController.text = widget.cadastro.cidade;
      _enderecoController.text = widget.cadastro.endereco;
      _bairroController.text = widget.cadastro.bairro;
      _estadoController.text = widget.cadastro.estado;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Cores.fundoTela,
        child: SafeArea(
          bottom: false,
          top: false,
          child: GestureDetector(
            onTap: () {
              // call this method here to hide soft keyboard
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            child: Scaffold(
                key: _scaffoldKey,
                appBar: AppBar(
                  title: Text('Cadastro de Cliente'),
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
                        setState(() {
                          _validacao = true;
                        });

                        if (_fbKey.currentState.saveAndValidate()) {
                          _executandoOperacao(true);

                          String formattedDate = _fbKey.currentState.value['data'] != null
                              ? DateFormat('dd/MM/yyyy').format(_fbKey.currentState.value['data'])
                              : "";

                          if (widget.novo) {
                            Cadastro cadastro = Cadastro(
                                nome: _fbKey.currentState.value['nome'],
                                bairro: _fbKey.currentState.value['bairro'],
                                celular: _fbKey.currentState.value['telefone'],
                                cep: _fbKey.currentState.value['cep'],
                                cidade: _fbKey.currentState.value['cidade'],
                                dataNasc: formattedDate,
                                endereco: _fbKey.currentState.value['endereco'],
                                estado: _fbKey.currentState.value['estados']);

                            await CadastroService.post(cadastro).then((valor) {
                              print('gravado com sucesso');
                            }).catchError((onError) {
                              print('erro ao gravar');
                            });
                          } else {
                            Cadastro cadastro = Cadastro(
                                id: widget.cadastro.id,
                                nome: _fbKey.currentState.value['nome'],
                                bairro: _fbKey.currentState.value['bairro'],
                                celular: _fbKey.currentState.value['telefone'],
                                cep: _fbKey.currentState.value['cep'],
                                cidade: _fbKey.currentState.value['cidade'],
                                dataNasc: formattedDate,
                                endereco: _fbKey.currentState.value['endereco'],
                                estado: _fbKey.currentState.value['estados']);

                            await CadastroService.update(cadastro).then((valor) {
                              print('gravado com sucesso');
                            }).catchError((onError) {
                              print('erro ao gravar');
                            });
                          }
                          _executandoOperacao(false);

                          Navigator.pop(context);
                        } else {
                          print(_fbKey.currentState.value);
                          erro();
                        }
                      },
                    ),
                  ],
                ),
                body: _conexao.hasConnection
                    ? ModalProgressHUD(child: _tela(context), inAsyncCall: _operacao)
                    : SemInternet()),
          ),
        ));
  }

  void _executandoOperacao(bool enable) {
    setState(() {
      _operacao = enable;
    });
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
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: FormBuilderDateTimePicker(
                            attribute: "data",
                            inputType: InputType.date,
                            initialDate: DateTime.now(),
                            // lastDate: DateTime(DateTime.now().day + 1),
                            initialValue: widget.novo ? null : Funcoes().retornaStringData(widget.cadastro.dataNasc),
                            format: DateFormat("dd/MM/yyyy"),
                            decoration: InputDecoration(
                              hintText: "##/##/####",
                              hintStyle: TextStyle(color: Colors.grey),
                              counterStyle: TextStyle(color: Cores.fundoTela),
                              labelText: "Data de Nascimento",
                              labelStyle: TextStyle(color: Cores.azul),
                              errorStyle: TextStyle(color: Cores.vermelho),
                              errorBorder:
                                  UnderlineInputBorder(borderSide: const BorderSide(color: Cores.vermelho, width: 1.0)),
                              focusedErrorBorder:
                                  UnderlineInputBorder(borderSide: const BorderSide(color: Cores.vermelho, width: 1.0)),
                            ),
                          ),
                        ),
                        Expanded(
                            child: FormBuilderTextField(
                          style: TextStyle(color: Cores.preto),
                          attribute: "telefone",
                          initialValue: widget.novo ? '' : widget.cadastro.celular,
                          textCapitalization: TextCapitalization.characters,
                          keyboardType: TextInputType.number,
                          readOnly: false,
                          inputFormatters: [maskTelefone],
                          textAlign: TextAlign.end,
                          decoration: InputDecoration(
                            hintText: "(##) #####-####",
                            hintStyle: TextStyle(color: Colors.grey),
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
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: FormBuilderTextField(
                            style: TextStyle(color: Cores.preto),
                            attribute: "cep",
                            initialValue: widget.novo ? '' : widget.cadastro.cep,
                            keyboardType: TextInputType.number,
                            readOnly: false,
                            inputFormatters: [masCep],
                            textAlign: TextAlign.end,
                            textCapitalization: TextCapitalization.sentences,
                            decoration: InputDecoration(
                              counterStyle: TextStyle(color: Cores.fundoTela),
                              hintText: "#####-###",
                              labelText: "CEP",
                              hintStyle: TextStyle(color: Colors.grey),
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
                        SizedBox(
                          width: 70,
                        ),
                        Expanded(
                          child: Center(
                            child: RaisedGradientButton(
                                texto: Text('      Consultar CEP',
                                    style: TextStyle(color: Cores.branco, fontSize: 15, fontWeight: FontWeight.bold)),
                                gradient:
                                    LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [
                                  Cores.azul,
                                  Cores.azul,
                                ]),
                                elevation: 3,
                                radius: 10,
                                height: 40,
                                icone: Icon(
                                  Icons.home,
                                  color: Cores.branco,
                                  size: 20,
                                ),
                                onPressed: () async {
                                  _executandoOperacao(true);
                                  final cep = masCep.getUnmaskedText();

                                  await CepService.fetchCep(cep: cep).then((resultadoCep) {
                                    print(resultadoCep.localidade);

                                    if (resultadoCep.cep == null) {
                                      cepNaoEncontrado();
                                    } else {
                                      setState(() {
                                        _cidadeController.text = resultadoCep.localidade;
                                        _estadoController.text = resultadoCep.uf;
                                        _bairroController.text = resultadoCep.bairro;
                                        _enderecoController.text =
                                            resultadoCep.logradouro + ' ' + resultadoCep.complemento;
                                        // _fbKey.currentState.value['cidade'] = _cidade;
                                      });
                                    }
                                  }).catchError((onError) {
                                    print('erro ao pesquisar o cep');
                                    erroCEP();
                                  });

                                  _executandoOperacao(false);
                                }),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: FormBuilderTextField(
                      style: TextStyle(color: Cores.preto),
                      attribute: "endereco",
                      initialValue: widget.novo ? '' : widget.cadastro.endereco,
                      controller: _enderecoController,
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
                    child: FormBuilderTextField(
                      style: TextStyle(color: Cores.preto),
                      attribute: "bairro",
                      controller: _bairroController,
                      initialValue: widget.novo ? '' : widget.cadastro.bairro,
                      textCapitalization: TextCapitalization.sentences,
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
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: FormBuilderTextField(
                      style: TextStyle(color: Cores.preto),
                      controller: _cidadeController,
                      attribute: "cidade",
                      initialValue: widget.novo ? '' : widget.cadastro.cidade,
                      keyboardType: TextInputType.text,
                      readOnly: false,
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
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: FormBuilderTextField(
                      style: TextStyle(color: Cores.preto),
                      controller: _estadoController,
                      attribute: "estados",
                      initialValue: widget.novo ? '' : widget.cadastro.estado,
                      keyboardType: TextInputType.text,
                      readOnly: false,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        counterStyle: TextStyle(color: Cores.fundoTela),
                        labelText: "Estado",
                        labelStyle: TextStyle(color: Cores.azul),
                        errorStyle: TextStyle(color: Cores.vermelho),
                        errorBorder:
                            UnderlineInputBorder(borderSide: const BorderSide(color: Cores.vermelho, width: 1.0)),
                        focusedErrorBorder:
                            UnderlineInputBorder(borderSide: const BorderSide(color: Cores.vermelho, width: 1.0)),
                      ),
                      validators: [
                        FormBuilderValidators.required(
                          errorText: "Favor preencher o campo Estado",
                        ),
                        FormBuilderValidators.minLength(2, errorText: 'No mínimo 2 letras'),
                        FormBuilderValidators.maxLength(2, errorText: 'No máximo 2 letras')
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
                              msg: "Confirma a exclusão?",
                              title: "JM Moura",
                              onPressed: () {
                                CadastroService.delete(widget.cadastro.id.toString());
                                Navigator.pop(context);
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

  void erroCEP() {
    AlertaRodape(
      context: context,
      titulo: 'CEP:',
      msg: 'Erro ao pesquisar o cep.',
      backgroundColor: Cores.erroScaffold,
      icone: Icons.block,
    ).exibir();
  }

  void cepNaoEncontrado() {
    AlertaRodape(
      context: context,
      titulo: 'CEP:',
      msg: 'CEP não encontrado.',
      backgroundColor: Cores.erroScaffold,
      icone: Icons.block,
    ).exibir();
  }
}
