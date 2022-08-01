import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:notas_app/nota_model.dart';

class NotasCotroller extends NotifierStore<Exception, List<NotaModel>> {
  NotasCotroller(super.initialState);
  List<NotaModel> minhasNotas = [];

  final corSelecionada = RxNotifier<Color>(Colors.blueGrey);
  void mudarCorSelecionada(Color novaCor) => corSelecionada.value = novaCor;

  void listarNotas() {
    execute(() async => minhasNotas);
  }

  void adicionarNota(NotaModel value) {
    minhasNotas.add(value);
    listarNotas();
    Modular.to.pop();
  }
}


/*
-uma cor na barra do appbar(onde ta escrito notas)
- os cards um botao de exlcuir a nota onde esta a data, e a data colcado no final 
do card
- qnd clicar no botao de excluir abrir uma modal perguntado se quer mesmo excluir aqele 
nota
-fazer a nota ser retirada da lista e sumir da visualizacao
*/