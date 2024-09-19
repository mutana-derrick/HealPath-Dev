import 'package:flutter/material.dart';
import 'package:healpath/src/features/doctor/Patients/patiens_utilities.dart';
import 'package:healpath/src/features/doctor/Patients/patient_modal.dart';

class PatientsTab extends StatefulWidget {
  const PatientsTab({super.key});

  @override
  _PatientsTabState createState() => _PatientsTabState();
}

class _PatientsTabState extends State<PatientsTab>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Patient> patients = [
    Patient(
        name: "John Doe",
        id: "P001",
        status: "Active",
        admissionDate: "2023-01-15"),
    Patient(
        name: "Jane Smith",
        id: "P002",
        status: "Active",
        admissionDate: "2023-02-20"),
    Patient(
        name: "Mike Johnson",
        id: "P003",
        status: "Archived",
        admissionDate: "2022-11-10"),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: Column(
          children: [
            const TabBar(
              tabs: [
                Tab(text: 'Active'),
                Tab(text: 'Archived'),
              ],
              labelColor: Colors.blue, // Adjust color as needed
              unselectedLabelColor: Colors.grey, // Adjust color as needed
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Search patients...',
                      prefixIcon: Icon(Icons.search),
                      border: InputBorder.none,
                      suffixIcon: Icon(Icons.people),
                    ),
                    onChanged: (value) {
                      // TODO: Implement search functionality
                    },
                  ),
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildPatientList('Active'),
                  _buildPatientList('Archived'),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () =>
              showAddPatientBottomSheet(context, _showSuccessSnackBar),
          backgroundColor: Colors.blue[500],
          child: Icon(
            Icons.add,
            color: Colors.blue[900],
          ),
        ),
      ),
    );
  }

  Widget _buildPatientList(String status) {
    List<Patient> filteredPatients =
        patients.where((p) => p.status == status).toList();
    return ListView.builder(
      itemCount: filteredPatients.length,
      itemBuilder: (context, index) {
        return _buildPatientCard(filteredPatients[index]);
      },
    );
  }

  Widget _buildPatientCard(Patient patient) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(patient.name[0]),
        ),
        title: Text(patient.name),
        subtitle:
            Text("ID: ${patient.id} | Admitted: ${patient.admissionDate}"),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(patient.status,
                style: TextStyle(
                  color:
                      patient.status == "Active" ? Colors.green : Colors.grey,
                )),
            const SizedBox(width: 8),
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'toggle') {
                  _togglePatientStatus(patient);
                } else if (value == 'view') {
                  viewPatientDetails(context, patient, _showSuccessSnackBar);
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: 'view',
                  child: Text('View Details'),
                ),
                PopupMenuItem<String>(
                  value: 'toggle',
                  child:
                      Text(patient.status == 'Active' ? 'Archive' : 'Activate'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _togglePatientStatus(Patient patient) {
    setState(() {
      patient.status = patient.status == 'Active' ? 'Archived' : 'Active';
    });
    _showSuccessSnackBar('Patient status updated successfully');
  }

  void _showSuccessSnackBar(String message) {
    showSuccessSnackBar(context, message);
  }
}
