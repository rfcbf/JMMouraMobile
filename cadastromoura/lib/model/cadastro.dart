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

  Cadastro(int id, String nome, String endereco, String bairro, String cidade, String estado, String cep,
      String celular, String dataNasc) {
    this.id = id;
    this.nome = nome;
    this.bairro = bairro;
    this.cidade = cidade;
    this.estado = estado;
    this.cep = cep;
    this.celular = celular;
    this.dataNasc = dataNasc;
  }

  Cadastro.fromJson(Map json)
      : id = json['id'],
        nome = json['Nome'],
        endereco = json['Endereco'],
        bairro = json['Bairro'],
        cidade = json['Cidade'],
        estado = json['Estado'],
        cep = json['Cep'],
        celular = json['Celular'],
        dataNasc = json['DataNasc'];

  Map toJson() {
    return {
      'id': id,
      'nome': nome,
      'endereco': endereco,
      'bairro': bairro,
      'cidade': cidade,
      'estado': estado,
      'cep': cep,
      'celular': celular,
      'dataNasc': dataNasc
    };
  }
}
