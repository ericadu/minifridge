import 'package:flutter/material.dart';
import 'package:minifridge_app/models/user_item.dart';
import 'package:minifridge_app/view/user_items_notifier.dart';
import 'package:provider/provider.dart';

class UserItemBottomSheet extends StatefulWidget {
  final UserItem item;

  const UserItemBottomSheet({Key key, this.item}) : super(key: key);

  @override
  _UserItemBottomSheetState createState() => _UserItemBottomSheetState();
}

class _UserItemBottomSheetState extends State<UserItemBottomSheet> {
  int _quantity;

  @override
  void initState() {
    super.initState();
     _quantity = widget.item.quantity; 
  }

  void increment() {
    Provider.of<UserItemsNotifier>(context, listen: false).increaseQuantity(widget.item);

    setState(() {
      _quantity = _quantity + 1;
    });
  }

  void decrement() {
    Provider.of<UserItemsNotifier>(context, listen: false).decreaseQuantity(widget.item);
    
    setState(() {
      _quantity = _quantity - 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 330,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
        boxShadow: [
          BoxShadow(
            blurRadius: 10, color: Colors.grey[300], spreadRadius: 5)
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Text(widget.item.displayName),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Quantity'),
                  Row(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.remove_circle),
                        color: Colors.red,
                        onPressed: () => decrement()
                      ),
                      Text(_quantity.toString()),
                      IconButton(
                        icon: Icon(Icons.add_circle),
                        color: Colors.green,
                        onPressed: () => increment()
                      )
                    ]
                  )
                ]
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Unit'),
                  Text(widget.item.unit)
                ]
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('State'),
                  Text(widget.item.state)
                ]
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Storage'),
                  Text(widget.item.storageType)
                ]
              ),
            ),
          ]
        ),
      )
    );
  }
}