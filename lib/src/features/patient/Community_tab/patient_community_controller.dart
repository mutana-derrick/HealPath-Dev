import 'package:get/get.dart';
import 'package:healpath/src/features/patient/community_tab/models.dart';

class PatientCommunityController extends GetxController {
  List<Post> posts = [
    Post(
      userName: 'Dr. Mohamed Benar',
      userProfilePicture:
          'https://www.flaticon.com/free-icon/medical-assistance_4526826?related_id=4526826',
      content:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam vitae nibh id mauris condimentum volutis et sed enim.',
      timestamp: 'March 15 · 14:30',
      likes: 15,
      comments: [
        Comment(
          content:
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam vitae nibh id mauris condi mentum volutis et sed enim.',
          userName: 'Salahuddin',
          userProfilePicture: 'https://example.com/salahuddin.jpg',
          timestamp: '2h',
        ),
        Comment(
          content:
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam vitae nibh id.',
          userName: 'Aman Richman',
          userProfilePicture: 'https://example.com/aman.jpg',
          timestamp: '1h',
        ),
      ],
    ),

    Post(
      userName: 'Dr. Mohamed Benar',
      userProfilePicture:
          'https://www.flaticon.com/free-icon/medical-assistance_4526826?related_id=4526826',
      content:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam vitae nibh id mauris condimentum volutis et sed enim.',
      timestamp: 'March 15 · 14:30',
      likes: 15,
      comments: [
        Comment(
          content:
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam vitae nibh id mauris condi mentum volutis et sed enim.',
          userName: 'Salahuddin',
          userProfilePicture: 'https://example.com/salahuddin.jpg',
          timestamp: '2h',
        ),
        Comment(
          content:
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam vitae nibh id.',
          userName: 'Aman Richman',
          userProfilePicture: 'https://example.com/aman.jpg',
          timestamp: '1h',
        ),
      ],
    ),

    Post(
      userName: 'Dr. Mohamed Benar',
      userProfilePicture:
          'https://www.flaticon.com/free-icon/medical-assistance_4526826?related_id=4526826',
      content:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam vitae nibh id mauris condimentum volutis et sed enim.',
      timestamp: 'March 15 · 14:30',
      likes: 15,
      comments: [
        Comment(
          content:
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam vitae nibh id mauris condi mentum volutis et sed enim.',
          userName: 'Salahuddin',
          userProfilePicture: 'https://example.com/salahuddin.jpg',
          timestamp: '2h',
        ),
        Comment(
          content:
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam vitae nibh id.',
          userName: 'Aman Richman',
          userProfilePicture: 'https://example.com/aman.jpg',
          timestamp: '1h',
        ),
      ],
    ),
    // Add more posts as needed...
  ];

  // Additional methods and logic for the controller...
}