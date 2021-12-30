import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lr_challenge/UI/splash_screen.dart';
import 'package:lr_challenge/services/authentication_provider.dart';
import 'package:lr_challenge/services/firestore_provider.dart';
import 'package:lr_challenge/utils/adapt.dart';
import 'package:lr_challenge/utils/hexcolor.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(ReNest());
}

class ReNest extends StatelessWidget {
  const ReNest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthenticationProvider>(
          create: (_) => AuthenticationProvider(
            firebaseAuth: FirebaseAuth.instance,
            firestore: FirebaseFirestore.instance,
          ),
        ),
        Provider<FirestoreProvider>(
          create: (_) => FirestoreProvider(
            FirebaseFirestore.instance,
            FirebaseAuth.instance,
          ),
        ),
      ],
      child: MaterialApp(
        home: SplashScreen(),
        theme: ThemeData(
            textTheme: TextTheme(
              headline1: GoogleFonts.inter(color: HexColor('#32315C'), fontSize: Adapt.px(18)),
              headline2:
                  GoogleFonts.inter(color: HexColor('#32315C'), fontSize: Adapt.px(26), fontWeight: FontWeight.bold),
            ),
            primaryColor: HexColor('32315C')),
      ),
    );
  }
}
