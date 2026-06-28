import 'package:flutter/material.dart';

class DateHeader extends StatelessWidget {
  final DateTime date;

  const DateHeader({
    super.key,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    final diff = DateTime.now().difference(date).inDays;

    final label = switch (diff) {
      0 => 'Today',
      1 => 'Yesterday',
      _ => '${date.day}/${date.month}/${date.year}',
    };

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFE1F3FB),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          color: Colors.black54,
        ),
      ),
    );
  }
}