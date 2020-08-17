import 'package:example/models/user.dart';
import 'package:flutter/material.dart';

class UserItem extends StatelessWidget {
  final User data;

  const UserItem({Key key, @required this.data})
      : assert(data != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "ID: ${data.id}",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          Text(
            "${data.name}",
            style: Theme.of(context).textTheme.headline4,
          ),
        ],
      ),
    );
  }
}
