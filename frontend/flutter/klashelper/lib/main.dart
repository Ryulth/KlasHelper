import 'package:flutter/material.dart';
import 'package:klashelper/pages/assignmentPage.dart';
import 'package:klashelper/pages/loginPages.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
       home: AssignmentPage(),//MyHomePage(title: 'Flutter Demo Home Page'),
        routes: {
          '/assignmentPage': (context) => AssignmentPage(),
          '/loginPage': (context) => LoginPage(),
        }
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
  TempSwitch tempSwitch = new TempSwitch();

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
                child: Text('Login', style: TextStyle(fontSize: 24)),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext context) {
                        return AssignmentPage();
                      }));
                }),
            tempSwitch,
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme
                  .of(context)
                  .textTheme
                  .display1,
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

class TempSwitch extends StatefulWidget {
  @override
  TempSwitchState createState() => TempSwitchState();
}

class TempSwitchState extends State<TempSwitch> {
  bool _value = false;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Switch(
      onChanged: (bool newValue) {
        print(newValue);
        setState(() {
          _value = newValue;
        });
      },
      value: _value,
    );
  }
}
