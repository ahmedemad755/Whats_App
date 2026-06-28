import 'package:flutter/material.dart';

class ChatAvatar extends StatelessWidget {
  final String url;
  final double radius;
  final bool isOnline;

  const ChatAvatar({
    super.key,
    required this.url,
    this.radius = 28,
    this.isOnline = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          radius: radius,
          backgroundImage: NetworkImage(url),
          backgroundColor: Colors.grey.shade200,
        ),
        if (isOnline)
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color: const Color(0xFF25D366),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
            ),
          ),
      ],
    );
  }
}
