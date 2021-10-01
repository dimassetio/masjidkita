import 'package:email_validator/email_validator.dart';
import 'package:mosq/modules/kas/kategori/models/kategori_model.dart';
import 'package:nb_utils/src/extensions/string_extensions.dart';

class Validator {
  String? error;
  bool isDone = false;
  final String attributeName;
  String? value;
  var model;

  Validator({required this.attributeName, this.value, this.model});

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
      if (value.isEmptyOrNull) {
        _setDone('$attributeName cannot be empty');
      }
    }
  }

  void requireModel() {
    if (!isDone) {
      if (model == null) {
        _setDone('$attributeName cannot be empty');
      }
    }
  }

  void email() {
    if (!isDone && !value.isEmptyOrNull) {
      if (!EmailValidator.validate(value.toString())) {
        _setDone('$attributeName is not a valid email');
      }
    }
  }

  void email22() {
    if (!isDone && !value.isEmptyOrNull) {
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
    if (!isDone && !value.isEmptyOrNull) {
      if (value!.length < length) {
        _setDone('$attributeName cannot be less than $length characters');
      }
    }
  }

  void maxLength(int length) {
    if (!isDone && !value.isEmptyOrNull) {
      if (value!.length > length) {
        _setDone('$attributeName cannot be more than $length characters');
      }
    }
  }
}
