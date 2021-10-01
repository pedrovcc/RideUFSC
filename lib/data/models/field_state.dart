import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class FieldState<T> extends Equatable {
  const FieldState({
    required this.controller,
    required this.error,
  });

  final TextEditingController controller;
  final String? error;

  @override
  List<Object?> get props => [controller.text, error];
}
