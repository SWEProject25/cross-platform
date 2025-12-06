import 'package:flutter/material.dart';

class SuggestedUserItem extends StatelessWidget {
  final String text;
  const SuggestedUserItem({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white12,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 18,
            backgroundColor: Colors.white24,
            child: Icon(Icons.person, color: Colors.white54),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Colors.white, fontSize: 15),
            ),
          ),

          TextButton(
            onPressed: () {},
            child: const Text("Follow", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
