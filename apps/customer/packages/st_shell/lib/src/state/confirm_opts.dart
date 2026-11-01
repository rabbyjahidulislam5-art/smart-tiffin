import 'package:flutter/foundation.dart';

class ConfirmOpts {
  const ConfirmOpts({
    required this.title,
    required this.ok,
    required this.onOk,
    this.body,
    this.danger = false,
  });
  final String title;
  final String? body;
  final String ok;
  final bool danger;
  final VoidCallback onOk;
}
