import 'package:appcenter/appcenter.dart';
import 'package:appcenter_analytics/appcenter_analytics.dart';
import 'package:appcenter_crashes/appcenter_crashes.dart';
import 'package:bflutter/bflutter.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform;
import 'package:flutter/foundation.dart' show TargetPlatform;
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // @nhancv 10/23/2019: Config app center
  final ios = defaultTargetPlatform == TargetPlatform.iOS;
  String appSecret = ios
      ? "4cb4378e-4215-44cf-95ef-00f632f9768d"
      : "7bf597b6-7525-428f-b13e-ba182d3f7972";
  await AppCenter.start(
      appSecret, [AppCenterAnalytics.id, AppCenterCrashes.id]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  final bloc = BlocDefault<int>();

  void _incrementCounter() {
    _counter++;
    bloc.push(_counter);
  }

  @override
  Widget build(BuildContext context) {
    print('build $_counter');
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            EmptyWidget(),
            Text(
              'You have pushed the button this many times:',
            ),
            StreamBuilder(
              stream: bloc.stream,
              initialData: 0,
              builder: (context, snapshot) {
                return Text(
                  '${snapshot.data}',
                  style: Theme.of(context).textTheme.display1,
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class EmptyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('build empty widget');
    return Container();
  }
}
