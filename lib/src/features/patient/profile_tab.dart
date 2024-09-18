import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PatientProfileTab extends StatelessWidget {
  const PatientProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PatientProfileController>(
      init: PatientProfileController(),
      builder: (controller) {
        return Scaffold(
          body: Stack(
            children: [
              Column(
                children: [
                  _buildHeader(context),
                  Expanded(
                    child: _buildProfileContent(controller),
                  ),
                ],
              ),
              Positioned(
                top: 130,
                left: 0,
                right: 0,
                child: _buildProfileImage(controller),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return CustomPaint(
      painter: HeaderCurvePainter(),
      child: Container(
        height: 180,
        padding: const EdgeInsets.only(bottom: 50),
        alignment: Alignment.center,
        child: Text(
          'Profile',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.blue[900],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImage(PatientProfileController controller) {
    return Center(
      child: Stack(
        children: [
          CircleAvatar(
            radius: 60,
            backgroundColor: Colors.blue[900],
            child: CircleAvatar(
              radius: 56,
              backgroundColor: Colors.blue[100],
              child: Text(
                controller.nameController.text[0].toUpperCase(),
                style: const TextStyle(fontSize: 40, color: Colors.blue),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: InkWell(
              onTap: () {
                _showEditProfileDialog(controller);
              },
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.blue,
                child: Icon(Icons.edit, color: Colors.blue[900], size: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileContent(PatientProfileController controller) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 100, left: 20, right: 20),
      child: Column(
        children: [
          _buildInfoField('Username', controller.username),
          _buildInfoField('Full Name', controller.nameController.text),
          _buildInfoField('Email', controller.emailController.text),
          _buildInfoField('Emergency Contact', controller.emergencyContact),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildInfoField(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
          Text(
            value,
            style: const TextStyle(color: Colors.black87),
          ),
        ],
      ),
    );
  }

  void _showEditProfileDialog(PatientProfileController controller) {
    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Profile'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: const InputDecoration(labelText: 'Name'),
                  controller: controller.nameController,
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Email'),
                  controller: controller.emailController,
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Emergency Contact'),
                  controller:
                      TextEditingController(text: controller.emergencyContact),
                  onChanged: (value) => controller.emergencyContact = value,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                controller.updateProfile();
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}

class HeaderCurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = Colors.blue;
    paint.style = PaintingStyle.fill;

    var path = Path();
    path.moveTo(0, 0);
    path.lineTo(0, size.height * 0.8);
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height * 0.8,
    );
    path.lineTo(size.width, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class PatientProfileController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  String profileImageUrl = '';
  String emergencyContact = '';
  String username = 'johndoe';

  @override
  void onInit() {
    super.onInit();
    // Fetch initial data (this would usually be from a backend)
    nameController.text = 'John Doe';
    emailController.text = 'john.doe@example.com';
    emergencyContact = '+1 (555) 123-4567';
  }

  void updateProfile() {
    // Here you would typically send the updated data to your backend
    update();
    Get.snackbar('Success', 'Profile updated successfully',
        snackPosition: SnackPosition.BOTTOM);
  }
}
