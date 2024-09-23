import 'package:either_dart/either.dart';
import 'package:sistema_ies/core/domain/entities/student.dart';
import 'package:sistema_ies/core/domain/entities/user_roles.dart';
import 'package:sistema_ies/core/domain/entities/users.dart';
import 'package:sistema_ies/core/domain/ies_system.dart';
import 'package:sistema_ies/core/domain/utils/operation_utils.dart';
import 'package:sistema_ies/core/domain/utils/responses.dart';

enum AdminStudentRecordStateName {
  init,
  success,
  loading,
  failure,
  studentRecordExtended
}

class AdminStudentRecordState extends OperationState {
  final Administrative currentRole;
  const AdminStudentRecordState(
      {required Enum stateName, required this.currentRole})
      : super(stateName: stateName);
  AdminStudentRecordState copyChangingRole(
      {required Administrative newUserRole}) {
    return AdminStudentRecordState(
        stateName: stateName, currentRole: newUserRole);
  }

  AdminStudentRecordState copyChangingState(
      {required AdminStudentRecordStateName newState}) {
    return AdminStudentRecordState(
        stateName: newState, currentRole: currentRole);
  }
}

class AdminStudentRecordUseCase extends Operation<AdminStudentRecordState> {
  final IESUser iesUser;
  final Administrative administrative;

  AdminStudentRecordUseCase(
      {required this.iesUser, required this.administrative})
      : super(AdminStudentRecordState(
            stateName: AdminStudentRecordStateName.init,
            currentRole: administrative));
  Future<Either<Failure, Success>> submitNewStudentMovement (MovementStudentRecord movementStudentRecord) async {
    return await IESSystem().getStudentRepository().addStudentRecordMovement(newMovement: movementStudentRecord, idUser: IESSystem().homeUseCase.currentIESUser.id, syllabusId: "501-DGE-19", subjectId: 20).fold((left) {
      print(left);
      return Left(left);}, (right) {
        print(right.message);
        return Right(right);});
            }
            
}
