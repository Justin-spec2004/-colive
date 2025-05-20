import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class AchievementsScreen extends StatelessWidget {
  final String achievementTitle = "Completed Flutter Course! 🎉";
  final String achievementDescription =
      "I just completed my Flutter Development Course. Excited to build amazing apps! 🚀";
  final String achievementImage =
      "https://example.com/achievement_image.png"; // Replace with actual image URL

  void _shareAchievement(BuildContext context) {
    final String shareText =
        "$achievementTitle\n\n$achievementDescription\n\nCheck out my achievement!";

    Share.share(shareText);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.emoji_events, size: 80, color: Colors.orange),
          SizedBox(height: 10),
          Text(
            achievementTitle,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          Text(
            achievementDescription,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () => _shareAchievement(context),
            icon: Icon(Icons.share),
            label: Text("Share Achievement"),
          ),
        ],
      ),
    );
  }
}
