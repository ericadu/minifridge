import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:minifridge_app/models/signed_in_user.dart';
import 'package:minifridge_app/screens/add_item/image_upload.dart';
import 'package:minifridge_app/screens/base_items/base_items.dart';
import 'package:minifridge_app/services/firebase_analytics.dart';
import 'package:minifridge_app/services/push_notifications.dart';
import 'package:minifridge_app/providers/image_picker_notifier.dart';
import 'package:minifridge_app/providers/auth_notifier.dart';
import 'package:minifridge_app/theme.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  SignedInUser user;
  bool showManualAdd = false;
  int currentStep = 0;
  bool complete = false;
  static final itemNameController = TextEditingController();
  final dateController = TextEditingController();

  void initState() {
    super.initState();
    
    user = Provider.of<AuthNotifier>(context, listen: false).signedInUser;
    final PushNotificationService _notificationService = PushNotificationService(user.id);
     analytics.setUserId(user.id);
    _notificationService.init();
  }

  void dispose() {
    itemNameController.dispose();
    super.dispose();
  }

  Widget _buildAddButton(BuildContext context, ImagePickerNotifier picker) {
    return FloatingActionButton(
      child: Icon(
        Icons.add,
        color: Colors.grey[700],
        size: 30
      ),
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              color: Color(0xFF737373),
              height: 180,
              child: Container(
                child: Column(
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.photo_camera),
                      title: Text('Take photo'),
                      onTap: () {
                        Navigator.pop(context);
                        picker.pickImage(ImageSource.camera);
                      }
                    ),
                    ListTile(
                      leading: Icon(Icons.photo_library),
                      title: Text('Choose from library'),
                      onTap: () {
                        Navigator.pop(context);
                        picker.pickImage(ImageSource.gallery);
                      }
                    ),
                    ListTile(
                      leading: Icon(Icons.edit),
                      title: Text('Add Manually'),
                      onTap: () {
                        Navigator.pop(context);
                        setState(() {
                          showManualAdd = true;
                        });
                      }
                    ),
                  ]
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(10),
                    topRight: const Radius.circular(10)
                  )
                )
              ),
            );
          }
        );
      },
    );
  }

  void _callDatePicker(BuildContext context) async {
    DateTime today = DateTime.now();
    DateTime newExp = await showDatePicker(
      context: context,
      initialDate: today,
      firstDate: today.subtract(Duration(days: 30)),
      lastDate: today.add(new Duration(days: 730)),
    );
    
    if (newExp != null) {
      setState(() {
        dateController.text = DateFormat.MEd().format(newExp);
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    List<Step> steps = [
      Step(
        title: const Text('Item Name'),
        isActive: true,
        state: StepState.complete,
        content: Column(
          children: <Widget>[
            TextFormField(
              controller: itemNameController,
            )
          ]
        )
      ),
      Step(
        title: const Text('Set Expiration Date'),
        isActive: false,
        state: StepState.editing,
        content: Column(
          children: <Widget>[
            TextFormField(
              controller: dateController,
              // initialValue: DateTime.now().toString(),
              onTap: () {
                _callDatePicker(context);
              }
            )
          ]
        )
      )
    ];

    _goTo(int step) {
      setState(() => currentStep = step);
    }

    _next() {
      currentStep + 1 != steps.length
          ? _goTo(currentStep + 1)
          : setState(() {
            complete = true;
            showManualAdd = false;
          });
    }

    _cancel() {
      if (currentStep <= 0) return;

      setState(() {
        _goTo(currentStep - 1);
      });
    }

    _resetStepper() {
      setState(() {
        currentStep = 0;
        showManualAdd = false;
      });
    }
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ImagePickerNotifier()
        ),
      ],
      child: Consumer(
        builder: (BuildContext context, ImagePickerNotifier picker, _) {
          
          if (picker.hasImage()) {
            return Scaffold (
                appBar: AppBar(
                  title: Text('Selected Photo', style: TextStyle(color: Colors.white))
                ),
                bottomNavigationBar: BottomAppBar(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      if (!picker.uploading())
                        IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () => picker.clear()
                        ),
                      if (!picker.uploading())
                        IconButton(
                          icon: Icon(Icons.check, color: Colors.green),
                          onPressed: () => picker.startUpload(user.id)
                        ),
                    ]
                  )
                ),
                body: ImageUploadPage()
            );
          }

          if (showManualAdd) {
            return Scaffold(
              appBar: AppBar(
                title: Text('Add Manually', style: TextStyle(color: Colors.white)),
                actions: [
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.white),
                    onPressed: () => _resetStepper()
                  )
                ],
              ),
              body: Column(
                children: [
                  Expanded(
                  child: Stepper(
                    steps: steps,
                    controlsBuilder: (BuildContext context,
                      {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
                        if (currentStep == 0) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Container(
                                // color: Colors.grey[300],
                                child: FlatButton(
                                  child: Text("Cancel", style: TextStyle(color: Colors.grey)),
                                  onPressed: () => _resetStepper()
                                ),
                              ),
                              SizedBox(height: 100, width: 20),
                              Container(
                                color: AppTheme.themeColor,
                                child: FlatButton(
                                  child: Text("Next", style: TextStyle(color: Colors.white)),
                                  onPressed: onStepContinue
                                )
                              )
                            ]
                          );                          
                        } else if (currentStep + 1 < steps.length) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Container(
                                // color: Colors.grey[300],
                                child: FlatButton(
                                  child: Text("Back", style: TextStyle(color: Colors.grey)),
                                  onPressed: onStepCancel
                                ),
                              ),
                              SizedBox(height: 100, width: 20),
                              Container(
                                color: AppTheme.themeColor,
                                child: FlatButton(
                                  child: Text("Next", style: TextStyle(color: Colors.white)),
                                  onPressed: onStepContinue
                                )
                              )
                            ]
                          );
                        } else {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Container(
                                // color: Colors.grey[300],
                                child: FlatButton(
                                  child: Text("Back", style: TextStyle(color: Colors.grey)),
                                  onPressed: onStepCancel
                                ),
                              ),
                              SizedBox(height: 100, width: 20),
                              Container(
                                color: AppTheme.lightTheme.accentColor,
                                child: FlatButton(
                                  child: Text("Submit", style: TextStyle(color: Colors.white)),
                                  onPressed: onStepContinue
                                )
                              )
                            ]
                          );
                        }
                      },
                    currentStep: currentStep,
                    onStepContinue: _next,
                    onStepTapped: (step) => _goTo(step),
                    onStepCancel: _cancel
                  )
                )
                ],
              )
            );
          }

          return Scaffold(
            body: BaseItemsPage(),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            floatingActionButton: Container(
              width: 70,
              height: 70,
              child: _buildAddButton(context, picker)
            )
          );
        }
      )
    );
  }
}