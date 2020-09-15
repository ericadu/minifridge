import 'package:flutter/material.dart';
import 'package:minifridge_app/models/base_item.dart';
import 'package:minifridge_app/models/freshness.dart';
import 'package:minifridge_app/screens/base_items/categories/constants.dart';
import 'package:minifridge_app/screens/base_items/tile/expanded_card.dart';
import 'package:minifridge_app/widgets/freshness/meter.dart';

class BaseItemCard extends StatefulWidget {
  final BaseItem item;
  final VoidCallback openContainer;

  const BaseItemCard({
    this.item,
    this.openContainer
  });

  @override
  _BaseItemCardState createState() => _BaseItemCardState();
}

class _BaseItemCardState extends State<BaseItemCard> with SingleTickerProviderStateMixin {
  bool expanded = false;

  void expand() {
    setState(() {
      expanded = true;
      // height = 200;
    });
  }

  void close() {
    setState(() {
      expanded = false;
      // height = 80;
    });
  }

  Widget _buildClosed() {
    return ListTile(
          title: Text(widget.item.displayName,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14
            )
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 3),
            child: Text(
              widget.item.freshnessMessage,
              style: TextStyle(
                fontSize: 13,
                color: Colors.black
              )
            )
          ),
          trailing: IconButton(
            icon: Icon(Icons.unfold_more),
            onPressed: expand,
            padding: EdgeInsets.all(0)
          ),
          // onTap: openContainer
        );
  }

  Widget _buildExpanded() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 20,
        right: 15,
        top: 5
      ),
      child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Text(widget.item.displayName,
              //       style: const TextStyle(
              //         fontWeight: FontWeight.bold,
              //         fontSize: 14
              //       )
              //     ),

              //     IconButton(
              //       icon: Icon(Icons.unfold_less),
              //       onPressed: close,
              //       padding: EdgeInsets.all(0)
              //     )
              //   ],
              // ),
              Padding(
                padding: EdgeInsets.only(left: 20, bottom: 10),
                child: Row(
                  children: [
                    Chip(
                      backgroundColor: Colors.grey[300],
                      avatar: CircleAvatar(
                        backgroundColor: Colors.grey[300],
                        child: Text(categoryMapping[widget.item.category]),
                      ),
                      label: Text(widget.item.category),
                      labelPadding: EdgeInsets.only(
                        top: 2, bottom: 2, right: 8
                      ),
                    ),
                  ],
                )
              ),
              Padding(
                padding: EdgeInsets.only(top: 10, left: 10, bottom: 10),
                child: Text('Fresh-O-Meter'),
              ),
              SizedBox(
                height: 150,
                child: FreshnessMeter(
                  item: widget.item,
                )
              ),
            ],
          ));  
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          title: Text(widget.item.displayName,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14
            )
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 3),
            child: Text(
              widget.item.freshnessMessage,
              style: TextStyle(
                fontSize: 13,
                color: Colors.black
              )
            )),
          trailing: expanded ? IconButton(
            icon: Icon(Icons.unfold_less),
            onPressed: close,
            padding: EdgeInsets.all(0)
          ) : IconButton(
            icon: Icon(Icons.unfold_more),
            onPressed: expand,
            padding: EdgeInsets.all(0)
          ),
          // onTap: openContainer
        ),
        AnimatedSize(
          duration: Duration(milliseconds: 400),
          curve: Curves.easeIn,
          vsync: this,
          child: Container(
            child: Padding(
              padding: const EdgeInsets.only(
                top: 3, bottom: 5, left: 5
              ),
              child: _buildExpanded()
            )
          )
        )
      ],
    );
  }
}
