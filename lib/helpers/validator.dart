import 'package:email_validator/email_validator.dart';
import 'package:nb_utils/src/extensions/string_extensions.dart';

class Validator {
  String? error;
  bool isDone = false;
  final String attributeName;
  final String? value;

  Validator({
    required this.attributeName,
    required this.value,
  });

  String? getError() {
    return error;
  }

  // Stop on first error occurence
  void _setDone(String error) {
    isDone = true;
    this.error = error;
  }

  // Validations
  void required() {
    if (!isDone) {
      if (value == null || value!.isEmpty) {
        _setDone('$attributeName cannot be empty');
      }
    }
  }

  void email() {
    if (!isDone && value != null && value!.isNotEmpty) {
      if (!EmailValidator.validate(value.toString())) {
        _setDone('$attributeName is not a valid email');
      }
    }
  }

  void email22() {
    if (!isDone && value != null && value!.isNotEmpty) {
      if (!EmailValidator.validate(value.toString())) {
        _setDone('$attributeName is not a valid email');
      }
    }
  }

  void matchTo(String firstAttribute) {
    if (!isDone && !value.isEmptyOrNull) {
      if (value != firstAttribute) {
        _setDone("$attributeName doesn't match to  $firstAttribute");
      }
    }
  }

  void minLength(int length) {
    if (!isDone && value != null && value!.isNotEmpty) {
      if (value!.length < length) {
        _setDone('$attributeName cannot be less than $length characters');
      }
    }
  }

  void maxLength(int length) {
    if (!isDone && value != null && value!.isNotEmpty) {
      if (value!.length > length) {
        _setDone('$attributeName cannot be more than $length characters');
      }
    }
  }
}
