import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class EnrollInCoursesPage extends ConsumerWidget {
  const EnrollInCoursesPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ref.listen<OperationState>(IESSystem().loginUseCase.stateNotifierProvider,
    //     (previous, next) {

    // });

    return Scaffold(
        body: Container(
      color: Colors.amber,
      child: const Center(
        child: Text('Enroll in courses  / Inscripción a cursar materias'),
      ),
    ));
  }
}
