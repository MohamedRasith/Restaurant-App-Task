import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:zartek_task/providers/cart_provider.dart';
import 'package:zartek_task/providers/dishes_provider.dart';
import 'package:zartek_task/view/authentication_methods.dart';
import 'package:zartek_task/view/checkout_screen.dart';
import 'package:zartek_task/view/phone_auth.dart';
import 'package:zartek_task/view/user_home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp();
  runApp(const MyApp());
}



class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  User? user;

  @override
  void initState() {
    super.initState();
    checkAuthStatus();
  }

  void checkAuthStatus() async {
    FirebaseAuth.instance.authStateChanges().listen((User? currentUser) {
      setState(() {
        user = currentUser;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<DishesProvider>(
            create: (context) => DishesProvider()),
        ChangeNotifierProvider<CartProvider>(
            create: (context) => CartProvider())
      ],
      child: ScreenUtilInit(
          designSize: const Size(392.72, 850.90),
          minTextAdapt: true,
          builder: (BuildContext context, Widget? child) {
            Widget screenToDisplay;

            if (user == null) {
              screenToDisplay = const ScreenAuthentication();
            } else {
              screenToDisplay = const ScreenUserHome();
            }

            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Restaurant App',
              theme: ThemeData(
                colorSchemeSeed: const Color(0xFF4CAC52),
                useMaterial3: true,
              ),
              routes: {
                '/homeScreen': (BuildContext ctx) => const ScreenUserHome(),
                '/phoneAuth': (BuildContext ctx) => const PhoneAuthentication(),
                '/checkoutScreen': (BuildContext ctx) => const ScreenCheckout(),
              },
              home: screenToDisplay,
            );
          }),
    );
  }
}
