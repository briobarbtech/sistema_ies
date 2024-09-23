import 'package:flutter/material.dart';
import 'package:sistema_ies/admin_student_record/presentation/widgets/form_text_field.dart';
import 'package:sistema_ies/core/domain/entities/student.dart';
// ignore: unused_import
import 'package:sistema_ies/core/domain/ies_system.dart';

class CourseApprovedByAcreditation extends StatelessWidget {
  const CourseApprovedByAcreditation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final certificationInstitute = TextEditingController();
    final bookNumber = TextEditingController();
    final pageNumber = TextEditingController();
    final certificationResolution = TextEditingController();
    final numericalGrade = TextEditingController();

    return Form(
      key: formKey,
      child: Column(
        children: <Widget>[
          // Certification institute
          FormTextField(
            name: "Certification institute",
            controller: certificationInstitute,
          ),
          // Book number
          FormTextField(
            name: "Book number",
            controller: bookNumber,
          ),
          // Page number
          FormTextField(
            name: "Page number",
            controller: pageNumber,
          ),
          // Certification resolution
          FormTextField(
            name: "Certification resolution",
            controller: certificationResolution,
          ),
          // Numerical grade
          FormTextField(
            name: "Numerical grade",
            controller: numericalGrade,
          ),

          ElevatedButton(
              onPressed: () {
                // Validate returns true if the form is valid, or false otherwise.
                if (formKey.currentState!.validate()) {
                  // If the form is valid, display a snackbar. In the real world,
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Processing Data')),
                  );
                  final newMovement = MSRCourseApprovedWithAccreditation(date: DateTime.now(),numericalGrade: int.parse(numericalGrade.text));
                  // and send the form
                  // TODO: 
                  print(IESSystem().adminStudentRecordsUseCase.submitNewStudentMovement(newMovement));
                }
              },
              child: const Text("Load"))
          // Add TextFormFields and ElevatedButton here.
        ],
      ),
    );
  }
}

