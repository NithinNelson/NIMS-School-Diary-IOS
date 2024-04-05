import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import './Screens/splash_screen.dart';
import './Provider/user_provider.dart';
import './Screens/home_screen.dart';
import './Screens/forget_password.dart';
import 'Provider/chat_provider.dart';
import 'Screens/login_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        // systemNavigationBarColor: Colors.deepPurple.shade600,
        statusBarColor: Colors.deepPurple.shade600
    ));
    return ScreenUtilInit(
      designSize: Size(360, 690),
      //minTextAdapt: true,
      //splitScreenMode: true,
      builder: (ctx, child) => ChangeNotifierProvider(
        create: (ctx) => UserProvider(),
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (ctx) => UserProvider()),
            ChangeNotifierProvider(create: (ctx) => ChatProvider())
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'NIMS School Diary',
            theme: ThemeData(
              primarySwatch: Colors.purple,
              fontFamily: 'Axiforma',
            ),
            home: SplashScreen(),
            routes: {
              LoginScreen.routeName: (ctx) => LoginScreen(),
              HomeScreen.routeName: (ctx) => HomeScreen(),
              ForgetPassword.routeName: (ctx) =>ForgetPassword()
            },
          ),
        ),
      ),
    );
  }
}
