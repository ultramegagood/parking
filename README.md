<!-- This file uses generated code. Visit https://pub.dev/packages/readme_helper for usage information. -->
# parking
Автотұрақ бағдарламасы тұрақ ақысын оңай және жылдам төлеуге мүмкіндік береді
авторизациялау және кэште тарихты сақтау әдісі қолданылады
## Usage

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Firebase желісіне қосылу
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Синглондық сыныптарды тіркеу
  await serviceLocatorSetup()
  // userStore пайдаланушы класының басқару элементтеріне арналған синглон
  final userStore = serviceLocator<UserStore>();
  userStore.init();
  runApp(const MyApp());
}
```

```dart
//Консольге әдемі журналдарды шығаруға арналған тіркеуші
final logger = Logger(
  printer: PrettyPrinter(
    methodCount: 30,
    errorMethodCount: 5,
    colors: true,
    printEmojis: true,
    printTime: true,
  ),
);
```
```dart
final userStore = serviceLocator<UserStore>();
//Қолданбаларға арналған жолдарды жасау
GoRouter routes = GoRouter(
initialLocation: '/auth',
debugLogDiagnostics: true,
routes: [
GoRoute(
path: "/auth",
builder: (context, state) =>  LoginPage(),
redirect: (context, state){
  //егер пайдаланушы бар болса, үйге қайта бағыттаңыз
if(userStore.user != null){
return "/";
}
return null;
}
),

    GoRoute(
      path: "/signup",
      builder: (context, state) => SignUpPage(),
    ),
    GoRoute(path: '/',
      builder: (context, state) => const HomePage(),
      routes: [

        GoRoute(
          path: "payment",
          builder: (context, state) => PaymentPage(),
        ),
      ],
      redirect: (context, state){
        if(userStore.user == null){
          return "/auth";
        }
        return null;
      }
      ,),
],
);
```

 [auth_store.dart](./lib/stores/auth_store.dart) .
