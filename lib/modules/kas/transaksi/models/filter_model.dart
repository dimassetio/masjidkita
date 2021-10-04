import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:mosq/integrations/firestore.dart';

extension on Query {
  Query filtering(FilterModel model) {
    switch (model.operator) {
      case Operator.arrayContains:
        return where(model.field, arrayContains: model.value);
      case Operator.arrayContainsAny:
        return where(model.field, arrayContainsAny: model.value);
      case Operator.isEqualTo:
        return where(model.field, isEqualTo: model.value);
      case Operator.isGreaterThan:
        return where(model.field, isGreaterThan: model.value);
      case Operator.isGreaterThanOrEqualTo:
        return where(model.field, isGreaterThanOrEqualTo: model.value);
      case Operator.isLessThan:
        return where(model.field, isLessThan: model.value);
      case Operator.isLessThanOrEqualTo:
        return where(model.field, isLessThanOrEqualTo: model.value);
      case Operator.isNotEqualTo:
        return where(model.field, isNotEqualTo: model.value);
      case Operator.whereIn:
        return where(model.field, whereIn: model.value);
      case Operator.whereNotIn:
        return where(model.field, whereNotIn: model.value);
      case Operator.isNull:
        return where(model.field, isNull: model.value);
    }
  }
}

class FilterModel {
  String field;
  var value;
  Operator operator;

  FilterModel({
    required this.field,
    required this.value,
    required this.operator,
  });
}

enum Operator {
  isEqualTo,
  arrayContains,
  arrayContainsAny,
  isGreaterThan,
  isGreaterThanOrEqualTo,
  isLessThan,
  isLessThanOrEqualTo,
  whereIn,
  whereNotIn,
  isNotEqualTo,
  isNull,
}
