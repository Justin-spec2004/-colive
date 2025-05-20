// import 'dart:nativewrappers/_internal/vm/lib/ffi_native_type_patch.dart';
import 'dart:ui';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localization/flutter_localization.dart';
// import 'package:flutter_localization/flutter_localization.dart';
import 'package:font_change_md/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:font_change_md/localization/locales.dart';
import 'package:font_change_md/localization/translator.dart';
// import 'package:font_change_md/localization/locales.dart';
import 'package:font_change_md/messaging/firebase_msg.dart';
import 'package:font_change_md/view/checking_internet.dart';
import 'package:font_change_md/view/internet_provider.dart';
import 'package:font_change_md/view/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:font_change_md/Login%20Signup/Screen/login.dart';
import 'package:font_change_md/screens/screen1.dart';
import 'package:font_change_md/screens/screen2.dart';
import 'package:font_change_md/screens/screen3.dart';
import 'package:font_change_md/screens/screen4.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'view/language_picker.dart';

final FlutterLocalization localization = FlutterLocalization.instance;

// import 'view/theme_provider.dart';

Future<Widget> _determineStartPage() async {
  final prefs = await SharedPreferences.getInstance();
  final saved = prefs.getString('app_lang');

  if (saved == null) {
    // no language chosen yet
    return const LanguagePicker();
  }

  // language exists → set it and continue
  localization.translate(saved);
  return const SplashScreen();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseAppCheck.instance.activate(
    // You can also use a `ReCaptchaEnterpriseProvider` provider instance as an
    // argument for `webProvider`
    webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
    // Default provider for Android is the Play Integrity provider. You can use the "AndroidProvider" enum to choose
    // your preferred provider. Choose from:
    // 1. Debug provider
    // 2. Safety Net provider
    // 3. Play Integrity provider
    androidProvider: AndroidProvider.playIntegrity,
    // Default provider for iOS/macOS is the Device Check provider. You can use the "AppleProvider" enum to choose
    // your preferred provider. Choose from:
    // 1. Debug provider
    // 2. Device Check provider
    // 3. App Attest provider
    // 4. App Attest provider with fallback to Device Check provider (App Attest provider is only available on iOS 14.0+, macOS 14.0+)
    appleProvider: AppleProvider.appAttest,
  );

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await FirebaseMsg().initFCM();

  await localization.ensureInitialized();

  // Initialize localization
  localization.init(mapLocales: LOCALES, initLanguageCode: 'en');
  localization.onTranslatedLanguage = (Locale? locale) {
    // You can use setState in Stateful widgets to trigger UI updates if needed.
  };

  final startPage = await _determineStartPage();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => InternetProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider())
      ],
      child: MyApp(startPage),
    ),
  );
}

class MyApp extends StatelessWidget {
  final Widget firstPage;
  const MyApp(this.firstPage, {super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      themeMode: themeProvider.themeMode,
      theme: ThemeData(
        // Theme sáng
        brightness: Brightness.light,
        primaryColor: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.black), // Chữ màu đen khi sáng
        ),
        iconTheme: IconThemeData(color: Colors.black), // Icon màu đen khi sáng
      ),
      darkTheme: ThemeData(
        // Theme tối
        brightness: Brightness.dark,
        primaryColor: Colors.black,
        scaffoldBackgroundColor: Colors.black,
        textTheme: TextTheme(
          bodyLarge: TextStyle(
              color: Colors.green,
              fontSize: 20,
              fontWeight: FontWeight.bold), // Chữ màu trắng khi tối
        ),
        iconTheme: IconThemeData(color: Colors.black), // Icon màu trắng khi tối
      ),
      supportedLocales: localization.supportedLocales,
      localizationsDelegates: localization.localizationsDelegates,
      locale: localization.currentLocale, // Bind the current locale
      debugShowCheckedModeBanner: false,
      home: firstPage, // Demonstrating Splash Screen at first
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color.fromARGB(255, 246, 245, 245),
      body: Center(
        child: Text(
          'Écolive',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  PageController pageController = PageController();
  String buttonText = tr(LocaleData.skip);
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer<InternetProvider>(
      builder: (context, internetProvider, child) {
        if (!internetProvider.isConnected) {
          Future.microtask(() {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CheckingInternet()),
            );
          });
        }

        return Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              PageView(
                controller: pageController,
                onPageChanged: (index) {
                  currentPageIndex = index;
                  if (index == 3) {
                    buttonText = tr(LocaleData.finish);
                  } else {
                    buttonText = tr(LocaleData.skip);
                  }
                  setState(() {});
                },
                children: const [
                  Screen1(),
                  Screen2(),
                  Screen3(),
                  Screen4(),
                ],
              ),
              Container(
                alignment: const Alignment(0, 0.8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                        onTap: () {
                          //TODO: Navigate to Home Page
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()),
                          );
                        },
                        child: Text(buttonText)),
                    SmoothPageIndicator(controller: pageController, count: 4),
                    currentPageIndex == 3
                        ? const SizedBox(
                            width: 10,
                          )
                        : GestureDetector(
                            onTap: () {
                              pageController.nextPage(
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeIn);
                            },
                            child: Text(tr(LocaleData.next)))
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
