import 'package:flutter/material.dart';
import 'package:iframemobile/core/provider/iframe_connection_provider.dart';
import 'package:iframemobile/widgets/onboarding_screen.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/provider/connection_checker.dart';
import 'widgets/homepage.dart';
import 'widgets/no_internet_connection.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
   final isFirstLaunch = await checkFirstLaunch();
  await EasyLocalization.ensureInitialized();
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('tr')],
      path: 'assets/langs', // JSON dosyalarının yolu
      fallbackLocale: const Locale('en'),
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => ConnectionControlProvider(),
          ),
          ChangeNotifierProvider(
            create: (context) => ConnectionIframeAppProvider(),
          ),
        ],
        child: IframeApp(isFirstLaunch: isFirstLaunch), // Burada child parametresini ekliyoruz
      ),
    ),
  );
}
Future<bool> checkFirstLaunch() async {
  final prefs = await SharedPreferences.getInstance();
  bool? isFirstLaunch = prefs.getBool('isFirstLaunch');
  if (isFirstLaunch == null || isFirstLaunch) {
    await prefs.setBool('isFirstLaunch', false);
    return true;
  }
  return false;
}

class IframeApp extends StatelessWidget {
   final bool isFirstLaunch;
  const IframeApp({super.key, required this.isFirstLaunch});

  @override
  Widget build(BuildContext context) {
    return Consumer<ConnectionControlProvider>(
      builder: (context, connectionProvider, child) {
        return MaterialApp(
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          title: tr('appTitle'),
          theme: ThemeData(
            useMaterial3: true,
            colorSchemeSeed: const Color(0x9f4376f8),
          ),
          locale: context.locale, // Dil ayarı
          supportedLocales: context.supportedLocales,
          localizationsDelegates: context.localizationDelegates,
          home: connectionProvider.connectionStatus
                  .contains(ConnectivityResult.none)
              ? const NoInternetConnection()
              : isFirstLaunch ? const OnboardingScreen() : const Homepage(),
        );
      },
    );
  }
}
