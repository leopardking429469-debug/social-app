import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/user_model.dart';
import '../../models/notification_model.dart';
import '../../services/firebase_service.dart';
import '../../services/auth_service.dart';

class UserProfileScreen extends StatefulWidget {
  final String userId;

  const UserProfileScreen({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  late FirebaseService _firebaseService;
  late AuthService _authService;
  bool _isFollowing = false;

  @override
  void initState() {
    super.initState();
    _firebaseService = context.read<FirebaseService>();
    _authService = context.read<AuthService>();
    _recordProfileView();
  }

  Future<void> _recordProfileView() async {
    try {
      final currentUser = _authService.currentUser;
      if (currentUser != null && currentUser.uid != widget.userId) {
        final userData = await _firebaseService.getUserData(currentUser.uid);
        if (userData != null) {
          await _firebaseService.recordProfileView(
            widget.userId,
            currentUser.uid,
            userData.username,
          );
        }
      }
    } catch (e) {
      print('Error recording profile view: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: FutureBuilder<UserModel?>(
        future: _firebaseService.getUserData(widget.userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('User not found'));
          }

          final user = snapshot.data!;
          final isCurrentUser = _authService.currentUser?.uid == user.uid;

          return SingleChildScrollView(
            child: Column(
              children: [
                // Header Section
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.grey[100],
                  child: Column(
                    children: [
                      // Profile Picture
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: user.profileImageUrl != null
                            ? NetworkImage(user.profileImageUrl!)
                            : null,
                        child: user.profileImageUrl == null
                            ? const Icon(Icons.person, size: 50)
                            : null,
                      ),
                      const SizedBox(height: 16),

                      // Username
                      Text(
                        user.username,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      // Email
                      Text(
                        user.email,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),

                      // Bio
                      if (user.bio != null && user.bio!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            user.bio!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),

                      const SizedBox(height: 16),

                      // Stats Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildStat(user.followersCount.toString(), 'Followers'),
                          _buildStat(user.followingCount.toString(), 'Following'),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Action Buttons
                      if (!isCurrentUser)
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  // TODO: Implement follow/unfollow
                                },
                                child: Text(_isFollowing ? 'Following' : 'Follow'),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  // TODO: Implement message
                                },
                                child: const Text('Message'),
                              ),
                            ),
                          ],
                        )
                      else
                        ElevatedButton(
                          onPressed: () {
                            // TODO: Navigate to edit profile
                          },
                          child: const Text('Edit Profile'),
                        ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Profile View History Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Profile Views',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildProfileViewsList(),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStat(String count, String label) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildProfileViewsList() {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _firebaseService.getRecentProfileViews(widget.userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Text(
              'No profile views yet',
              style: TextStyle(color: Colors.grey[600]),
            ),
          );
        }

        final views = snapshot.data!;
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: views.length,
          itemBuilder: (context, index) {
            final view = views[index];
            return ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.person),
              ),
              title: Text('@${view['viewerUsername']}'),
              subtitle: Text(
                'Viewed your profile',
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
              trailing: const Icon(Icons.visibility, size: 20, color: Colors.grey),
            );
          },
        );
      },
    );
  }
}
