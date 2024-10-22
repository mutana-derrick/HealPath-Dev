import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:healpath/src/features/patient/controllers/patient_community_controller.dart';
import 'package:healpath/src/features/patient/screens/community_tab/widgets/comments_sheets.dart';
import 'package:healpath/src/features/patient/models/models.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:url_launcher/url_launcher.dart';
import 'widgets/post_card.dart';
import 'widgets/search_bar_with_notifications.dart';
import 'widgets/notifications_list.dart';

class PatientCommunityTab extends StatefulWidget {
  const PatientCommunityTab({super.key});

  @override
  _PatientCommunityTabState createState() => _PatientCommunityTabState();
}

class _PatientCommunityTabState extends State<PatientCommunityTab> {
  final PatientCommunityController controller =
      Get.put(PatientCommunityController());
  int _selectedIndex = 0;
  List<dynamic> _news = [];

  @override
  void initState() {
    super.initState();
    _fetchNews();
  }

  Future<void> _fetchNews() async {
    final newsApiKey = '4dd20105594e4aeea02519c186085c20';
    final response = await http.get(
      Uri.parse(
          'https://newsapi.org/v2/everything?q=rehabilitation+addiction&apiKey=$newsApiKey'),
    );
    if (response.statusCode == 200) {
      setState(() {
        _news = json.decode(response.body)['articles'];
      });
    } else {
      print('Failed to fetch news: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SearchBarWithNotifications(
            onNotificationTap: () => _showNotifications(context),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildTabButton('Posts', 0),
                _buildTabButton('News', 1),
              ],
            ),
          ),
          Expanded(
            child: IndexedStack(
              index: _selectedIndex,
              children: [
                _buildPostsList(),
                _buildNewsList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String title, int index) {
    return TextButton(
      onPressed: () => setState(() => _selectedIndex = index),
      child: Text(
        title,
        style: TextStyle(
          color: _selectedIndex == index ? Colors.blue : Colors.grey,
          fontWeight:
              _selectedIndex == index ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildPostsList() {
    return Obx(() => ListView.builder(
          itemCount: controller.filteredPosts.length,
          itemBuilder: (context, index) {
            return PostCard(
              post: controller.filteredPosts[index],
              onTap: () =>
                  _showComments(context, controller.filteredPosts[index]),
            );
          },
        ));
  }

  Widget _buildNewsList() {
    return ListView.builder(
      itemCount: _news.length,
      itemBuilder: (context, index) {
        final article = _news[index];
        return NewsCard(
          title: article['title'],
          description: article['description'],
          url: article['url'],
          imageUrl: article['urlToImage'],
        );
      },
    );
  }

  void _showComments(BuildContext context, Post post) {
    showCupertinoModalBottomSheet(
      context: context,
      builder: (context) => CommentsSheet(post: post),
    );
  }

  void _showNotifications(BuildContext context) {
    showCupertinoModalBottomSheet(
      context: context,
      expand: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const NotificationsList(),
    );
  }
}

// NewsCard widget
class NewsCard extends StatelessWidget {
  final String title;
  final String description;
  final String url;
  final String? imageUrl;

  const NewsCard({
    super.key,
    required this.title,
    required this.description,
    required this.url,
    this.imageUrl,
  });

  // Function to launch the URL
  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: imageUrl != null
            ? Image.network(imageUrl!, width: 50, height: 50, fit: BoxFit.cover)
            : const Icon(Icons.article),
        title: Text(title),
        subtitle:
            Text(description, maxLines: 2, overflow: TextOverflow.ellipsis),
        onTap: () {
          // Launch the URL when the card is tapped
          _launchUrl(url);
        },
      ),
    );
  }
}
