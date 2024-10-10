import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healpath/src/features/authentication/controllers/sign_up_controller.dart';
import 'package:intl/intl.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _controller = Get.put(SignUpController());
  final _formKey = GlobalKey<FormState>();
  String _fullName = '';
  String _email = '';
  String _phone = '';
  String _password = '';
  DateTime? _dateOfBirth;
  String _gender = '';
  PlatformFile? _file;

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        _file = result.files.single;
        _controller.selectedFileName.value = _file!.name;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _dateOfBirth) {
      setState(() {
        _dateOfBirth = picked;
      });
    }
  }

  bool _isAgeAbove18() {
    if (_dateOfBirth == null) return false;
    final age = DateTime.now().difference(_dateOfBirth!).inDays ~/ 365;
    return age >= 18;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Full Names Field
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.person_outline_outlined),
                    labelText: "Full Name",
                    hintText: "Names",
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? "Please enter your full name" : null,
                  onSaved: (value) => _fullName = value!,
                ),
                const SizedBox(height: 5),
                const Text(
                  "For added privacy, you can provide a nickname instead",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Email Field
            TextFormField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.email_outlined),
                labelText: "Email",
                hintText: "email",
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              ),
              validator: (value) =>
                  !value!.contains('@') ? "Enter a valid email" : null,
              onSaved: (value) => _email = value!,
            ),
            const SizedBox(height: 30),

            // Phone Field
            TextFormField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.phone),
                labelText: "Phone Number",
                hintText: "07-8000-0000",
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              ),
              validator: (value) =>
                  value!.length < 10 ? "Enter a valid phone number" : null,
              onSaved: (value) => _phone = value!,
            ),
            const SizedBox(height: 30),

            // Gender Field
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.person),
                labelText: "Gender",
                border: OutlineInputBorder(),
              ),
              value: _gender.isEmpty ? null : _gender,
              items: ["Male", "Female"].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _gender = newValue!;
                });
              },
              validator: (value) =>
                  value == null ? "Please select a gender" : null,
            ),
            const SizedBox(height: 20),

            // Date of Birth Field
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () => _selectDate(context),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.calendar_today),
                      labelText: "Date of Birth",
                      border: OutlineInputBorder(),
                    ),
                    child: Text(
                      _dateOfBirth == null
                          ? "Select Date"
                          : DateFormat('yyyy-MM-dd').format(_dateOfBirth!),
                    ),
                  ),
                ),
                if (_dateOfBirth != null && !_isAgeAbove18())
                  Text(
                    "You must be at least 18 years old to sign up.",
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
              ],
            ),
            const SizedBox(height: 20),

            // File Upload Field
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(0),
                        ),
                        child: IconButton(
                          onPressed: _pickFile,
                          icon: const Icon(Icons.upload_file),
                          tooltip: "Choose File",
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Obx(() => Text(
                                _controller.selectedFileName.value.isEmpty
                                    ? "Upload Discharge Summary"
                                    : _controller.selectedFileName.value,
                                style: TextStyle(color: Colors.grey[600]),
                                overflow: TextOverflow.ellipsis,
                              )),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "This is a document that the hospital gave you when you left. It contains important information about your stay and any follow-up care.",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Password Field
            Obx(() => TextFormField(
                  obscureText: !_controller.isPasswordVisible.value,
                  decoration: InputDecoration(
                    labelText: "Password",
                    hintText: "password",
                    border: const OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                    suffixIcon: IconButton(
                      onPressed: () => _controller.isPasswordVisible.toggle(),
                      icon: Icon(
                        _controller.isPasswordVisible.value
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                    ),
                  ),
                  validator: (value) =>
                      value!.length < 6 ? "Password too short" : null,
                  onSaved: (value) => _password = value!,
                )),
            const SizedBox(height: 30),

            // SignUp button
            SizedBox(
              width: double.infinity,
              child: Obx(() => ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        _controller.signUpPatient(_email, _password, _fullName,
                            _phone, _dateOfBirth!, _gender, _file);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)),
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: _controller.isLoading.value
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text("SIGNUP"),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
