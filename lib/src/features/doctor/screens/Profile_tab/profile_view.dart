import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:healpath/src/features/doctor/controllers/prrofile_controller.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final ProfileController _profileController = ProfileController();
  Map<String, dynamic> userInfo = {};
  bool _isLoading = true;
  Map<String, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();
    _fetchUserInfo();
  }

  Future<void> _fetchUserInfo() async {
    setState(() => _isLoading = true);
    Map<String, dynamic>? fetchedData =
        await _profileController.fetchUserInfo();
    if (fetchedData != null) {
      setState(() {
        userInfo = {
          'fullName': fetchedData['fullName'] ?? '',
          'email': fetchedData['email'] ?? '',
          'specialization': fetchedData['specialization'] ?? '',
          'phoneNumber': fetchedData['phoneNumber'] ?? '',
          'profilePicture': fetchedData['profilePicture'] ?? '',
        };
      });
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.blue[100],
                  child: userInfo['profilePicture']?.isNotEmpty == true
                      ? ClipOval(
                          child: Image.network(
                            userInfo['profilePicture'],
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Text(
                          userInfo['fullName']?.isNotEmpty == true
                              ? userInfo['fullName']![0].toUpperCase()
                              : '?',
                          style:
                              TextStyle(fontSize: 40, color: Colors.blue[900]),
                        ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: InkWell(
                    onTap: _showEditProfileBottomSheet,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.blue, width: 2),
                      ),
                      child:
                          Icon(Icons.edit, size: 20, color: Colors.blue[900]),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          ...userInfo.entries
              .where((entry) => entry.key != 'profilePicture')
              .map((entry) => _buildInfoField(entry.key, entry.value))
              .toList(),
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
            label.capitalize(),
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

  void _showEditProfileBottomSheet() {
    userInfo.forEach((key, value) {
      if (key != 'email' && key != 'profilePicture') {
        _controllers[key] = TextEditingController(text: value);
      }
    });

    showCupertinoModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Material(
              child: SafeArea(
                top: false,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom,
                      ),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: constraints.maxHeight,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              color: Colors.blue,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: const Center(
                                child: Text(
                                  'Edit Profile',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            const Divider(height: 1, color: Colors.white),
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  ...userInfo.entries
                                      .where((entry) =>
                                          entry.key != 'email' &&
                                          entry.key != 'profilePicture')
                                      .map((entry) {
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 16),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 8),
                                            child: Text(
                                              entry.key.capitalize(),
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                          CupertinoTextField(
                                            controller: _controllers[entry.key],
                                            onChanged: (value) {
                                              setModalState(() {
                                                userInfo[entry.key] = value;
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                  const SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      OutlinedButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                        style: OutlinedButton.styleFrom(
                                          side: const BorderSide(
                                              color: Colors.blue),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 12),
                                        ),
                                        child: const Text(
                                          'Cancel',
                                          style: TextStyle(color: Colors.blue),
                                        ),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          _updateUserInfo();
                                          Navigator.of(context).pop();
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blue,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 12),
                                        ),
                                        child: const Text(
                                          'Save Changes',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _updateUserInfo() async {
    await _profileController.updateUserInfo(userInfo);
    await _fetchUserInfo(); // Re-fetch user info to reflect updated data
    _showSuccessSnackBar();
  }

  void _showSuccessSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: const [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 10),
            Text('Profile updated successfully!'),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controllers.forEach((key, controller) {
      controller
          .dispose(); // Dispose each TextEditingController to avoid memory leaks
    });
    super.dispose(); // Ensure to call the parent class's dispose method
  }
}

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}
