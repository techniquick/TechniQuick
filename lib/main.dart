import 'dart:convert';
import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/constant.dart';
import 'core/util/app_location.dart';
import 'core/util/navigator.dart';
import 'core/util/size_config.dart';
import 'core/util/styles.dart';
import 'core/util/toast.dart';
import 'firebase/auth/auth_stream.dart';
import 'injection.dart';
import 'model/user.dart';
import 'presentation/bottom_bar.dart';
import 'presentation/cubit_controller/auth/login/login_cubit.dart';
import 'presentation/cubit_controller/auth/nav_bar/bottom_nav_bar_cubit.dart';
import 'presentation/cubit_controller/auth/register/register_cubit.dart';
import 'presentation/cubit_controller/my_orders/my_orders_cubit.dart';
import 'presentation/cubit_controller/rate/rate_cubit.dart';
import 'presentation/cubit_controller/supplier/add_supplies/add_supplies_cubit.dart';
import 'presentation/pages/auth/role_screen.dart';
import 'presentation/pages/auth/splash_screen.dart';
import 'presentation/widgets/rate.dart';

FirebaseApp? firebaseApp;
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//  await Firebase.initializeApp();

  log("_messaging onBackgroundMessage: $message");
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;
  var initialzationSettingsAndroid =
      const AndroidInitializationSettings('logo');
  const DarwinInitializationSettings initializationSettingsIOS =
      DarwinInitializationSettings();
  var initializationSettings = InitializationSettings(
      android: initialzationSettingsAndroid, iOS: initializationSettingsIOS);
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  log("_messaging onBackgroundMessage: $message");

  if (notification != null && android != null) {
    flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            icon: android.smallIcon,
            priority: Priority.max,
            enableLights: true,
            playSound: true,
          ),
        ));
  }
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  description:
      'This channel is used for important notifications.', // description
  importance: Importance.high,
);
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
//  GetNewBackgroundOffers.box = await Hive.openBox('myBox');
  firebaseApp = await Firebase.initializeApp();
  init();
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  await EasyLocalization.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('ar'), Locale('en')],
      path: "assets/translate",
      saveLocale: true,
      useOnlyLangCode: true,
      startLocale: const Locale('en'),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<BottomBarCubit>(
          create: (BuildContext context) => sl<BottomBarCubit>(),
        ),
        BlocProvider<RegisterCubit>(
          create: (context) => RegisterCubit(),
        ),
        BlocProvider<RateCubit>(
          create: (context) => RateCubit(),
        ),
        BlocProvider<LoginCubit>(
          create: (context) => LoginCubit(),
        ),
        BlocProvider<ControlSuppliesCubit>(
          create: (context) => ControlSuppliesCubit(),
        ),
        BlocProvider<MyOrdersCubit>(
          create: (context) => MyOrdersCubit(),
        ),
      ],
      child: MaterialApp(
          title: 'Techni Quick',
          navigatorKey: sl<AppNavigator>().navigatorKey,
          debugShowCheckedModeBanner: false,
          debugShowMaterialGrid: false,
          theme: myTheme,
          locale: context.locale,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          home: Builder(builder: (context) {
            ScreenUtil.init(context, designSize: const Size(428, 926));
            SizeConfig().init(context);
            return GestureDetector(
                onTap: () {
                  FocusScopeNode currentFocus = FocusScope.of(context);

                  if (!currentFocus.hasPrimaryFocus) {
                    FocusScope.of(context).unfocus();
                  }
                },
                child: const NotificationsHndler());
          })),
    );
  }
}

class NotificationsHndler extends StatefulWidget {
  const NotificationsHndler({super.key});

  @override
  State<NotificationsHndler> createState() => _NotificationsHndlerState();
}

class _NotificationsHndlerState extends State<NotificationsHndler> {
  @override
  void initState() {
    super.initState();
    var initialzationSettingsAndroid =
        const AndroidInitializationSettings('logo');
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings();
    var initializationSettings = InitializationSettings(
        android: initialzationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (payload) async {},
    );

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessageOpenedApp
        .listen((RemoteMessage message) async {});
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log("FirebaseMessaging$message");
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: channel.description,
                icon: android.smallIcon,
                priority: Priority.max,
                enableLights: true,
                playSound: true,
              ),
            ),
            payload: jsonEncode(message.data));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    DateTime? currentBackPressTime;
    return WillPopScope(
        onWillPop: () async {
          DateTime now = DateTime.now();
          if (currentBackPressTime == null ||
              now.difference(currentBackPressTime!) >
                  const Duration(seconds: 2)) {
            currentBackPressTime = now;
            showToast(
              tr('click_again_to_exit'),
            );
            return Future.value(false);
          }
          return Future.value(true);
        },
        child: const TechniQuick());
  }
}

class TechniQuick extends StatefulWidget {
  const TechniQuick({Key? key}) : super(key: key);

  @override
  State<TechniQuick> createState() => _TechniQuickState();
}

class _TechniQuickState extends State<TechniQuick> {
  @override
  void initState() {
    super.initState();
    sl<AppLocation>().determinePosition();
    Future.microtask(() {
      sl<FirebaseAuth>().setLanguageCode(context.locale.languageCode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting &&
              !snapshot.hasData) {
            return const SplashScreen();
          }
          if (snapshot.data == null) {
            return const RoleScreen();
          } else {
            return StreamBuilder<BaseUser>(
                //@Test123
                stream: getUserData(snapshot.data!.uid),
                builder: (context, sh) {
                  if (sh.data == null) {
                    return const SplashScreen();
                  }
                  // if (!snapshot.data!.emailVerified) {
                  //   return VerfiyAccountScreen(data: snapshot.data);
                  // }
                  final baseUser = sh.data!;
                  return Layout(
                    user: baseUser,
                  );
                });
          }
        });
  }
}

class VerfiyAccountScreen extends StatefulWidget {
  const VerfiyAccountScreen({super.key, this.data});
  final User? data;

  @override
  State<VerfiyAccountScreen> createState() => _VerfiyAccountScreenState();
}

class _VerfiyAccountScreenState extends State<VerfiyAccountScreen> {
  @override
  void initState() {
    super.initState();

    widget.data!.sendEmailVerification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AppDialog(
                      title: tr("are_you_sure"),
                      function: () async {
                        sl<AppNavigator>().popToFrist();
                        await sl<FirebaseAuth>().signOut();
                      }),
                );
              },
              icon: const Icon(
                Icons.logout,
                color: white,
              )),
        ],
      ),
      body: SizedBox(
        height: double.infinity,
        child: Stack(
          children: [
            Material(
              elevation: 5,
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(40),
                bottomLeft: Radius.circular(40),
              ),
              child: Container(
                height: 200,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: mainColor,
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(40),
                    bottomLeft: Radius.circular(40),
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16.0),
              margin: const EdgeInsets.only(top: 120),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Material(
                    elevation: 10,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.all(15.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            tr("check_email_ver"),
                            textAlign: TextAlign.center,
                            style: TextStyles.bodyText18,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
