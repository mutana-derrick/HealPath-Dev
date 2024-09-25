import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:healpath/src/features/doctor/models/patient_model.dart';

// Function to view patient details
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

// PatientDetailsModal widget
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
  late List<Map<String, String>> comments;
  final TextEditingController _commentController = TextEditingController();
  String? uploadedFile;

  @override
  void initState() {
    super.initState();
    comments = [
      {
        'doctorName': 'Dr. Smith',
        'comment': 'Patient is responding well to treatment.',
        'time': '2024-09-25 10:30 AM'
      },
      {
        'doctorName': 'Dr. Johnson',
        'comment': 'The patients vitals are stable.',
        'time': '2024-09-24 02:45 PM'
      },
    ];
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
        mainAxisAlignment: MainAxisAlignment.center, // Center horizontally
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
            _buildInfoRow('ID', widget.patient.id),
            _buildInfoRow('Admission Date', widget.patient.admissionDate),
            _buildInfoRow('Status', widget.patient.status),
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
                ...comments.map(_buildCommentItem).toList(),
                SizedBox(height: 16),
                _buildAddCommentField(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCommentItem(Map<String, String> comment) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                comment['doctorName']!,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              Text(
                comment['time']!,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(comment['comment']!),
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
                    height:
                        1.5, // Adjust this value to vertically center the hint text
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10, // Increased vertical padding
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(
                      color: Colors.blue,
                      width: 2.0,
                    ),
                  ),
                  suffixIcon: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 4), // Added padding to center the icon
                    child: IconButton(
                      icon: const Icon(Icons.send),
                      color: Colors.blue,
                      onPressed: _addComment,
                    ),
                  ),
                  isCollapsed: true, // This helps in reducing extra padding
                  alignLabelWithHint:
                      true, // This helps align the hint text vertically
                ),
                textAlignVertical: TextAlignVertical
                    .center, // Centers the input text vertically
                maxLines: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMedicalHistoryView() {
    // Simulated static data for medical history file
    String medicalHistoryFile = 'Medical_History_Report.pdf';

    return Column(
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

        // Static file representation (Medical History from another hospital)
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: GestureDetector(
            onTap: () {
              // Logic to view the medical history file
              widget.showSnackBar('Viewing $medicalHistoryFile');
            },
            child: Text(
              medicalHistoryFile,
              style: const TextStyle(
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _addComment() {
    if (_commentController.text.isNotEmpty) {
      setState(() {
        comments.insert(0, {
          'doctorName': 'Dr. You',
          'comment': _commentController.text,
          'time': DateTime.now().toString().substring(0, 16),
        });
        _commentController.clear();
      });
      widget.showSnackBar('Comment added successfully');
    }
  }
}

// Extension for string capitalization
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
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
