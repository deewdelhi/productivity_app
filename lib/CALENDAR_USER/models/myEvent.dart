import 'dart:ui';

import 'package:flutter/material.dart';

class MyEvent {
  final String userId;
  final String id;
  final String description;
  final String title;

  /// Minutes duration of task or object
  final int minutesDuration;

  /// When this task will be happen
  final DateTime dateTime;

  /// Background color of task
  final Color color;
  MyEvent({
    required this.id,
    required this.userId,
    required this.description,
    required this.title,
    required this.minutesDuration,
    required this.dateTime,
    required this.color,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'durationMinutes': minutesDuration.toString(),
      'color': color.toString(),
      'descripiton': description,
      'title': title,
      'datetime': dateTime.toString()
    };
  }

  factory MyEvent.fromMap(Map<String, dynamic> map) {
    return MyEvent(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      description: map['descripiton'] ?? '',
      title: map['title'] ?? '',
      minutesDuration: int.parse(map['durationMinutes']),
      dateTime: map['messageId'] ?? '', // TODO: fix this
      color: map['color'] ?? '',
    );
  }
}
