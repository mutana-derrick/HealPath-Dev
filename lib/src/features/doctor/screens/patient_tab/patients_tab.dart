import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:healpath/src/features/doctor/screens/patient_tab/patiens_utilities.dart';
import 'package:healpath/src/features/doctor/models/patient_model.dart';

class PatientsController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  RxList<Patient> patients = <Patient>[].obs;
  RxList<Patient> filteredPatients = <Patient>[].obs;
  RxBool isLoading = true.obs;
  RxString errorMessage = ''.obs;
  RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPatients();
    debounce(searchQuery, (_) => filterPatients(),
        time: const Duration(milliseconds: 500));
  }

  Future<void> fetchPatients() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .where('role', isEqualTo: 'patient')
          .get();

      patients.value = snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        // Handle Timestamp to String conversion for 'createdAt'
        Timestamp? createdAtTimestamp = data['createdAt'];
        String formattedDate = '';

        if (createdAtTimestamp != null) {
          DateTime date = createdAtTimestamp.toDate();
          formattedDate =
              '${date.year}-${date.month}-${date.day}'; // Format as needed
        }

        return Patient(
          name: data['fullName'] ?? '',
          id: doc.id,
          status: data['status'] ?? 'Active',
          admissionDate: formattedDate, // Use the formatted date
        );
      }).toList();

      filterPatients(); // Apply the initial filtering based on search query
    } catch (e) {
      errorMessage.value = 'Error fetching patients: $e';
    } finally {
      isLoading.value = false;
    }
  }

  void filterPatients() {
    final query = searchQuery.value.toLowerCase();
    filteredPatients.value = patients.where((patient) {
      return patient.name.toLowerCase().contains(query);
    }).toList();
  }

  Future<void> togglePatientStatus(Patient patient) async {
    try {
      String newStatus = patient.status == 'Active' ? 'Archived' : 'Active';
      await _firestore.collection('users').doc(patient.id).update({
        'status': newStatus,
      });
      patient.status = newStatus;
      patients.refresh();
      filterPatients();
    } catch (e) {
      errorMessage.value = 'Error updating patient status: $e';
    }
  }
}

class PatientsTab extends StatelessWidget {
  final PatientsController controller = Get.put(PatientsController());

  PatientsTab({super.key});

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
              labelColor: Colors.blue,
              unselectedLabelColor: Colors.grey,
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
                      controller.searchQuery.value =
                          value; // Updates the search query
                    },
                  ),
                ),
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: controller.fetchPatients,
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (controller.errorMessage.isNotEmpty) {
                    return Center(child: Text(controller.errorMessage.value));
                  } else {
                    return TabBarView(
                      children: [
                        _buildPatientList('Active'),
                        _buildPatientList('Archived'),
                      ],
                    );
                  }
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPatientList(String status) {
    return Obx(() {
      List<Patient> filteredPatients =
          controller.filteredPatients.where((p) => p.status == status).toList();

      if (filteredPatients.isEmpty) {
        return const Center(child: Text('No patients found'));
      }

      return ListView.builder(
        itemCount: filteredPatients.length,
        itemBuilder: (context, index) {
          return _buildPatientCard(context, filteredPatients[index]);
        },
      );
    });
  }

  Widget _buildPatientCard(BuildContext context, Patient patient) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(patient.name[0]),
        ),
        title: Text(patient.name),
        subtitle: Text("| Admitted: ${patient.admissionDate}"),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              patient.status,
              style: TextStyle(
                color: patient.status == "Active" ? Colors.green : Colors.grey,
              ),
            ),
            const SizedBox(width: 8),
            PopupMenuButton<String>(
              onSelected: (value) async {
                if (value == 'toggle') {
                  await controller.togglePatientStatus(patient);
                } else if (value == 'view') {
                  viewPatientDetails(context, patient, (message) {
                    showSuccessSnackBar(context, message);
                  });
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
}
