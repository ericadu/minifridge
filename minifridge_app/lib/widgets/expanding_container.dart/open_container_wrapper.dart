import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

class OpenContainerWrapper extends StatelessWidget {
  const OpenContainerWrapper({
    this.closedBuilder,
    this.transitionType,
    this.onClosed,
    this.openBuilder,
  });

  final OpenContainerBuilder closedBuilder;
  final ContainerTransitionType transitionType;
  final ClosedCallback<bool> onClosed;
  final Function openBuilder;

  @override
  Widget build(BuildContext context) {
    return OpenContainer<bool>(
      transitionType: transitionType,
      openBuilder: openBuilder,
      onClosed: onClosed,
      tappable: false,
      closedBuilder: closedBuilder,
      closedElevation: 0.0,
      transitionDuration: Duration(milliseconds: 400),
    );
  }
}