import 'package:flutter/cupertino.dart';

class NotaModel {
  String titulo;
  String conteudo;
  String data;
  Color corFundo;
  Color corText;

  NotaModel({
    required this.titulo,
    required this.data,
    required this.conteudo,
    required this.corFundo,
    required this.corText,
  });
}
