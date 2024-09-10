import 'package:flutter/material.dart';

class SignUpForm extends StatelessWidget {
  const SignUpForm({
    super.key,
  });

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

            // ------------Password Field-------------------
            SizedBox(
              height: 50,
              child: TextFormField(
                decoration: const InputDecoration(
                  labelText: "Password",
                  hintText: "password",
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                      onPressed: null, icon: Icon(Icons.remove_red_eye)),
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
