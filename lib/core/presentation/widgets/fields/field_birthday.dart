import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:sistema_ies/core/domain/utils/datetime.dart';
import 'package:sistema_ies/core/presentation/widgets/fields/field_names.dart';

import '../../../domain/utils/value_objects.dart';

Widget fieldBirthday(controller, text, context) {
  return DateTimeFormField(
    decoration: InputDecoration(
      labelStyle: Theme.of(context).textTheme.labelMedium,
      labelText: fieldNames[text],
      suffixIcon: Icon(
        FontAwesomeIcons.calendarDay,
        color: Theme.of(context).colorScheme.secondary,
      ),
      filled: true,
      fillColor: Theme.of(context).colorScheme.tertiary,
      border: UnderlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.tertiary,
        ),
      ),
      errorBorder: UnderlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.error,
        ),
      ),
    ),
    dateFormat: DateFormat("yyyy/MM/dd"),
    mode: DateTimeFieldPickerMode.date,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    validator: (DateTime? value) {
      if (value != null) {
        if (Validator.validateBirthdate(value).isRight) {
          return null;
        } else {
          return Validator.validateBirthdate(value).left;
        }
      } else {
        return 'La fecha de nacimiento no puede estar vacía';
      }
    },
    //TODO "Brian: Cambien onDateSelected: por onChanged, porque me lo pedia la actualizacion de la biblioteca "
    //    // onDateSelected: (DateTime value) {
    //   controller.text = dateToString(value);
    // },

    onChanged: (DateTime? value) {
      controller.text = value != null ? dateToString(value) : '';
    },
  );
}
