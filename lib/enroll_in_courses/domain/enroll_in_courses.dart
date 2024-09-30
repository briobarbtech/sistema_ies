import 'package:sistema_ies/core/domain/utils/operation_utils.dart';

enum EnrollInCoursesStateName {
  init,
  failure,

  success
}

class EnrollInCoursesState extends OperationState {
  const EnrollInCoursesState({required super.stateName});
}

class EnrollInCoursesUseCase extends Operation<EnrollInCoursesState> {
  EnrollInCoursesUseCase(OperationState initialState)
      : super(const EnrollInCoursesState(
            stateName: EnrollInCoursesStateName.init));
}
