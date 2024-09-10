// lib/tabs/community_tab.dart
import 'package:flutter/material.dart';

class CommunityTab extends StatelessWidget {
  const CommunityTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Create a new post...',
              suffixIcon: IconButton(
                icon: const Icon(Icons.send),
                onPressed: () {
                  // TODO: Implement post creation logic
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView(
            children: [
              _buildPostCard(
                'Tips for Maintaining Sobriety',
                'Here are some helpful tips to stay on track with your recovery...',
                'Dr. Smith',
                '2 hours ago',
                3,
                [
                  _buildCommentTile(
                      'Great advice, doctor!', 'John D.', '1 hour ago'),
                  _buildCommentTile('This really helps, thank you!', 'Sarah M.',
                      '30 minutes ago'),
                ],
              ),
              _buildPostCard(
                'Importance of Support Groups',
                'Support groups play a crucial role in recovery. Here\'s why...',
                'Dr. Johnson',
                '1 day ago',
                5,
                [
                  _buildCommentTile('I\'ve found my group so helpful',
                      'Mike R.', '12 hours ago'),
                  _buildCommentTile('Can you recommend any online groups?',
                      'Emily S.', '6 hours ago'),
                ],
              ),
              _buildPostCard(
                'Dealing with Triggers',
                'Recognizing and managing triggers is essential. Let\'s discuss some strategies...',
                'Dr. Smith',
                '3 days ago',
                7,
                [
                  _buildCommentTile('This has been my biggest challenge',
                      'Alex W.', '2 days ago'),
                  _buildCommentTile('The breathing technique really works!',
                      'Lisa K.', '1 day ago'),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPostCard(String title, String content, String author,
      String time, int commentCount, List<Widget> comments) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(
              child: Text(author[0]),
            ),
            title: Text(title,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(author),
            trailing: Text(time),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(content),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              '$commentCount comments',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          const Divider(),
          ...comments,
          TextButton(
            onPressed: () {
              // TODO: Implement comment creation logic
            },
            child: const Text('Add a comment'),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentTile(String comment, String author, String time) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.grey[300],
        child: Text(author[0]),
      ),
      title: Text(comment),
      subtitle: Text('$author • $time'),
    );
  }
}
