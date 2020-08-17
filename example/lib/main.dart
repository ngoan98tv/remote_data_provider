import 'package:example/providers/user_list_provider.dart';
import 'package:example/providers/user_provider.dart';
import 'package:example/views/user_item.dart';
import 'package:example/views/user_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
        ChangeNotifierProvider(
          create: (context) => UserListProvider(),
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
                  padding: const EdgeInsets.all(18.0),
                  child: Text(
                    'BasicDataProvider<T>',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: _userDetailWidget,
                ),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Text(
                    'DataListProvider<T>',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ),
                Expanded(
                  child: _userListWidget,
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

      return UserItem(data: _user.data);
    },
  );

  final _userListWidget = Builder(
    builder: (context) {
      final _userList = Provider.of<UserListProvider>(context);

      if (_userList.isLoading)
        return Center(
          child: CircularProgressIndicator(),
        );

      if (_userList.isError)
        return Center(
          child: Text("${_userList.error}"),
        );

      if (_userList.isEmpty)
        return Center(
          child: Text("No user data found."),
        );

      return UserList(data: _userList.data);
    },
  );
}
