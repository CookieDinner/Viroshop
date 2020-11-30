import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:viroshop/Utilities/CustomTheme.dart';
import 'package:viroshop/Utilities/Data.dart';
import 'package:viroshop/Views/LoginView.dart';

void main() async{
  Paint.enableDithering = true;
  WidgetsFlutterBinding.ensureInitialized();
  final dbPath = await getApplicationDocumentsDirectory();
  final tempDbPath = await getApplicationDocumentsDirectory();
  Data().dbPath = path.join(dbPath.path, 'local_db.sqlite');
  Data().tempDbPath = tempDbPath.path;
  CustomTheme().setTheme(false);
  runApp(App());
}

class App extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.black,
    ));

    return MaterialApp(
      theme: ThemeData(highlightColor: Colors.blueAccent),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate
      ],
      supportedLocales: [
        const Locale('pl'),
        const Locale('en')
      ],
      routes: {
        '/loginView' : (context) => LoginView(),
      },
      initialRoute: '/loginView',
    );
  }
}