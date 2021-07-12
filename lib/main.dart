
import 'package:firebase_core/firebase_core.dart';
import 'package:deus_mobile/service/analytics_service.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'config.dart';
import 'core/widgets/default_screen/will_pop_dialog.dart';
import 'locator.dart';
import 'routes/route_generator.dart';
import 'screens/splash/cubit/splash_cubit.dart';
import 'screens/splash/splash_screen.dart';
import 'service/config_service.dart';
import 'statics/styles.dart';

void deusDebugPrint(String? s, {int? wrapWidth}) {
  if (AppConfig.selectedConfig.showDebugMessages) print(s);
}

class SimpleBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    print(event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    print(error);
    super.onError(bloc, error, stackTrace);
  }
}

void main() async {
  Bloc.observer = SimpleBlocObserver();
  debugPrint = deusDebugPrint;
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  // await Firebase.initializeApp();

  setupLocator();
  runApp(BlocProvider<SplashCubit>(create: (_) => SplashCubit(), child: DEUSApp()));
}

class DEUSApp extends StatefulWidget {
  const DEUSApp({Key? key}) : super(key: key);

  @override
  _DEUSAppState createState() => _DEUSAppState();
}

class _DEUSAppState extends State<DEUSApp> {
  Future<bool>? initializeData;
  final GlobalKey _appKey = GlobalKey();
  final GlobalKey _loadingKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    initializeData = context.read<SplashCubit>().initializeData();
  }

  @override
  Widget build(BuildContext ctx) {
    return BlocBuilder<SplashCubit, SplashState>(builder: (context, state) {
      // at the beginning, show a splash screen, when the data hasn't been loaded yet.
      return FutureBuilder(
        future: initializeData,
        builder: (context, snapshot) {
          if (!(state is SplashSuccess))
            return MaterialApp(
                key: _loadingKey, debugShowCheckedModeBanner: false, theme: MyStyles.theme, home: SplashScreen());

          return MaterialApp(
            key: _appKey,
            navigatorObservers: [locator<AnalyticsService>().observer],
            title: 'Deus Finance',
            debugShowCheckedModeBanner: false,
            theme: MyStyles.theme,
            onGenerateRoute: (settings) => onGenerateRoute(settings, context),
            initialRoute: kInitialRoute,
          );
        },
      );
    });
  }
}
