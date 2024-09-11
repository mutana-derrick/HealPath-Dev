import 'package:flutter/material.dart';

class Patient {
  final String name;
  final String id;
  final String status;
  final String admissionDate;

  Patient(
      {required this.name,
      required this.id,
      required this.status,
      required this.admissionDate});
}

class PatientsTab extends StatefulWidget {
  const PatientsTab({super.key});

  @override
  _PatientsTabState createState() => _PatientsTabState();
}

class _PatientsTabState extends State<PatientsTab> {
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
        status: "Active",
        admissionDate: "2022-11-10"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
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
            child: ListView.builder(
              itemCount: patients.length,
              itemBuilder: (context, index) {
                return _buildPatientCard(patients[index]);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddPatientDialog(),
        backgroundColor: Colors.blue[500],
        child: Icon(
          Icons.add,
          color: Colors.blue[900], // Color of the icon
        ), // Background color of the button
      ),
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
                if (value == 'archive') {
                  _archivePatient(patient);
                } else if (value == 'view') {
                  _viewPatientDetails(patient);
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: 'view',
                  child: Text('View Details'),
                ),
                const PopupMenuItem<String>(
                  value: 'archive',
                  child: Text('Archive'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showAddPatientDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String name = '';
        String id = '';
        return AlertDialog(
          title: const Text('Add New Patient'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                decoration: const InputDecoration(hintText: "Patient Name"),
                onChanged: (value) {
                  name = value;
                },
              ),
              TextField(
                decoration: const InputDecoration(hintText: "Patient ID"),
                onChanged: (value) {
                  id = value;
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                if (name.isNotEmpty && id.isNotEmpty) {
                  setState(() {
                    patients.add(Patient(
                      name: name,
                      id: id,
                      status: "Active",
                      admissionDate: DateTime.now().toString().substring(0, 10),
                    ));
                  });
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _archivePatient(Patient patient) {
    setState(() {
      int index = patients.indexWhere((p) => p.id == patient.id);
      if (index != -1) {
        patients[index] = Patient(
          name: patient.name,
          id: patient.id,
          status: "Archived",
          admissionDate: patient.admissionDate,
        );
      }
    });
  }

  void _viewPatientDetails(Patient patient) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(patient.name),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text("ID: ${patient.id}"),
              Text("Status: ${patient.status}"),
              Text("Admission Date: ${patient.admissionDate}"),
              // Add more patient details here
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
