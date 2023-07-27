import 'dart:async';


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:zartek_task/widgets/otp_counter.dart';



class PhoneAuthentication extends StatefulWidget {
  const PhoneAuthentication({Key? key}) : super(key: key);

  @override
  State<PhoneAuthentication> createState() => _PhoneAuthenticationState();
}

class _PhoneAuthenticationState extends State<PhoneAuthentication> {
  Timer? _timer;
  bool _isLoading =false;
  bool _isTimerRunning = false;
  final _formKey = GlobalKey<FormState>();
  RegExp numberRegExp = RegExp(r'^(?:[+][91])?\d{10,12}$');

  final _phoneNumberController = TextEditingController();
  final _smsCodeController = TextEditingController();
  late String _verificationId;

  Future<void> _verifyPhoneNumber() async {
    final String phoneNumber = _phoneNumberController.text.trim();
    final String formattedPhoneNumber = "+91$phoneNumber";

    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: formattedPhoneNumber,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {

        },
        verificationFailed: (FirebaseAuthException e) {
          if (e.code == 'invalid-phone-number') {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('The provided phone number is not valid.')),
            );
          }
        },
        codeSent: (String verificationId, int? resendToken) {
          setState(() {
            _verificationId = verificationId;
            _isTimerRunning = true;
          });
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Code retrieval timed out. Please try again.')),
          );
        },
      );
    } catch (e) {
      print('Failed to verify phone number: $e');
    }
  }

  Future<void> _verifyOTP() async {
    setState(() {
      _isLoading = true;
    });

    final String smsCode = _smsCodeController.text.trim();
    final PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: _verificationId,
      smsCode: smsCode,
    );

    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
      Navigator.pushReplacementNamed(context, '/homeScreen');


    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to sign in: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
        _isTimerRunning = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              child: Image.asset("assets/login.png",
                  fit: BoxFit.fitWidth, height: 297.815.h),
            ),
            Padding(
              padding: EdgeInsets.only(left: 25.w),
              child: Text(
                "Login",
                style: TextStyle(
                  fontSize: 30.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 25.52.h,
            ),
            Form(
              key: _formKey,
              child: Column(children: [
                Padding(
                    padding: EdgeInsets.only(left: 20.w, right: 20.w),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _phoneNumberController,
                          maxLength: 10,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                              counter: _isTimerRunning
                                  ? CountdownTimer(
                                      duration: const Duration(seconds: 60),
                                      onTimerFinished: () {
                                        setState(() {
                                          _isTimerRunning = false;
                                        });
                                      },
                                    )
                                  : null,
                              prefixIcon: const Icon(
                                Icons.phone_android,
                              ),
                              suffix: TextButton(
                                  onPressed: _verifyPhoneNumber,
                                  child: const Text('Send OTP')),
                              hintText: 'Mobile number'),
                          validator: (number) {
                            if (number!.isNotEmpty &&
                                numberRegExp.hasMatch(number)) {
                              return null;
                            }
                            return 'Please enter a valid mobile number';
                          },
                        ),
                        SizedBox(height: 15.h),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          controller: _smsCodeController,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(
                              Icons.lock,
                            ),
                            hintText: 'OTP',
                          ),
                          validator: (password) {
                            if (password!.isNotEmpty) {
                              return null;
                            }
                            return 'Please enter the otp';
                          },
                        )
                      ],
                    )),
                SizedBox(height: 5.h),
              ]),
            ),
            SizedBox(
              height: 34.036.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.20.w),
              child: FilledButton(
                onPressed: (){
                  if (_formKey.currentState!.validate()) {
                     _verifyOTP();
                  }
                },
                style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0.r)),
                    minimumSize: Size(357.w, 47.h)),
                child: _isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : Text(
                        "Login",
                        style: TextStyle(
                          fontSize: 20.sp,
                        ),
                      ),
              ),
            ),
            SizedBox(height: 34.036.h),
          ],
        ),
      )),
    );
  }

  @override
  void dispose() {
    _phoneNumberController.dispose();
    _smsCodeController.dispose();
    // TODO: implement dispose
    super.dispose();
  }
}
