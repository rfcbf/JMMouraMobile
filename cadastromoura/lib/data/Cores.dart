import 'package:flutter/material.dart';

mixin Cores {

  static const MaterialColor azul = const MaterialColor(
    0xFF0040FB,
    const <int, Color>{
      50: const Color(0xFF0040FB),
      100: const Color(0xFF0040FB),
      200: const Color(0xFF0040FB),
      300: const Color(0xFF0040FB),
      400: const Color(0xFF0040FB),
      500: const Color(0xFF0040FB),
      600: const Color(0xFF0040FB),
      700: const Color(0xFF0040FB),
      800: const Color(0xFF0040FB),
      900: const Color(0xFF0040FB),
    },
  );


  static const fundoTela = Color(0xFFDFDDE7);
  static const amarelo = Color(0xFFffeaa4);
  static const pesego = Color(0xFFffcda4);
  static const branco = Colors.white;
  static const preto = Colors.black;
  static const vermelho = Colors.red;
  static const textoBotao = Colors.black87;
  static const hintInputText = Colors.white70;
  static const texto = Colors.black;
  static const erroPessego = pesego;
  static const erroScaffold = vermelho;
  static const sucessoScaffold = Color(0xFF7D67E6);
  static const cinza = Colors.grey;
  static const textoInput = Color(0xFF616161);

}