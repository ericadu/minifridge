import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:minifridge_app/destination.dart';
import 'package:minifridge_app/screens/settings.dart';
import 'package:minifridge_app/screens/user_items/user_items.dart';
import 'package:minifridge_app/theme.dart';
import 'package:minifridge_app/view/user_notifier.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  static final routeName = '/home';
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin<HomePage> {
  List<AnimationController> _faders;
  List<Key> _destinationKeys;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();

    _faders = allDestinations.map<AnimationController>((Destination destination) {
      return AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    }).toList();
    _faders[_currentIndex].value = 1.0;
    _destinationKeys = List<Key>.generate(allDestinations.length, (int index) => GlobalKey()).toList();
  }

  @override
  void dispose() {
    for (AnimationController controller in _faders)
      controller.dispose();
    super.dispose();
  }

  Widget _buildView(String routeName) {
    if (routeName == SettingsPage.routeName) {
      return SettingsPage();
    } else {
      return UserItemsPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: AppTheme.themeColor,
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: allDestinations.map((Destination destination) {
            final Widget view = FadeTransition(
              opacity: _faders[destination.index].drive(CurveTween(curve: Curves.fastOutSlowIn)),
              child: KeyedSubtree(
                key: _destinationKeys[destination.index],
                child: _buildView(destination.routeName),
              ),
            );
            if (destination.index == _currentIndex) {
              _faders[destination.index].forward();
              return view;
            } else {
              _faders[destination.index].reverse();
              if (_faders[destination.index].isAnimating) {
                return IgnorePointer(child: view);
              }
              return Offstage(child: view);
            }
          }).toList(),
        )
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: allDestinations.map((Destination destination) {
          return BottomNavigationBarItem(
            icon: Icon(destination.icon),
            title: Text(destination.title)
          );
        }).toList(),
      ),
    );
  }

}