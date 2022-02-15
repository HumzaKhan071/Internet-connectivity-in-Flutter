import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
        ),
        home: HomePage());
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String status = "Waiting...";
  Connectivity _connectivity = Connectivity();
  late StreamSubscription _streamSubscription;

  @override
  void initState() {
    // checkConnectivity();
    checkRealTimeConnection();
    super.initState();
  }

  void checkConnectivity() async {
    var connectionResult = await _connectivity.checkConnectivity();
    if (connectionResult == ConnectivityResult.mobile) {
      status = "Mobile Data";
    } else if (connectionResult == ConnectivityResult.wifi) {
      status = "Wifi";
    } else {
      status = "Not Connected";
    }
    setState(() {});
  }

  void checkRealTimeConnection() {
    _streamSubscription = _connectivity.onConnectivityChanged.listen((event) {
      if (event == ConnectivityResult.mobile) {
        status = "Mobile Data";
      } else if (event == ConnectivityResult.wifi) {
        status = "Wifi";
      } else {
        status = "Not Connected";
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Internet Connectivity"),
      ),
      body: Center(
        child: Text(
          status,
          style: Theme.of(context).textTheme.headline5,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          checkRealTimeConnection();
        },
        tooltip: "Internet",
        child: Icon(Icons.add),
      ),
    );
  }
}
