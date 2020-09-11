import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:minifridge_app/models/base_item.dart';
import 'package:minifridge_app/models/freshness.dart';
import 'package:minifridge_app/providers/tile_view_notifier.dart';
// import 'package:minifridge_app/screens/base_items/report_alert_dialog.dart';
// import 'package:minifridge_app/screens/base_items/tile/edit_item_tile.dart';
// import 'package:minifridge_app/screens/base_items/tile/tile_toolbar.dart';
import 'package:minifridge_app/screens/item/item.dart';
// import 'package:minifridge_app/screens/base_items/tile/view_item_tile.dart';
import 'package:minifridge_app/services/food_base_api.dart';
import 'package:minifridge_app/theme.dart';
import 'package:minifridge_app/widgets/expanding_container.dart/open_container_wrapper.dart';
import 'package:provider/provider.dart';

class DatePickerMetadata {
  DateTime initialDate;
  DateTime firstDate;
  Function onUpdate;

  DatePickerMetadata({this.initialDate, this.firstDate, this.onUpdate});
}

class BaseItemTile extends StatefulWidget {
  final BaseItem item;
  final FoodBaseApi api;

  const BaseItemTile({Key key, this.item, this.api}) : super(key: key);

  @override
  _BaseItemTileState createState() => _BaseItemTileState();
}

class _BaseItemTileState extends State<BaseItemTile> {

  void _showMarkedAsDoneSnackbar(bool isMarkedAsDone) {
    if (isMarkedAsDone ?? false)
      Scaffold.of(context).showSnackBar(const SnackBar(
        content: Text('Marked as done!'),
      ));
  }

  void showSuccessBar() {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text("Report submitted!"),
        backgroundColor: AppTheme.lightSecondaryColor,
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    // final newTheme = Theme.of(context).copyWith(dividerColor: Colors.white);

    return ChangeNotifierProvider(
      create: (_) => TileViewNotifier(),
      child: Consumer(
        builder: (BuildContext context, TileViewNotifier tileView, _) {

          // Function onFlag = () {
          //   tileView.expand();
          //   showDialog(
          //     context: context,
          //     builder: (BuildContext context) {
          //       return ReportAlertDialog(itemId: widget.item.id, onSubmit: showSuccessBar);
          //     }
          //   );
          // };

          // TileToolbar toolbar = TileToolbar(onEdit: tileView.onEdit, onFlag: onFlag);
          return OpenContainerWrapper(
            transitionType:ContainerTransitionType.fade,
            openBuilder: (BuildContext context, VoidCallback _) {
              return ItemPage(item: widget.item);
            },
            closedBuilder: (BuildContext _, VoidCallback openContainer) {
              return BaseItemCard(item: widget.item, openContainer: openContainer);
            },
            onClosed: _showMarkedAsDoneSnackbar,
          );
        }
      )
    );
  }
}

class BaseItemCard extends StatelessWidget {
  final BaseItem item;
  final VoidCallback openContainer;

  const BaseItemCard({
    this.item,
    this.openContainer
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      // elevation: 1.0,
      child: Padding(
        padding: const EdgeInsets.only(
          // top: 18, bottom: 20, left: 18
          top: 3, bottom: 5, left: 5
        ),
        child: ListTile(
          title: Text(item.displayName,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14
            )
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 3),
            child: Text(
              item.freshnessMessage,
              style: TextStyle(
                fontSize: 13,
                color: Colors.black
              )
            )
          ),
          onTap: openContainer
        )
      )
    );
  }
}