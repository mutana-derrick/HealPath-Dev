import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PatientProfileTab extends StatelessWidget {
  const PatientProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PatientProfileController>(
      init: PatientProfileController(),
      builder: (controller) {
        return DefaultTabController(
          length: 2,
          child: Column(
            children: [
              const TabBar(
                tabs: [
                  Tab(text: 'Profile'),
                  Tab(text: 'Appointments'),
                ],
                labelColor: Colors.blue,
                unselectedLabelColor: Colors.grey,
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    _buildProfileView(controller),
                    _buildAppointmentsView(),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProfileView(PatientProfileController controller) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(controller.profileImageUrl),
              backgroundColor: Colors.purple,
              child: controller.profileImageUrl.isEmpty
                  ? Text(
                      controller.nameController.text[0],
                      style: const TextStyle(fontSize: 40, color: Colors.white),
                    )
                  : null,
            ),
          ),
          const SizedBox(height: 20),
          _buildInfoField('Name', controller.nameController.text),
          _buildInfoField('Email', controller.emailController.text),
          _buildInfoField('Password', controller.passwordController.text),
          _buildInfoField('Emergency Contact', controller.emergencyContact),
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: () => _showEditProfileDialog(controller),
              child: const Text('Edit Profile'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
          const Divider(),
        ],
      ),
    );
  }

  Widget _buildAppointmentsView() {
    // Placeholder for appointments view
    return const Center(child: Text('Appointments View'));
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
                  decoration: const InputDecoration(labelText: 'Password'),
                  controller: controller.passwordController,
                ),
                TextField(
                  decoration:
                      const InputDecoration(labelText: 'Emergency Contact'),
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

class PatientProfileController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String profileImageUrl = '';
  String emergencyContact = '';

  @override
  void onInit() {
    super.onInit();
    // Fetch initial data (this would usually be from a backend)
    nameController.text = 'John Doe';
    emailController.text = 'john.doe@example.com';
    passwordController.text = 'password';
    emergencyContact = 'Jane Doe: +9876543210';
  }

  // Update profile functionality (this should send updated data to a backend)
  void updateProfile() {
    // Here you would typically send the updated data to your backend
    // For now, we'll just update the local state and show a success message
    emergencyContact = emergencyContact;
    update(); // This triggers a rebuild of the UI

    Get.snackbar('Success', 'Profile updated successfully',
        snackPosition: SnackPosition.BOTTOM);
  }
}
