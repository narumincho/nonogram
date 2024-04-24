import 'package:flutter/material.dart';

@immutable
sealed class Result<OkValue, ErrorValue> {
  const Result();
}

class Ok<OkValue, ErrorValue> extends Result<OkValue, ErrorValue> {
  const Ok({required this.value});

  final OkValue value;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Ok<OkValue, ErrorValue> && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;
}

class Error<OkValue, ErrorValue> extends Result<OkValue, ErrorValue> {
  const Error({required this.value});

  final ErrorValue value;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Error<OkValue, ErrorValue> && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;
}
