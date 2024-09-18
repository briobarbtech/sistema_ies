import 'package:sistema_ies/core/domain/utils/prints.dart';

import '../../domain/entities/student.dart';

List<MovementStudentRecord> sortMovements(studentRecordsDocs) {
  List<MovementStudentRecord> movements = [];
  for (var movement in studentRecordsDocs) {
    print(movement['name']);
    switch (movement['name']) {
      case "finalExamApprovedByCertification":
        movements.add(MSRFinalExamApprovedByCertification.fromMap(movement));
        break;
      case "courseRegistering":
        // Course registering
        movements.add(MSRCourseRegistering.fromMap(movement));
        break;
      case "courseFailedNonFree":
        // courseFailedNonFree
        movements.add(MSRCourseFailedNonFree.fromMap(movement));
        break;
      case "courseFailedFree":
        // courseFailedFree
        movements.add(MSRCourseFailedFree.fromMap(movement));
        break;
      case "courseApproved":
        // courseApproved
        movements.add(MSRCourseApproved.fromMap(movement));
        break;
      case "courseApprovedWithAccreditation":
        // courseApprovedWithAccreditation
        movements.add(MSRCourseApprovedWithAccreditation.fromMap(movement));
        break;
      case "finalExamApproved":
        // finalExamApproved
        movements.add(MSRFinalExamApproved.fromMap(movement));
        break;
      case "finalExamNonApproved":
        // finalExamNonApproved
        movements.add(MSRFinalExamNonApproved.fromMap(movement));
        break;
      default:
        // unknow
        prints("unknow");
    }
  }
  print(movements);
  return movements;
}
