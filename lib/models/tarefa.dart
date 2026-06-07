import 'package:flutter/material.dart';

class Task {
  final String id;
  final String title;
  final DateTime date;
  final TimeOfDay time;
  bool isCompleted;
  DateTime? completedAt;

  Task({
    required this.id,
    required this.title,
    required this.date,
    required this.time,
    this.isCompleted = false,
    this.completedAt,
  });

  Task copyWith({
    String? id,
    String? title,
    DateTime? date,
    TimeOfDay? time,
    bool? isCompleted,
    DateTime? completedAt,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      date: date ?? this.date,
      time: time ?? this.time,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}
