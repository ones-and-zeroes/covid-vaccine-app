import 'package:covidvaccineapp/screens/UserDetails.dart';
import 'package:covidvaccineapp/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import './screens/Signin_up.dart';
import './screens/navigation.dart';
import './screens/HomeScreen.dart';
import './screens/covid_details.dart';
import './screens/user_profile.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]).then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarDividerColor: Colors.grey,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));

    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color(0xFF473F97),
        accentColor: Color(0xFFa37eba),
        textTheme: GoogleFonts.montserratTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: SplashScreenController(),
      debugShowCheckedModeBanner: false,
      routes: {
        HomeScreen.routeName: (ctx) => HomeScreen(),
        NavigationHomeScreen.routeName: (ctx) => NavigationHomeScreen(),
        UserDetailsStepper.routeName: (ctx) => UserDetailsStepper(),
        Sign.routeName: (ctx) => Sign(),
        CovidDetailsPage.routeName: (ctx) => CovidDetailsPage(),
        UserProfile.routeName: (ctx) => UserProfile(),
      },
    );
  }
}
