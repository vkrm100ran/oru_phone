import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:oru_phones/screens/auth/nameConfirmationScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OtpVerificationScreen extends StatefulWidget {
  static const String routeName = "otp-screen";
  final String mobileNumber;

  OtpVerificationScreen({required this.mobileNumber});

  @override
  _OtpVerificationScreenState createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final http.Client _client = http.Client();
  List<TextEditingController> otpControllers =
      List.generate(4, (index) => TextEditingController());
  int _secondsRemaining = 30;
  bool _enableResend = false;
  Timer? _timer;
  bool _isLoading = false;
  static const String baseUrl = "http://40.90.224.241:5000";

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        setState(() => _enableResend = true);
        _timer?.cancel();
      }
    });
  }

  Future<void> _verifyOtp() async {
    String otpCode = otpControllers.map((c) => c.text).join();
    if (otpCode.length < 4) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Please enter a valid 4-digit OTP")));
      return;
    }

    setState(() => _isLoading = true);
    final url = Uri.parse("$baseUrl/login/otpValidate");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "countryCode": 91,
        "mobileNumber": int.parse(widget.mobileNumber),
        "otp": int.parse(otpCode),
      }),
    );

    setState(() => _isLoading = false);
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("OTP Verified Successfully")));

      // Fetch session cookies
      final cookies = response.headers['set-cookie'];
      if (cookies != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("sessionCookie", cookies); // Store cookie
        print("Session Cookie Stored: $cookies");
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => NameConfirmationScreen()), (route) => false);
       }
        else {
        print("No session cookie found.");
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Invalid OTP, please try again")));
    }
  }

  Future<void> _resendOtp() async {
    setState(() {
      _secondsRemaining = 30;
      _enableResend = false;
    });
    _startTimer();

    try {
      final response = await _client.post(
        Uri.parse("$baseUrl/login/otpCreate"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "countryCode": 91,
          "mobileNumber": int.parse(widget.mobileNumber),
        }),
      );

      final responseData = jsonDecode(response.body);
      if (response.statusCode == 200 && responseData['status'] == "success") {
        _showSnackbar("OTP Resent Successfully");
      } else {
        _showSnackbar("Failed to resend OTP: ${responseData['message']}");
      }
    } catch (e) {
      _showSnackbar("Error resending OTP: $e");
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    otpControllers.forEach((controller) => controller.dispose());
    _client.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo.png', height: 60),
            SizedBox(height: 20),
            Text('Verify Mobile No.',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo)),
            SizedBox(height: 10),
            Text(
              'Please enter the 4-digit verification code sent to your mobile number +91-${widget.mobileNumber} via SMS',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(4, (index) {
                return SizedBox(
                  width: 50,
                  child: TextField(
                    controller: otpControllers[index],
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    maxLength: 1,
                    decoration: InputDecoration(counterText: ''),
                    onChanged: (value) {
                      if (value.isNotEmpty && index < 3) {
                        FocusScope.of(context).nextFocus();
                      }
                    },
                  ),
                );
              }),
            ),
            SizedBox(height: 20),
            Text(
              _enableResend
                  ? 'Didn’t receive OTP? '
                  : 'Resend OTP in 0:${_secondsRemaining.toString().padLeft(2, '0')} Sec',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            if (_enableResend)
              TextButton(
                onPressed: _resendOtp,
                child: Text('Resend OTP',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _verifyOtp,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                minimumSize: Size(double.infinity, 50),
              ),
              child: _isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text('Verify OTP', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
