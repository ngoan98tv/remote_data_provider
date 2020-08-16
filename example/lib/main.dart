import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:remote_data_provider/basic_data_provider.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RDP Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Remote Data Provider Demo'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UserProvider(),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: Builder(
          builder: (context) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(28.0),
                  child: Text(
                    'BasicDataProvider<T>',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28.0),
                  child: _userDetailWidget,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  final _userDetailWidget = Builder(
    builder: (context) {
      final _user = Provider.of<UserProvider>(context);

      if (_user.isLoading)
        return Center(
          child: CircularProgressIndicator(),
        );

      if (_user.isError)
        return Center(
          child: Text("${_user.error}"),
        );

      if (_user.isEmpty)
        return Center(
          child: Text("No user data found."),
        );

      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _user.data.keys
            .map(
              (key) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(key),
                  Text(_user.data[key].toString()),
                ],
              ),
            )
            .toList()
              ..add(
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 18.0),
                      child: RaisedButton(
                        onPressed: () {
                          _user.refresh();
                        },
                        child: Text("Refresh"),
                      ),
                    ),
                  ],
                ),
              ),
      );
    },
  );
}

class UserProvider extends BasicDataProvider<Map<String, dynamic>> {
  @override
  Future<Map<String, dynamic>> fetchData() async {
    // simulate loading state
    await Future.delayed(const Duration(seconds: 3));

    final json = await rootBundle.loadString("assets/user.json");
    return jsonDecode(json);
  }
}
