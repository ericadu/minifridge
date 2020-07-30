import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:minifridge_app/models/report.dart';
import 'package:minifridge_app/models/signed_in_user.dart';
import 'package:minifridge_app/providers/auth_notifier.dart';
import 'package:minifridge_app/providers/reports_notifier.dart';
import 'package:minifridge_app/theme.dart';
import 'package:provider/provider.dart';

class ReportAlertDialog extends StatefulWidget {
  final String itemId;
  final Function onSubmit;

  ReportAlertDialog({this.itemId, this.onSubmit});

  @override
  _ReportAlertDialogState createState() => _ReportAlertDialogState();
}

class ReasonListItem {
  String reason;
  int index;
  ReasonListItem({this.reason, this.index});
}

class _ReportAlertDialogState extends State<ReportAlertDialog> {
  int id;
  String radioItem;
  TextEditingController _reasonController = TextEditingController();

  List<ReasonListItem> reasons = [
    ReasonListItem(index: 1, reason: 'Did not buy item'),
    ReasonListItem(index: 2, reason: 'Incorrect expiration'),
    ReasonListItem(index: 3, reason: 'Something else')
  ];

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0)
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Consumer(
        builder: (BuildContext context, ReportsNotifier reports, _ ) {
          return Container(
            decoration: new BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  alignment: Alignment.center,
                  decoration: new BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12)
                    )
                  ),
                  padding: EdgeInsets.only(top: 18, bottom: 5),
                  child: Text("Nobody's pear-fect 🍐",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black
                    )
                  )
                ),
                Divider(),
                Container(
                  padding: EdgeInsets.only(
                    top: 20,
                    left: 25,
                    right: 25,
                  ),
                  child: Text("Tell us what's wrong:",
                    style: TextStyle(
                      fontSize: 19,
                    )
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(bottom: 20, top: 5),
                  child: Column(
                    children: reasons.map((data) => RadioListTile(
                      title: Text('${data.reason}'),
                      groupValue: id,
                      value: data.index,
                      onChanged: (val) {
                        setState(() {
                          radioItem = data.reason;
                          id = data.index;
                        });
                      },
                    )).toList()
                  )
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text('Additional info:',
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 19)
                  )
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                  child: TextFormField(
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(
                          color: AppTheme.themeColor,
                          width: 1.0,
                        ),
                      ),
                    )
                  )
                ),
                SizedBox(height: 20),
                InkWell(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 18),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppTheme.lightSecondaryColor,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12)
                      )
                    ),
                    child: Text("Submit",
                      style: TextStyle(
                        fontSize: 19,
                      fontWeight: FontWeight.bold,
                        color: Colors.white
                      )
                    )
                  ),
                  onTap: () {
                    SignedInUser user = Provider.of<AuthNotifier>(context, listen: false).signedInUser;
                    String extraReason = _reasonController.text != null && _reasonController.text.length > 0 ? " Extra: " + _reasonController.text : "";
                    Report report = Report(
                      reportedBy: user.id,
                      baseId: user.baseId,
                      itemId: widget.itemId,
                      reason: radioItem + extraReason,
                      date: Timestamp.now()
                    );
                    reports.addReport(report).then(
                      (value) {
                        widget.onSubmit();
                        Navigator.of(context).pop();
                      }
                    );
                  }
                )
              ],
            )
          );
        }
      )
    );
  }
}