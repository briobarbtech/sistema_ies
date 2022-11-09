import 'package:sistema_ies/core/domain/entities/syllabus.dart';
import 'package:sistema_ies/core/domain/entities/user_role_operation.dart';

enum UserRoleTypeName {
  guest,
  incomingStudent,
  student,
  teacher,
  administrative,
  manager,
  systemAdmin
}

class UserRoleType {
  // final IESUser user;
  UserRoleTypeName name;
  String title;
  List<ParameretizedUserRoleOperation> parameterizedOperations;

  UserRoleType(
      {required this.name,
      required this.title,
      required this.parameterizedOperations});
}

abstract class UserRole {
  UserRoleTypeName userRoleTypeName();
}

class Guest extends UserRole {
  @override
  UserRoleTypeName userRoleTypeName() {
    return UserRoleTypeName.guest;
  }
}

class IncomingStudent extends UserRole {
  IncomingStudent();

  @override
  UserRoleTypeName userRoleTypeName() {
    return UserRoleTypeName.incomingStudent;
  }
}

class Student extends UserRole {
  List<Syllabus> syllabuses;

  Student({required this.syllabuses});

  @override
  UserRoleTypeName userRoleTypeName() {
    return UserRoleTypeName.student;
  }
}

class Teacher extends UserRole {
  List<Subject> subjects;

  Teacher({required this.subjects});

  @override
  UserRoleTypeName userRoleTypeName() {
    return UserRoleTypeName.teacher;
  }
}

class Administrative extends UserRole {
  List<Syllabus> syllabuses;

  Administrative({required this.syllabuses});

  @override
  UserRoleTypeName userRoleTypeName() {
    return UserRoleTypeName.administrative;
  }
}

class Manager extends UserRole {
  @override
  UserRoleTypeName userRoleTypeName() {
    return UserRoleTypeName.manager;
  }
}

class SystemAdmin extends UserRole {
  @override
  UserRoleTypeName userRoleTypeName() {
    return UserRoleTypeName.systemAdmin;
  }
}