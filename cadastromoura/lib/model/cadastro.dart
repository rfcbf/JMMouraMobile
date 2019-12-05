class Cadastro {
  int id;
  String nome;
  String endereco;
  String bairro;
  String cidade;
  String estado;
  String cep;
  String celular;
  String dataNasc;

  Cadastro(
      {int id,
      String nome,
      String endereco,
      String bairro,
      String cidade,
      String estado,
      String cep,
      String celular,
      String dataNasc}) {
    this.id = id;
    this.nome = nome;
    this.endereco = endereco;
    this.bairro = bairro;
    this.cidade = cidade;
    this.estado = estado;
    this.cep = cep;
    this.celular = celular;
    this.dataNasc = dataNasc;
  }

  Cadastro.fromJson(Map json)
      : id = json['id'],
        nome = json['nome'],
        endereco = json['endereco'],
        bairro = json['bairro'],
        cidade = json['cidade'],
        estado = json['estado'],
        cep = json['cep'],
        celular = json['celular'],
        dataNasc = json['datanasc'];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'endereco': endereco,
      'bairro': bairro,
      'cidade': cidade,
      'estado': estado,
      'cep': cep,
      'celular': celular,
      'datanasc': dataNasc,
    };
  }
}
