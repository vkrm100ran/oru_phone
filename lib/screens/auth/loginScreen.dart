import 'package:flutter/material.dart';
import 'package:oru_phones/screens/auth/otpScreen.dart';
import 'package:oru_phones/services/api-service.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = "login-screen";
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isChecked = false;
  final TextEditingController _phoneController = TextEditingController();

  Future<void> sendOtp() async {
    String phone = _phoneController.text.trim();
    if (phone.isNotEmpty) {
      bool success = await ApiService.sendOtp("91", phone);
      if (success) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => OtpVerificationScreen(mobileNumber: phone)),
        );
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Failed to send OTP")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Logo
            Image.asset(
              'assets/images/logo.png',
              height: 80,
            ),

            SizedBox(height: 20),

            // Welcome Text
            Text(
              "Welcome",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple[700],
              ),
            ),

            SizedBox(height: 5),


            Text(
              "Sign in to continue",
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),

            SizedBox(height: 30),

            // Phone Number Input
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Enter Your Phone Number",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                hintText: "Mobile Number",
                prefixIcon: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14.0),
                  child: Text(
                    "+91  ",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
                prefixIconConstraints: BoxConstraints(minWidth: 50),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),

            SizedBox(height: 15),

            // Terms and Conditions Checkbox
            Row(
              children: [
                Checkbox(
                  value: isChecked,
                  onChanged: (value) {
                    setState(() {
                      isChecked = value!;
                    });
                  },
                ),
                Text("Accept "),
                GestureDetector(
                  onTap: () {
                    // Navigate to Terms & Conditions Screen
                  },
                  child: Text(
                    "Terms and condition",
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 20),

            // Next Button
            ElevatedButton(
              onPressed: isChecked
                  ? () async {
                      await sendOtp();
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple[700],
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Next",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                  SizedBox(width: 8),
                  Icon(
                    Icons.arrow_forward,
                    size: 22,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
