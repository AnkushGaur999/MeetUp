import 'package:flutter/material.dart';
import 'package:meet_up/core/utils/time_date_utils.dart';
import 'package:meet_up/data/models/recent_chat.dart';

class RecentChatItem extends StatelessWidget {
  final RecentChat recentChat;

  const RecentChatItem({super.key, required this.recentChat});

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
              CircleAvatar(
                radius: 30,
                child: Image.network(recentChat.imageUrl!),
              ),

              SizedBox(width: 10),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recentChat.name!,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    Text(
                      recentChat.lastMessage!,
                      style: TextStyle(color: Colors.black),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(getTimeAgo(int.parse(recentChat.sent!))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
