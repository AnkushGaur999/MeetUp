import 'package:flutter/material.dart';

class ProfileFieldWidget extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const ProfileFieldWidget({
    super.key,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.grey.shade100, // Move color here
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(color: Colors.black87, fontSize: 18),
                ),
              ),

              Icon(Icons.arrow_forward_ios_rounded),
            ],
          ),
        ),
      ),
    );
  }
}
