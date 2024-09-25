import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({
    super.key,
  });

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  bool _isPasswordVisible = false;
  String? _fileName;

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        _fileName = result.files.single.name;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ------------Full Names Field-------------------
            Column(
              crossAxisAlignment: CrossAxisAlignment
                  .start, // Aligns text to the start of the column
              children: [
                SizedBox(
                  height: 50,
                  child: TextFormField(
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.person_outline_outlined),
                      labelText: "Full Name",
                      hintText: "Names",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                // Adds a small space between the field and the text
                const Text(
                  "For added privacy, you can provide a nickname instead",
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey), // Adjust the style if needed
                ),
              ],
            ),

            const SizedBox(height: 20),

            // ------------Email Field-------------------
            SizedBox(
              height: 50,
              child: TextFormField(
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.email_outlined),
                  labelText: "Email",
                  hintText: "email",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 30),

            // ------------Phone Field-------------------
            SizedBox(
              height: 50,
              child: TextFormField(
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.phone),
                  labelText: "Phone Number",
                  hintText: "07-8000-0000",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 30),

            // ------------File Upload Field-------------------
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
                          padding: const EdgeInsets.symmetric(horizontal: 0),
                          child: Text(
                            _fileName ?? "Upload Discharge Summary",
                            style: TextStyle(color: Colors.grey[600]),
                            overflow: TextOverflow.ellipsis,
                          ),
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

            // ------------Password Field-------------------
            SizedBox(
              height: 50,
              child: TextFormField(
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  labelText: "Password",
                  hintText: "password",
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            // ------------SignUp button-------------------
            SizedBox(
              width: double.infinity,
              height: 47,
              child: ElevatedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    shape: const RoundedRectangleBorder(),
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue,
                    side: const BorderSide(color: Colors.blue),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: const Text("SIGNUP")),
            )
          ],
        ),
      ),
    );
  }
}
