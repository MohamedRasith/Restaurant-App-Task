import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:zartek_task/providers/dishes_provider.dart';

class ScreenAuthentication extends StatefulWidget {
  const ScreenAuthentication({Key? key}) : super(key: key);

  @override
  State<ScreenAuthentication> createState() => _ScreenAuthenticationState();
}

class _ScreenAuthenticationState extends State<ScreenAuthentication> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    //   var loadDishes = Provider.of<DishesProvider>(context, listen: false);
    //   await loadDishes.getDishes(context);
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/logo/Firebase_Logo_Logomark.png'),
            SizedBox(height: 0.2.sh),
            FilledButton(
              style: FilledButton.styleFrom(
                  minimumSize: Size(0.8.sw, 0.07.sh),
                  backgroundColor: Colors.blueAccent),
              child: _isLoading
                  ?   CupertinoActivityIndicator(radius: 15.r,color: Colors.white,)
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const CircleAvatar(
                          foregroundImage: AssetImage(
                            'assets/google-logo.png',
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Text(
                          'Google',
                          style: TextStyle(fontSize: 18.sp),
                        ),
                      ],
                    ),
              onPressed: () async {
                setState(() {
                  _isLoading = true;
                });

                try {
                  final GoogleSignInAccount? googleUser =
                      await GoogleSignIn().signIn();
                  if (googleUser == null) {
                    throw Exception('Failed to sign in with Google.');
                  }
                  final GoogleSignInAuthentication googleAuth =
                      await googleUser.authentication;

                  final AuthCredential credential =
                      GoogleAuthProvider.credential(
                    accessToken: googleAuth.accessToken,
                    idToken: googleAuth.idToken,
                  );

                  await FirebaseAuth.instance.signInWithCredential(credential);


                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(e.toString())),
                  );
                } finally {
                  setState(() {
                    _isLoading = false;
                  });
                }
              },
            ),
            SizedBox(height: 25.h),
            FilledButton(
              style: FilledButton.styleFrom(
                  minimumSize: Size(0.8.sw, 0.07.sh),
                  backgroundColor: Colors.green),
              onPressed: () async {
                Navigator.pushNamed(context, '/phoneAuth');
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset(
                    height: 30.h,
                    width: 30.w,
                    'assets/phone-logo.png',
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    'Phone',
                    style: TextStyle(fontSize: 18.sp),
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
