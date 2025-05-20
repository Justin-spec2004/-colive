// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class AccountProfile extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     User? user = FirebaseAuth.instance.currentUser; // Get current user

//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           // User Profile Picture
//           CircleAvatar(
//             radius: 50,
//             backgroundImage: user?.photoURL != null
//                 ? NetworkImage(user!.photoURL!)
//                 : AssetImage("assets/default_avatar.png")
//                     as ImageProvider, // Default avatar
//           ),
//           SizedBox(height: 10),

//           // Display Name
//           Text(
//             user?.displayName ?? "No Name",
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           ),

//           // Email Address
//           Text(
//             user?.email ?? "No Email",
//             style: TextStyle(fontSize: 16, color: Colors.grey),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:share_plus/share_plus.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  User? user = FirebaseAuth.instance.currentUser; // Get signed-in user

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Function to Share Content
  void _shareProfile() {
    String shareText = "Check out my profile on our app! \n\n"
        "Name: ${user?.displayName ?? "No Name"} \n"
        "Email: ${user?.email ?? "No Email"}";

    Share.share(shareText);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: _shareProfile, // Share button action
          )
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(icon: Icon(Icons.feed), text: "Feeds"),
            Tab(icon: Icon(Icons.article), text: "Blog"),
            Tab(icon: Icon(Icons.emoji_events), text: "Achievements"),
          ],
        ),
      ),
      body: Column(
        children: [
          // Profile Section
          Container(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: user?.photoURL != null
                      ? NetworkImage(user!.photoURL!)
                      : AssetImage("assets/default_avatar.png")
                          as ImageProvider, // Default image
                ),
                SizedBox(height: 10),
                Text(user?.displayName ?? "No Name",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text(user?.email ?? "No Email",
                    style: TextStyle(fontSize: 16, color: Colors.grey)),
              ],
            ),
          ),

          // TabBar Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                FeedsScreen(),
                BlogScreen(),
                AchievementsScreen(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Placeholder Screens for Feeds, Blog, Achievements
class FeedsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Feeds will be displayed here"));
  }
}

class BlogScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Blog posts will be displayed here"));
  }
}

class AchievementsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Achievements will be displayed here"));
  }
}
