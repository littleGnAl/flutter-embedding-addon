import 'package:flutter/material.dart';
import 'package:flutter_add2app_navigation/global_navigator.dart';
import 'package:flutter_add2app_navigation/native_navigation_channel.dart';

void main() {
  runApp(MyApp());
  NativeNavigationChannel((routeName) {
    GlobalNavigator().pushNamed(routeName);
  });
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
              return FirstPage(isPushNative);
            case '/second_page':
              return SecondPage(isPushNative);
            case '/third_page':
              return ThirdPage(isPushNative);
            default:
              return FirstPage(isPushNative);
          }
        });
      },
      initialRoute: '/',
    );
  }
}

class FirstPage extends StatelessWidget {
  FirstPage(this._isPushNative);

  final bool _isPushNative;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text("First Page"),
            RaisedButton(
              child: Text("Open Second Page"),
              onPressed: () {
                debugPrint("FirstPage _isPushNative: $_isPushNative");
                GlobalNavigator().pushNamed('/second_page',
                    isPushNative: _isPushNative,
                    arguments: {"isPushNative": _isPushNative});
              },
            ),
            RaisedButton(
              child: Text("GO BACK"),
              onPressed: () {
                GlobalNavigator().pop(isPushNative: _isPushNative);
              },
            )
          ],
        ),
      ),
    );
  }
}

class SecondPage extends StatelessWidget {
  SecondPage(this._isPushNative);

  final bool _isPushNative;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text("Second Page"),
            RaisedButton(
              child: Text("Open Third Page"),
              onPressed: () {
                debugPrint("SecondPage _isPushNative: $_isPushNative");
                GlobalNavigator().pushNamed('/third_page',
                    isPushNative: _isPushNative,
                    arguments: {"isPushNative": _isPushNative});
              },
            ),
            RaisedButton(
              child: Text("GO BACK"),
              onPressed: () {
                GlobalNavigator().pop(isPushNative: _isPushNative);
              },
            )
          ],
        ),
      ),
    );
  }
}

class ThirdPage extends StatelessWidget {
  ThirdPage(this._isPushNative);

  final bool _isPushNative;

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
              child: Text("GO BACK"),
              onPressed: () {
                GlobalNavigator().pop(isPushNative: _isPushNative);
              },
            )
          ],
        ),
      ),
    );
  }
}
