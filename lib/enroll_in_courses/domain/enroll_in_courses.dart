import 'package:sistema_ies/core/domain/entities/student.dart';
import 'package:sistema_ies/core/domain/entities/users.dart';
import 'package:sistema_ies/core/domain/ies_system.dart';
import 'package:sistema_ies/core/domain/utils/operation_utils.dart';

enum EnrollInCoursesStateName {
  init,
  failure,

  success
}

class SubjectEnroll {
  int id;
  String name;
  bool studentCanEnroll;
  bool studentIsEnrolled;
  SubjectEnroll(
      {required this.id,
      required this.name,
      required this.studentCanEnroll,
      required this.studentIsEnrolled});
}

abstract class EnrollInCoursesState extends OperationState {
  const EnrollInCoursesState({required super.stateName});
}

class EnrollInCoursesInitState extends EnrollInCoursesState {
  final List<SubjectEnroll> subjectEnrolments;
  const EnrollInCoursesInitState({
    required this.subjectEnrolments,
  }) : super(stateName: EnrollInCoursesStateName.init);
}

class EnrollInCoursesFailureState extends EnrollInCoursesState {
  const EnrollInCoursesFailureState()
      : super(stateName: EnrollInCoursesStateName.failure);
}

class EnrollInCoursesSuccessState extends EnrollInCoursesState {
  const EnrollInCoursesSuccessState()
      : super(stateName: EnrollInCoursesStateName.success);
}

class EnrollInCoursesUseCase extends Operation {
  final IESUser iesUser;
  final Student student;

  EnrollInCoursesUseCase(EnrollInCoursesState enrollInCoursesState,
      {required this.iesUser, required this.student})
      : super(EnrollInCoursesInitState(subjectEnrolments: []));

  calculateEnrolments() async {
    (await IESSystem().getStudentRepository().getStudentRecord(
            userID: iesUser.id,
            syllabusID: student.syllabus.administrativeResolution))
        .fold((left) {
      changeState(OperationState(stateName: EnrollInCoursesStateName.failure));
    }, (studentRecords) {
      List<SubjectEnroll> studentEnrolments = [];

      for (StudentRecordSubject studentRecord in studentRecords) {
        studentEnrolments.add(SubjectEnroll(
            id: studentRecord.subjectId,
            name: studentRecord.name,
            studentCanEnroll: studentRecord.subjectState == SubjectState.nule,
            studentIsEnrolled: false));
      }

      changeState(
          EnrollInCoursesInitState(subjectEnrolments: studentEnrolments));
    });
  }
}
