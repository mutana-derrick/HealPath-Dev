import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healpath/src/features/patient/controllers/patient_onboarding_controller.dart';

class PatientOnboardingScreen extends StatelessWidget {
  final OnboardingController controller = Get.put(OnboardingController());

  PatientOnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(() => Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: PageView(
                    controller: controller.pageController,
                    onPageChanged: (index) =>
                        controller.currentStep.value = index,
                    children: [
                      _buildAgeStep(),
                      _buildGenderStep(),
                      _buildDrugChoiceStep(),
                      _buildInjectionFrequencyStep(),
                      _buildHIVStatusStep(),
                      _buildNeedleSharingStep(),
                    ],
                  ),
                ),
                _buildNavigation(),
              ],
            )),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            'Getting to Know You',
            style: GoogleFonts.poppins(
              fontSize: 24,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 8),
          LinearProgressIndicator(
            value: (controller.currentStep.value + 1) / 6,
            backgroundColor: Colors.blue[100],
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
        ],
      ),
    );
  }

  Widget _buildAgeStep() {
    return _buildStepContainer(
      title: 'How old are you?',
      content: TextField(
        keyboardType: TextInputType.number,
        style: TextStyle(fontSize: 18),
        decoration: InputDecoration(
          labelText: 'Enter your age',
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.cake, color: Colors.blue),
        ),
        onChanged: (value) => controller.age.value = value,
      ),
      animation: 'assets/animations/animation.json',
    );
  }

  Widget _buildGenderStep() {
    return _buildStepContainer(
      title: 'What\'s your gender?',
      content: DropdownButtonFormField<String>(
        value: controller.gender.value.isEmpty ? null : controller.gender.value,
        hint: Text('Select gender'),
        items: ['Male', 'Female', 'Other'].map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (value) => controller.gender.value = value!,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.person, color: Colors.blue),
        ),
      ),
      animation: 'assets/animations/animation.json',
    );
  }

  Widget _buildDrugChoiceStep() {
    return _buildStepContainer(
      title: 'Primary drug of choice',
      content: DropdownButtonFormField<String>(
        value: controller.drugOfChoice.value.isEmpty
            ? null
            : controller.drugOfChoice.value,
        hint: Text('Select primary drug'),
        items: ['Heroin', 'Cocaine', 'Marijuana', 'Beer', 'Other']
            .map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (value) => controller.drugOfChoice.value = value!,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.local_pharmacy, color: Colors.blue),
        ),
      ),
      animation: 'assets/animations/animation.json',
    );
  }

  Widget _buildInjectionFrequencyStep() {
    return _buildStepContainer(
      title: 'How often do you inject?',
      content: DropdownButtonFormField<String>(
        value: controller.injectionFrequency.value.isEmpty
            ? null
            : controller.injectionFrequency.value,
        hint: Text('Select frequency'),
        items:
            ['Daily', 'Weekly', 'Monthly', 'Occasionally'].map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (value) => controller.injectionFrequency.value = value!,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.calendar_today, color: Colors.blue),
        ),
      ),
      animation: 'assets/animations/animation.json',
    );
  }

  Widget _buildHIVStatusStep() {
    return _buildStepContainer(
      title: 'What\'s your HIV status?',
      content: DropdownButtonFormField<String>(
        value: controller.hivStatus.value.isEmpty
            ? null
            : controller.hivStatus.value,
        hint: Text('Select HIV status'),
        items: ['Positive', 'Negative', 'Unknown'].map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (value) => controller.hivStatus.value = value!,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.favorite, color: Colors.blue),
        ),
      ),
      animation: 'assets/animations/animation.json',
    );
  }

  Widget _buildNeedleSharingStep() {
    return _buildStepContainer(
      title: 'Needle sharing history',
      content: DropdownButtonFormField<String>(
        value: controller.needleSharingHistory.value.isEmpty
            ? null
            : controller.needleSharingHistory.value,
        hint: Text('Needle sharing history'),
        items: ['Never', 'In the past', 'Currently'].map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (value) => controller.needleSharingHistory.value = value!,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.security, color: Colors.blue),
        ),
      ),
      animation: 'assets/animations/animation.json',
    );
  }

  Widget _buildStepContainer(
      {required String title,
      required Widget content,
      required String animation}) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              animation,
              width: 200,
              height: 200,
            ),
            SizedBox(height: 24),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.normal,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24),
            content,
          ],
        ),
      ),
    );
  }

  Widget _buildNavigation() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // "Back" button styled as an OutlinedButton
          Expanded(
            child: OutlinedButton(
              onPressed: controller.currentStep.value > 0
                  ? () => controller.pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      )
                  : null,
              style: OutlinedButton.styleFrom(
                shape: const RoundedRectangleBorder(),
                foregroundColor: Colors.blue,
                side: const BorderSide(color: Colors.blue),
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              child: const Text('Back'),
            ),
          ),
          const SizedBox(width: 10),
          // "Next" or "Submit" button styled as an ElevatedButton
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                if (controller.currentStep.value < 5) {
                  controller.pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                } else {
                  controller.submitOnboardingData();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: const RoundedRectangleBorder(),
                padding: const EdgeInsets.symmetric(vertical: 15),
                foregroundColor: Colors.white,
                side: const BorderSide(color: Colors.blue),
              ),
              child: Text(
                controller.currentStep.value == 5 ? 'Submit' : 'Next',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
