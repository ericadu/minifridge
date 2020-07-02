import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:minifridge_app/models/user_item.dart';
import 'package:minifridge_app/util.dart';

class UserItemTile extends StatefulWidget {
  final UserItem item;

  const UserItemTile({Key key, this.item}) : super(key: key);
  
  @override
  _UserItemTileState createState() => _UserItemTileState();
}

class _UserItemTileState extends State<UserItemTile> {
  
  
  String _getMessage(UserItem item) {
    int daysLeft = Util.getDays(item);
    if (daysLeft == 0) {
      return "⏰ Eat me today";
    } else if (daysLeft == 1) {
      return "⏳ Eat me tomorrow ";
    } else {
      return daysLeft.toString() + " days left";
    }
  }

  @override
  Widget build(BuildContext context) {
    UserItem item = widget.item;
    DateTime expTimestamp = new DateTime.fromMicrosecondsSinceEpoch(item.expTimestamp.microsecondsSinceEpoch);
    var newDt = DateFormat.MEd().format(expTimestamp);
    final newTheme = Theme.of(context).copyWith(dividerColor: Colors.white);

    return Card(
      child: Padding(
        padding: const EdgeInsets.only(top: 3, bottom: 10),
        child: Theme(data: newTheme, child: 
          ExpansionTile(
            title: Text(item.displayName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 3),
              child: Text(_getMessage(item)),
            ),
            children: <Widget>[
              Divider(color: Colors.grey[300]),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: Text("Editing item")
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Fresh Until'),
                    Text(newDt)
                  ]
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 8, left: 15, right: 15, bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Quantity'),
                    // Row(
                    //   children: <Widget>[
                    //     _quantity > 0 ? IconButton(
                    //       icon: Icon(Icons.remove_circle),
                    //       color: Colors.red,
                    //       onPressed: () => decrement()
                    //     ) : IconButton(
                    //       icon: Icon(Icons.remove_circle),
                    //       color: Colors.grey,
                    //       onPressed: () => {}
                    //     ),
                    //     Text(_quantity.toString()),
                    //     IconButton(
                    //       icon: Icon(Icons.add_circle),
                    //       color: Colors.green,
                    //       onPressed: () => increment()
                    //     )
                    //   ]
                    // )
                  ]
                ),
              ),
            ]
          ),
        )
      )
    );
  }
}