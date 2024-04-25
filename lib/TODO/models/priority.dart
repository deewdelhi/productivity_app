import 'package:flutter/material.dart';

class Priority {
  const Priority(this.title, this.color);
  final String title;
  final Color color;
}

enum Priorities {
  high,
  medium,
  low,
}

const HighPriority = const Priority('HIGH', Colors.red);
const MediumPriority = const Priority('MEDIUM', Colors.blue);
const LowPriority = const Priority('LOW', Colors.green);

const Map<Priorities, Priority> priorityMap = {
  Priorities.high: HighPriority,
  Priorities.medium: MediumPriority,
  Priorities.low: LowPriority,
};
