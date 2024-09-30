import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OverviewController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  RxInt totalPatients = 0.obs;
  RxInt newPatients = 0.obs;
  RxInt activeTreatmentPlans = 0.obs;
  RxDouble completedTreatments = 0.0.obs;
  RxDouble ongoingTreatments = 0.0.obs;
  RxDouble patientSatisfaction = 0.0.obs;
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  Future<void> fetchData() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      // Fetch total patients with role 'patient'
      QuerySnapshot patientsSnapshot = await _firestore
          .collection('users')
          .where('role', isEqualTo: 'patient')
          .get();
      totalPatients.value = patientsSnapshot.size;

      // Fetch new patients (this month) with role 'patient'
      DateTime firstDayOfMonth =
          DateTime(DateTime.now().year, DateTime.now().month, 1);
      QuerySnapshot newPatientsSnapshot = await _firestore
          .collection('users')
          .where('role', isEqualTo: 'patient')
          .where('createdAt', isGreaterThanOrEqualTo: firstDayOfMonth)
          .get();
      newPatients.value = newPatientsSnapshot.size;

      // Fetch active treatment plans of patients with status 'Active'
      QuerySnapshot activePlansSnapshot = await _firestore
          .collection('users')
          .where('status', isEqualTo: 'Active')
          .get();
      activeTreatmentPlans.value = activePlansSnapshot.size;

      // Calculate treatment progress

      // QuerySnapshot allTreatmentsSnapshot =
      //     await _firestore.collection('treatmentPlans').get();
      // int totalTreatments = allTreatmentsSnapshot.size;
      // QuerySnapshot completedTreatmentsSnapshot = await _firestore
      //     .collection('treatmentPlans')
      //     .where('status', isEqualTo: 'completed')
      //     .get();
      // int completedTreatmentsCount = completedTreatmentsSnapshot.size;

      // completedTreatments.value =
      //     totalTreatments > 0 ? completedTreatmentsCount / totalTreatments : 0;
      // ongoingTreatments.value = totalTreatments > 0
      //     ? 1 - (completedTreatmentsCount / totalTreatments)
      //     : 0;

      // Calculate patient satisfaction from 'users' collection where role is 'patient'

      // QuerySnapshot satisfactionSnapshot = await _firestore
      //     .collection('users')
      //     .where('role', isEqualTo: 'patient')
      //     .get();
      // double totalSatisfaction = 0;
      // for (var doc in satisfactionSnapshot.docs) {
      //   totalSatisfaction +=
      //       (doc.data() as Map<String, dynamic>)['satisfaction'] ?? 0;
      // }
      // patientSatisfaction.value = satisfactionSnapshot.size > 0
      //     ? totalSatisfaction / satisfactionSnapshot.size
      //     : 0;
    } catch (e) {
      errorMessage.value = 'Error fetching data: $e';
    } finally {
      isLoading.value = false;
    }
  }
}

class OverviewTab extends StatelessWidget {
  final OverviewController controller = Get.put(OverviewController());

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          const TabBar(
            tabs: [
              Tab(text: 'Status'),
              Tab(text: 'Progress'),
            ],
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.grey,
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: controller.fetchData,
              child: Obx(() {
                if (controller.isLoading.value) {
                  return Center(child: CircularProgressIndicator());
                } else if (controller.errorMessage.isNotEmpty) {
                  return Center(child: Text(controller.errorMessage.value));
                } else {
                  return TabBarView(
                    children: [
                      _buildPatientStats(),
                      _buildTreatmentProgress(),
                    ],
                  );
                }
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPatientStats() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(() => _buildStatCard('Total Patients',
              controller.totalPatients.toString(), Icons.people, Colors.blue)),
          const SizedBox(height: 16),
          Obx(() => _buildStatCard(
              'New Patients (This Month)',
              controller.newPatients.toString(),
              Icons.person_add,
              Colors.green)),
          const SizedBox(height: 16),
          Obx(() => _buildStatCard(
              'Active Treatment Plans',
              controller.activeTreatmentPlans.toString(),
              Icons.healing,
              Colors.orange)),
        ],
      ),
    );
  }

  Widget _buildTreatmentProgress() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(() => _buildProgressCard(
              'Completed Treatments', controller.completedTreatments.value)),
          const SizedBox(height: 16),
          Obx(() => _buildProgressCard(
              'Ongoing Treatments', controller.ongoingTreatments.value)),
          const SizedBox(height: 16),
          Obx(() => _buildProgressCard(
              'Patient Satisfaction', controller.patientSatisfaction.value)),
        ],
      ),
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, size: 48, color: color),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                Text(value,
                    style: TextStyle(
                        fontSize: 24,
                        color: color,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressCard(String title, double progress) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: Colors.grey[300],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
            const SizedBox(height: 8),
            Text('${(progress * 100).toInt()}%',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
