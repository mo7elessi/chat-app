import 'package:form_field_validator/form_field_validator.dart';

final nameValidator = MultiValidator([
  RequiredValidator(errorText: 'username is required'),
  MinLengthValidator(2, errorText: 'username must be at least 2 digits'),
  MaxLengthValidator(24, errorText: 'username must be at more 24 digits'),
]);

final none = MultiValidator([]);
