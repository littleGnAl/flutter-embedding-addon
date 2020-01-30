/*
 * Copyright (C) 2020 littlegnal
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import 'package:flutter/material.dart';
import 'package:flutter_embedding_addon/event_dispatcher.dart';
import 'package:flutter_embedding_addon/global_navigator.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: GlobalNavigator().globalNavigatorKey,
      title: 'Flutter Demo',
      theme: Theme.of(context).copyWith(
          textTheme: TextTheme(body1: TextStyle(color: Colors.black))),
      onGenerateRoute: (settings) {
        bool isPushNative = false;
        if (settings.arguments != null && settings.arguments is Map) {
          var args = settings.arguments as Map;
          isPushNative = args.containsKey("isPushNative")
              ? args["isPushNative"] as bool
              : false;
        }

        debugPrint("onGenerateRoute: isPushNative - $isPushNative");
        return MaterialPageRoute(builder: (context) {
          switch (settings.name) {
            case '/first_page':
              return FirstPage();
            case '/second_page':
              return SecondPage();
            case '/third_page':
              return ThirdPage();
            default:
              return Scaffold(
                body: Container(),
              );
          }
        });
      },
      initialRoute: '/',
    );
  }
}

class FirstPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  VoidCallback _removeListener;

  String _eventName;

  dynamic _arguments;

  @override
  void initState() {
    super.initState();

    _removeListener =
        EventDispatcher().addEventListener((eventName, arguments) {
      setState(() {
        _eventName = eventName;
        _arguments = arguments;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text("First Page"),
            Text("eventName: $_eventName, arguments: ${_arguments.toString()}"),
            RaisedButton(
              child: Text("Open Second Page Native"),
              onPressed: () {
                GlobalNavigator().pushRouteNative('/second_page');
              },
            ),
            RaisedButton(
              child: Text("Finish"),
              onPressed: () {
                GlobalNavigator().popNative();
              },
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _removeListener?.call();
    super.dispose();
  }
}

class SecondPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  VoidCallback _removeListener;

  String _eventName;

  dynamic _arguments;

  @override
  void initState() {
    super.initState();

    _removeListener =
        EventDispatcher().addEventListener((eventName, arguments) {
      setState(() {
        _eventName = eventName;
        _arguments = arguments;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text("Second Page"),
            Text("eventName: $_eventName, arguments: ${_arguments.toString()}"),
            RaisedButton(
              child: Text("Open Third Page Native"),
              onPressed: () {
                GlobalNavigator().pushRouteNative('/third_page');
              },
            ),
            RaisedButton(
              child: Text("Send event"),
              onPressed: () {
                EventDispatcher()
                    .sendEvent("event_pass_data", "Data sent by SecondPage");
              },
            ),
            RaisedButton(
              child: Text("Finish"),
              onPressed: () {
                GlobalNavigator().popNative();
              },
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _removeListener?.call();
    super.dispose();
  }
}

class ThirdPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text("Third Page"),
            RaisedButton(
              child: Text("Send event"),
              onPressed: () {
                EventDispatcher()
                    .sendEvent("event_pass_data", "Data sent by ThirdPage");
              },
            ),
            RaisedButton(
              child: Text("Finish"),
              onPressed: () {
                GlobalNavigator().popNative();
              },
            ),
          ],
        ),
      ),
    );
  }
}
