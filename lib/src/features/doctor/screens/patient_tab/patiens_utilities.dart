import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:firebase_auth/firebase_auth.dart'; // For authentication
import 'package:intl/intl.dart'; // For date formatting
import 'package:healpath/src/features/doctor/models/patient_model.dart';

void viewPatientDetails(
    BuildContext context, Patient patient, Function(String) showSnackBar) {
  showCupertinoModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return PatientDetailsModal(patient: patient, showSnackBar: showSnackBar);
    },
  );
}

class PatientDetailsModal extends StatefulWidget {
  final Patient patient;
  final Function(String) showSnackBar;

  const PatientDetailsModal({
    super.key,
    required this.patient,
    required this.showSnackBar,
  });

  @override
  _PatientDetailsModalState createState() => _PatientDetailsModalState();
}

class _PatientDetailsModalState extends State<PatientDetailsModal> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance; // Firebase Auth instance
  final TextEditingController _commentController = TextEditingController();
  String? uploadedFile;
  String? doctorName; // To store the doctor's name

  @override
  void initState() {
    super.initState();
    _fetchDoctorName();
  }

  Future<void> _fetchDoctorName() async {
    try {
      // Assuming you have a 'users' collection in Firestore where the doctor data is stored
      User? user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(user.uid).get();
        setState(() {
          doctorName = userDoc['fullName'] ?? 'Unknown Doctor';
        });
      }
    } catch (e) {
      widget.showSnackBar('Error fetching doctor name: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        top: false,
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.9,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    _buildPatientInfo(),
                    const SizedBox(height: 20),
                    _buildCommentSection(),
                    const SizedBox(height: 20),
                    _buildMedicalHistoryView(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: const BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Patient Details',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPatientInfo() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('Name', widget.patient.name),
            _buildInfoRow('Admission Date', widget.patient.admissionDate),
            _buildInfoRow('Status', widget.patient.status),
            _buildInfoRow('Age', widget.patient.age.toString()),
            _buildInfoRow('Mostly Used Drug', widget.patient.drugOfChoice),
            _buildInfoRow('Gender', widget.patient.gender),
            _buildInfoRow('HIV Status', widget.patient.hivStatus),
            _buildInfoRow(
                'Injection Frequency', widget.patient.injectionFrequency),
            _buildInfoRow(
                'Needle Sharing History', widget.patient.needleSharingHistory),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Doctors Comments',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Card(
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                StreamBuilder<QuerySnapshot>(
                  stream: _firestore
                      .collection('patients')
                      .doc(widget.patient.id)
                      .collection('comments')
                      .orderBy('time', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }

                    List<DocumentSnapshot> comments = snapshot.data!.docs;

                    return Column(
                      children: comments
                          .map((comment) => _buildCommentItem(comment))
                          .toList(),
                    );
                  },
                ),
                SizedBox(height: 16),
                _buildAddCommentField(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCommentItem(DocumentSnapshot comment) {
    Map<String, dynamic> data = comment.data() as Map<String, dynamic>;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                data['doctorName'] ?? '',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              Text(
                data['time'] ?? '',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(data['comment'] ?? ''),
          const Divider(),
        ],
      ),
    );
  }

  Widget _buildAddCommentField() {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: TextField(
                controller: _commentController,
                decoration: InputDecoration(
                  hintText: 'Add a comment...',
                  hintStyle: TextStyle(
                    height: 1.5,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(
                      color: Colors.blue,
                      width: 2.0,
                    ),
                  ),
                  suffixIcon: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: IconButton(
                      icon: const Icon(Icons.send),
                      color: Colors.blue,
                      onPressed: _addComment,
                    ),
                  ),
                  isCollapsed: true,
                  alignLabelWithHint: true,
                ),
                textAlignVertical: TextAlignVertical.center,
                maxLines: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addComment() {
    if (_commentController.text.isNotEmpty && doctorName != null) {
      // Format the date to only include year, month, and day
      String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

      _firestore
          .collection('patients')
          .doc(widget.patient.id)
          .collection('comments')
          .add({
        'doctorName': doctorName, // Logged-in doctor's name
        'comment': _commentController.text,
        'time': formattedDate, // Date formatted without time
      }).then((_) {
        _commentController.clear();
        widget.showSnackBar('Comment added successfully');
      }).catchError((error) {
        widget.showSnackBar('Failed to add comment: $error');
      });
    }
  }

  Widget _buildMedicalHistoryView() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Medical History',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Medical history.pdf',
              style: TextStyle(color: Colors.blue),
            ),
          ],
        ),
      ),
    );
  }
}

// Function to show a success snackbar
void showSuccessSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          Icon(Icons.check_circle, color: Colors.blue[900]),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: Colors.blue[900]),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.lightBlue[100],
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      duration: const Duration(seconds: 3),
    ),
  );
}
