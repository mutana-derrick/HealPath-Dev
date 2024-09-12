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
              InteractivePostCard(
                title: 'Tips for Maintaining Sobriety',
                content:
                    'Here are some helpful tips to stay on track with your recovery...',
                author: 'Dr. Smith',
                time: '2 hours ago',
                initialComments: [
                  Comment('Great advice, doctor!', 'John D.', '1 hour ago'),
                  Comment('This really helps, thank you!', 'Sarah M.',
                      '30 minutes ago'),
                ],
              ),
              InteractivePostCard(
                title: 'Importance of Support Groups',
                content:
                    'Support groups play a crucial role in recovery. Here\'s why...',
                author: 'Dr. Johnson',
                time: '1 day ago',
                initialComments: [
                  Comment('I\'ve found my group so helpful', 'Mike R.',
                      '12 hours ago'),
                  Comment('Can you recommend any online groups?', 'Emily S.',
                      '6 hours ago'),
                ],
              ),
              InteractivePostCard(
                title: 'Dealing with Triggers',
                content:
                    'Recognizing and managing triggers is essential. Let\'s discuss some strategies...',
                author: 'Dr. Smith',
                time: '3 days ago',
                initialComments: [
                  Comment('This has been my biggest challenge', 'Alex W.',
                      '2 days ago'),
                  Comment('The breathing technique really works!', 'Lisa K.',
                      '1 day ago'),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class Comment {
  final String content;
  final String author;
  final String time;

  Comment(this.content, this.author, this.time);
}

class InteractivePostCard extends StatefulWidget {
  final String title;
  final String content;
  final String author;
  final String time;
  final List<Comment> initialComments;

  const InteractivePostCard({
    super.key,
    required this.title,
    required this.content,
    required this.author,
    required this.time,
    required this.initialComments,
  });

  @override
  _InteractivePostCardState createState() => _InteractivePostCardState();
}

class _InteractivePostCardState extends State<InteractivePostCard> {
  late List<Comment> comments;
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    comments = List.from(widget.initialComments);
  }

  void _addComment() {
    if (_commentController.text.isNotEmpty) {
      setState(() {
        comments.add(Comment(
          _commentController.text,
          'Anonymous User', // You can replace this with actual user name later
          'Just now',
        ));
        _commentController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16.0),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue,
              child:
                  Text(widget.author[0], style: const TextStyle(color: Colors.white),),
            ),
            title: Text(widget.title,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(widget.author),
            trailing:
                Text(widget.time, style: TextStyle(color: Colors.grey[600])),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(widget.content),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              '${comments.length} comments',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          const Divider(),
          ExpansionTile(
            title: const Text('View Comments',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
            children: [
              ...comments.map(_buildCommentTile).toList(),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _commentController,
                        decoration: InputDecoration(
                          hintText: 'Add a comment...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.send),
                            onPressed: _addComment,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCommentTile(Comment comment) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.grey[300],
        child:
            Text(comment.author[0], style: TextStyle(color: Colors.grey[700])),
      ),
      title: Text(comment.content),
      subtitle: Text('${comment.author} • ${comment.time}',
          style: TextStyle(color: Colors.grey[600])),
    );
  }
}
