import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:either_dart/either.dart';
import 'package:sistema_ies/core/data/init_repository_adapters.dart';
import 'package:sistema_ies/core/data/utils/sort_movements.dart';
import 'package:sistema_ies/core/domain/entities/student.dart';
import 'package:sistema_ies/core/domain/repositories/courses_repository_port.dart';
import 'package:sistema_ies/core/domain/repositories/student_repository.dart';
import 'package:sistema_ies/core/domain/utils/responses.dart';
import 'package:sistema_ies/core/domain/utils/prints.dart';


class StudentDatasource implements StudentRepositoryPort {
  @override
  Future<Either<Failure, Success>> initRepositoryCaches() async {
    return Right(Success('ok'));
  }

  /// This function adds a movement to the movements  of any student user.
  /// 
  /// Parameters:
  /// - [userID]: The student user ID to whom you want to add a movement..
  /// - [syllabusId]: It is necessary to define which syllabus will be modified..
  /// - [subjectId]: It is necessary to define which subject will be modified..
  /// 
  /// Returns:
  /// - This function could return either success or failure, depending on the case.
  /// 
  /// Exceptions:
  
  @override
  Future<Either<Failure, Success>> addStudentRecordMovement(
      {required MovementStudentRecord newMovement,
      required String userID,
      required String syllabusId,
      required int subjectId}) async {
    try {

      // TODO: "It is necessary to replace the function arguments with the received parameters.
      DocumentReference<Map<String, dynamic>> newItem = await firestoreInstance
          .collection("iesUsers")
          .doc("n6bgFjS9ntfdelOauViR")
          .collection('roles')
          .doc("FGqnYpXcgLqcUroYqMxD")
          .collection("subjects")
          .doc("0NTl6E4AJOeLVpLmv5IJ")
          .collection("movements")
          .add({"hola":"adios"});
          //.add(newMovement.toMap(newMovement));
          return Right(Success(newItem.id));
    } catch (e) {
      prints(e);
      return Left(Failure(failureName: FailureName.unknown));
    }
  }

  /// This function gets a student role ID using syllabus ID
  /// 
  /// Parameters:
  /// - [userID]: The user ID to whom you want to get the role ID..
  /// - [syllabusID]: It is necessary to get the correct student role..
  /// 
  /// Returns:
  /// - This function could return either string or error in console, depending on the case.
  /// 
  /// Exceptions:
  Future<String> getRoleBySyllabusId(
      {required String userID, required String syllabus}) async {
    return firestoreInstance
        .collection("iesUsers")
        .doc(userID)
        .collection('roles')
        .where("syllabus", isEqualTo: syllabus)
        .get()
        .then(
      (querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          return docSnapshot.id;
        }
        return "";
      },
      onError: (e) => {prints("Error completing: $e")},
    );
  }

  /// This function gets a subject's ID from the database using a field ID..
  /// 
  /// Using an identifier provided by the subject's fields, we can get the ID used in the database for that subject.
  /// 
  /// Parameters:
  /// - [userID]: The user ID to whom you want to get the subject ID..
  /// - [syllabusID]: It is necessary to get the correct student role..
  /// - [subjectID]: It is necessary to get the subject's ID from the DB..
  /// 
  /// Returns:
  /// - This function could return either string or error in console, depending on the case.
  /// 
  /// Exceptions:
  Future<String> getSubjectId(
      {required String userID,
      required String syllabusID,
      required int subjectID}) async {
    return firestoreInstance
        .collection("iesUsers")
        .doc(userID)
        .collection('roles')
        .doc(syllabusID)
        .collection("subjects")
        .where("id", isEqualTo: subjectID)
        .get()
        .then(
      (querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          return docSnapshot.id;
        }
        return "";
      },
      onError: (e) => {prints("Error completing: $e")},
    );
  }
  /// This function retrieves a list of student records from the database..
  /// 
  /// A student record is an entity designed to resemble a subject, containing a
  /// information related to the student's progress in that subject.
  /// 
  /// Parameters:
  /// - [userID]: The user ID to whom you want to get the subject..
  /// - [syllabusID]: It is necessary to get the correct student role..
  /// 
  /// Returns:
  /// - This function could return either Failure or List<StudentRecordSubject>, depending on the case.
  /// 
  /// Exceptions:
  @override
  Future<Either<Failure, List<StudentRecordSubject>>> getStudentRecord(
      {required String userID, required String syllabusID}) async {
    List<StudentRecordSubject> srSubjects = [];
    // GET syllabus ID
    Future<String> syllabusId =
        getRoleBySyllabusId(userID: userID, syllabus: syllabusID);
    // GET student records
    List<Map<String, dynamic>> studentRecordsDocs = ((await firestoreInstance
            .collection("iesUsers")
            .doc(userID)
            .collection('roles')
            .doc(await syllabusId)
            .collection("subjects")
            .get())
        .docs
        .map((e) => e.data())
        .toList());
    // srSubjects is equal to a list of StudentRecordSubject build with studentRecordsDocs
    srSubjects = studentRecordsDocs
        .map((e) => StudentRecordSubject(subjectId: e['id'], name: "name"))
        .toList();

    return Right(srSubjects);
  }

  @override
  Future<List<MovementStudentRecord>> getStudentRecordMovements(
      {required String userID,
      required String syllabusId,
      required int subjectId}) async {
    List<MovementStudentRecord> movements = [];
    List<Map<String, dynamic>> studentRecordsDocs = [];
    studentRecordsDocs = ((await firestoreInstance
            .collection("iesUsers")
            .doc(userID)
            .collection('roles')
            .doc(await getRoleBySyllabusId(userID: userID, syllabus: syllabusId))
            .collection("subjects")
            .doc(await getSubjectId(
                subjectID: subjectId,
                syllabusID:
                    await getRoleBySyllabusId(userID: userID, syllabus: syllabusId),
                userID: userID))
            .collection('movements')
            .get())
        .docs
        .map((e) => e.data())
        .toList());
    //print(studentRecordsDocs);
    movements = sortMovements(studentRecordsDocs);
    return movements;
  }

  @override
  Future<Either<Failure, List<StudentRecordSubject2>>> getSubjects(
      {required String userID, required String syllabusId}) async {
    List<StudentRecordSubject2> subjects = [];
    List<Map> subjectsDocs = [];
    prints("Started!");
    try {
      subjectsDocs = (await firestoreInstance
              .collection("iesUsers")
              .doc(userID)
              .collection('roles')
              .doc(await getRoleBySyllabusId(userID: userID, syllabus: syllabusId))
              .collection("subjects")
              .get())
          .docs
          .map((e) => e.data())
          .toList();
      for (var subject in subjectsDocs) {
        prints(subject);
        subjects.add(StudentRecordSubject2.fromJson(subject));
      }
    } catch (e) {
      prints(e);
    }
    prints("Done!");
    return Right(subjects);
  }
}
