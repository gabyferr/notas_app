import 'package:flutter_modular/flutter_modular.dart';
import 'package:notas_app/notas_controller.dart';
import 'package:notas_app/notas_page.dart';

class AppModule extends Module {
  @override
  List<Bind> get binds => [
        Bind.singleton((i) => NotasCotroller([])),
      ];

  @override
  List<ModularRoute> get routes => [
        ChildRoute('/', child: (context, args) => NotasPage(title: 'Notas')),
      ];
}
