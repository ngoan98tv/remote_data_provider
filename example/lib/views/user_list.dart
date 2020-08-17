import 'package:example/models/user.dart';
import 'package:example/views/user_item.dart';
import 'package:flutter/material.dart';

class UserList extends StatelessWidget {
  final List<User> data;

  const UserList({Key key, @required this.data})
      : assert(data != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 18.0,
          vertical: 8.0,
        ),
        child: UserItem(data: data[index]),
      ),
      itemCount: data.length,
    );
  }
}
