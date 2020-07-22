import 'package:flutter/material.dart';
import 'package:minifridge_app/providers/manual_entry_notifier.dart';
import 'package:minifridge_app/widgets/manual_right_button.dart';
import 'package:provider/provider.dart';

class ManualEntryPage extends StatelessWidget {
  static const routeName = '/manual';

  void _callDatePicker(BuildContext context, ManualEntryNotifier manual) async {
    DateTime today = DateTime.now();
    DateTime newExp = await showDatePicker(
      context: context,
      initialDate: today,
      firstDate: today.subtract(Duration(days: 30)),
      lastDate: today.add(new Duration(days: 730)),
    );
    
    if (newExp != null) {
      manual.setDate(newExp);
    }
  }

  Widget _buildLeftButton(VoidCallback onStepCancel, ManualEntryNotifier manual) {
    if (manual.currentStep == 0) {
      return Container(
        child: FlatButton(
          child: Text("Cancel", style: TextStyle(color: Colors.grey)),
          onPressed: () => manual.reset()
        ),
      );
    } 

    return Container(
      child: FlatButton(
        child: Text("Back", style: TextStyle(color: Colors.grey)),
        onPressed: onStepCancel
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, ManualEntryNotifier manual, _) {
        List<Step> steps = [
          Step(
            title: const Text('Item Name'),
            isActive: true,
            state: StepState.complete,
            content: Column(
              children: <Widget>[
                TextFormField(
                  controller: manual.itemNameController,
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
                  controller: manual.dateController,
                  onTap: () {
                    _callDatePicker(context, manual);
                  }
                )
              ]
            )
          )
        ];

        manual.setStepLength(steps.length);

        return Scaffold(
          appBar: AppBar(
            title: Text('Add Manually', style: TextStyle(color: Colors.white)),
            actions: [
              IconButton(
                icon: Icon(Icons.close, color: Colors.white),
                onPressed: () => manual.reset()
              )
            ],
          ),
          body: Column(
            children: [
              Expanded(
              child: Stepper(
                steps: steps,
                controlsBuilder: (BuildContext context, { VoidCallback onStepContinue, VoidCallback onStepCancel }) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      _buildLeftButton(onStepCancel, manual),
                      SizedBox(height: 100, width: 20),
                      ManualAddRightButton(callback: onStepContinue)
                    ]
                  );
                },
                currentStep: manual.currentStep,
                onStepContinue: manual.next,
                onStepTapped: (step) => manual.goTo(step),
                onStepCancel: manual.cancel
              )
            )],
          )
        );
      }
    );
  }
}