import 'package:flutter/material.dart';
import 'package:appcenter/appcenter.dart';
import 'package:appcenter_analytics/appcenter_analytics.dart';
import 'package:appcenter_crashes/appcenter_crashes.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform;
import 'package:flutter/foundation.dart' show TargetPlatform;

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
      home: CrashHome(),
    );
  }
}

class CrashHome extends StatefulWidget {
  @override
  _CrashHomeState createState() => _CrashHomeState();
}

class _CrashHomeState extends State<CrashHome> {
  String _installId = 'Unknown';
  bool _areAnalyticsEnabled = false, _areCrashesEnabled = false;

  @override
  initState() {
    super.initState();
    initPlatformState();
  }

  initPlatformState() async {
    if (!mounted) return;

    var installId = await AppCenter.installId;
    var areAnalyticsEnabled = await AppCenterAnalytics.isEnabled;
    var areCrashesEnabled = await AppCenterCrashes.isEnabled;

    setState(() {
      _installId = installId;
      _areAnalyticsEnabled = areAnalyticsEnabled;
      _areCrashesEnabled = areCrashesEnabled;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appcenter plugin example app'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text('Install identifier:\n $_installId'),
          Text('Analytics: $_areAnalyticsEnabled'),
          Text('Crashes: $_areCrashesEnabled'),
          RaisedButton(
            child: Text('Generate test crash'),
            onPressed: AppCenterCrashes.generateTestCrash,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('Send events'),
              IconButton(
                icon: Icon(Icons.map),
                tooltip: 'map',
                onPressed: () {
                  AppCenterAnalytics.trackEvent("map");
                },
              ),
              IconButton(
                icon: Icon(Icons.casino),
                tooltip: 'casino',
                onPressed: () {
                  AppCenterAnalytics.trackEvent("casino", {"dollars": "10"});
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
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
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
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
