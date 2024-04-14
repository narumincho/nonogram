import 'dart:math';

extension type HintNumber._(int value) {
  factory HintNumber.fromInt(int value) {
    return HintNumber._(max(0, value));
  }
}
