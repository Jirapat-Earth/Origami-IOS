import 'package:http/http.dart' as http;
import 'imports.dart';
import 'dart:ui';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  checkDeviceType();
  runApp(MyApp());
}

bool isAndroid = false;
bool isTablet = false;
bool isIPad = false;
bool isIPhone = false;
Future<void> checkDeviceType() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  // ความกว้างของหน้าจอ
  double screenWidth = window.physicalSize.shortestSide;
  // ความยาวของหน้าจอ
  double screenHeight = window.physicalSize.longestSide;
  if (Platform.isAndroid) {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    if (androidInfo.isPhysicalDevice) {
      print('Android Device: ${androidInfo.model}');
    }
    if (screenWidth > 1440 || screenHeight <= 1900) {
      isAndroid = false;
      isTablet = true;
      print("This Android device is a Tablet");
    } else {
      isAndroid = true;
      isTablet = false;
      print("This Android device is a Phone");
    }
    isIPad = false;
    isIPhone = false;
  } else if (Platform.isIOS) {
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    // เช็คชื่อรุ่นว่าเป็น iPad หรือไม่
    if ((iosInfo.model?.toLowerCase().contains("ipad") ?? false) || screenWidth > 1440 || screenHeight <= 1900) {
      isIPad = true;
      isIPhone = false;
      print("This device is an iPad");
    } else {
      isIPad = false;
      isIPhone = true;
      print("This device is an iPhone");
    }
    isAndroid = false;
    isTablet = false;
  }
  print('$isAndroid , $isTablet , $isIPad , $isIPhone');
  if(isAndroid == true || isIPhone == true){
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    });
  }else{
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   // หมุนหน้าจอเป็นแนวนอนอัตโนมัติและล็อคไว้
    //   SystemChrome.setPreferredOrientations([
    //     DeviceOrientation.landscapeRight,
    //     DeviceOrientation.landscapeLeft,
    //   ]);
    // });
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Origami',
      theme: ThemeData(
        useMaterial3: false,
        // colorScheme: ColorScheme.fromSeed(
        //   seedColor: Theme.of(context).colorScheme.inversePrimary,
        //   brightness: Brightness.light,
        // ),
        textTheme: TextTheme(
          displayLarge: GoogleFonts.openSans(
            fontSize: 72,
            fontWeight: FontWeight.bold,
          ),
          //GoogleFonts.oswald
          titleLarge: GoogleFonts.openSans(
            fontSize: 28,
          ),
        ),
      ),
      home: LoginPage(num: 0, popPage: 0,),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
