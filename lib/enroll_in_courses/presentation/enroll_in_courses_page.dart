import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sistema_ies/core/presentation/widgets/cells_layout.dart';

class EnrollInCoursesPage extends ConsumerWidget {
  const EnrollInCoursesPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ref.listen<OperationState>(IESSystem().loginUseCase.stateNotifierProvider,
    //     (previous, next) {

    // });

    return Scaffold(
        appBar: AppBar(title: Text("Inscripción a cursar materias")),
        body: Container(
          color: Colors.white,
          child: CellsLayout(columnRules: [
            SLSpacer(flex: 1),
            SLSpacer(flex: 1),
          ], rowRules: [
            SLFixed(size: 50),
            SLSpacer(flex: 1),
            SLFixed(size: 100)
          ], cells: [
            Cell(
                posX: 0,
                posY: 0,
                xSize: 2,
                child: Center(
                  child: Text('A que te puedes inscribir:',
                      style: Theme.of(context).textTheme.displayMedium),
                )),
            Cell(
                posX: 0,
                posY: 1,
                xSize: 2,
                child: Center(
                  child: Text('Listado de materias',
                      style: Theme.of(context).textTheme.displayMedium),
                )),
            Cell(
                posX: 0,
                posY: 2,
                child: Center(
                    child: ElevatedButton(
                        onPressed: () => {}, child: Text("Cancelar")))),
            Cell(
                posX: 1,
                posY: 2,
                child: Center(
                    child:
                        ElevatedButton(onPressed: () => {}, child: Text("Ok"))))
          ]),
        ));
  }
}
