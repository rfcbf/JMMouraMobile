class Funcoes {
  bool validaEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return true;
    else
      return false;
  }

  DateTime retornaStringData(String value) {
    int dia = int.parse(value.substring(0, 2));
    int mes = int.parse(value.substring(3, 5));
    int ano = int.parse(value.substring(6, 10));
    return DateTime.utc(ano, mes, dia);
  }

}
