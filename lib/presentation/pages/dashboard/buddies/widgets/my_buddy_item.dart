import 'package:flutter/material.dart';
import 'package:meet_up/data/models/buddy.dart';

class MyBuddyItem extends StatelessWidget {

  final Buddy buddy;

  const MyBuddyItem({super.key, required this.buddy});

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
              CircleAvatar(radius: 30, child: Image.network(buddy.imageUrl!)),

              SizedBox(width: 10),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      buddy.name!,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    Text(
                      buddy.about!,
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
