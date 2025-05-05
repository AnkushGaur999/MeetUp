import 'dart:math';

import 'package:flutter/material.dart';
import 'package:meet_up/data/models/buddy.dart';

class StatusItem extends StatelessWidget {
  final Buddy buddy;
  const StatusItem({super.key, required this.buddy});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              StatusBorder(
                segments: 10, // number of statuses
                image: NetworkImage(buddy.imageUrl!),
                size: 70,
              ),

              SizedBox(width: 10),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      buddy.name!,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    Text(
                      "1h ago",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}

class StatusBorder extends StatelessWidget {
  final int segments;
  final double size;
  final double borderWidth;
  final ImageProvider image;

  const StatusBorder({
    super.key,
    required this.segments,
    required this.image,
    this.size = 70,
    this.borderWidth = 5,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _StatusPainter(segments, borderWidth),
      child: Container(
        width: size,
        height: size,
        padding: EdgeInsets.all(borderWidth),
        child: ClipOval(
          child: Image(
            image: image,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class _StatusPainter extends CustomPainter {
  final int segments;
  final double borderWidth;
  final Color color;

  _StatusPainter(this.segments, this.borderWidth, {this.color = Colors.green});

  @override
  void paint(Canvas canvas, Size size) {
    if (segments <= 0) return;

    final rect = Offset.zero & size;
    final center = rect.center;
    final radius = min(size.width, size.height) / 2;

    final gapSize = pi / 100; // small gap between segments
    final sweep = (2 * pi - (segments * gapSize)) / segments;

    final paint = Paint()
      ..color = color
      ..strokeWidth = borderWidth
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < segments; i++) {
      final start = i * (sweep + gapSize) - pi / 2;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius - borderWidth / 2),
        start,
        sweep,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

