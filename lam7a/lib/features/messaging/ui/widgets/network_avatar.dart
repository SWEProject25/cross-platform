
import 'package:flutter/material.dart';

class NetworkAvatar extends StatelessWidget {
  const NetworkAvatar({
    super.key,
    this.radius,
    this.url,
  });

  final double? radius;
  final String? url;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      child: ClipOval(
        child: Image.network(
          url ?? "",
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              const Icon(Icons.person, size: 24),
        ),
      ),
    );
  }
}