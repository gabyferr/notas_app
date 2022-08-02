import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:intl/intl.dart';
import 'package:notas_app/nota_model.dart';
import 'package:notas_app/notas_controller.dart';

class NotasPage extends StatefulWidget {
  const NotasPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<NotasPage> createState() => _NotasPageState();
}

class _NotasPageState extends State<NotasPage> {
  final notasCtrl = Modular.get<NotasCotroller>();

  @override
  void initState() {
    notasCtrl.listarNotas();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(notasCtrl.hashCode);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.blue,
      ),
      body: ListView(
        children: <Widget>[
          Center(
            child: ScopedBuilder(
              store: notasCtrl,
              onState: (context, List<NotaModel> notas) {
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                  ),
                  shrinkWrap: true,
                  itemCount: notas.length,
                  itemBuilder: (context, index) {
                    return Card(
                      color: notas[index].corFundo,
                      child: ListTile(
                          title: Text(notas[index].titulo),
                          subtitle: Text(notas[index].conteudo),
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            color: Colors.red,
                            onPressed: () => abrirModalExclusao(notas[index]),
                          )),
                    );
                  },
                );
              },
              onLoading: (context) => CircularProgressIndicator(),
              onError: (context, error) => Text('deu riumm'),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => abrirModalNota(),
        tooltip: 'Increment',
        child: const Icon(Icons.note_add),
      ),
    );
  }

  void abrirModalNota() {
    TextEditingController valTitulo = TextEditingController();
    TextEditingController valConteudo = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Insira uma Nota!'),
          content: Container(
            height: 140,
            child: Wrap(
              runSpacing: 12,
              children: [
                TextField(
                  decoration: InputDecoration(
                    labelText: 'titulo',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                    ),
                  ),
                  controller: valTitulo,
                ),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'conteudo',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                    ),
                  ),
                  controller: valConteudo,
                ),
              ],
            ),
          ),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actionsPadding: EdgeInsets.symmetric(horizontal: 12),
          actions: [
            RxBuilder(builder: (context) {
              return ElevatedButton(
                child: Icon(
                  Icons.color_lens,
                  color: notasCtrl.corSelecionada.value,
                ),
                onPressed: () async {
                  Color corRetornou = await abrirModalCor();
                  notasCtrl.mudarCorSelecionada(corRetornou);
                },
              );
            }),
            Wrap(
              spacing: 6,
              children: [
                ElevatedButton(
                  child: Icon(
                    Icons.cancel,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    Modular.to.pop();
                  },
                ),
                ElevatedButton(
                  child: Icon(Icons.save),
                  onPressed: () {
                    final f = new DateFormat('dd-MM-yyyy hh:mm');

                    notasCtrl.adicionarNota(
                      NotaModel(
                        titulo: valTitulo.text,
                        data: f.format(new DateTime.now()).toString(),
                        conteudo: valConteudo.text,
                        corFundo: notasCtrl.corSelecionada.value,
                        corText: Colors.blue,
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void abrirModalExclusao(NotaModel nota) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Deseja realmente excluir!'),
          actionsAlignment: MainAxisAlignment.end,
          actionsPadding: EdgeInsets.symmetric(horizontal: 12),
          actions: [
            ElevatedButton(
              child: Icon(
                Icons.cancel,
                color: Colors.red,
              ),
              onPressed: () {
                Modular.to.pop();
              },
            ),
            ElevatedButton(
              child: Icon(Icons.save),
              onPressed: () {
                notasCtrl.removerNota(nota);
              },
            ),
          ],
        );
      },
    );
  }

  Future<Color> abrirModalCor() async {
    Color corEscolhida = Colors.blueGrey;
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Selecione uma cor'),
          content: BlockPicker(
            pickerColor: Colors.blueGrey,
            onColorChanged: (Color cor) {
              corEscolhida = cor;
            },
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Modular.to.pop();
              },
              child: Icon(
                Icons.cancel,
                color: Colors.red,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Modular.to.pop();
              },
              child: Icon(Icons.save),
            ),
          ],
        );
      },
    );
    return corEscolhida;
  }
}
