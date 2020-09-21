library miniplayer;

import 'dart:async';

import 'package:flutter/material.dart';

typedef Widget MiniplayerBuilder(double height, double percentage);

enum SnapPosition { MAX, MIN, DISMISS }

class Miniplayer extends StatefulWidget {
  final double minHeight, maxHeight, elevation;
  final MiniplayerBuilder builder;
  final Curve curve;
  final Color backgroundColor;
  final Duration duration;
  final ValueNotifier<double> valueNotifier;
  final Function onDismiss;

  const Miniplayer({
    Key key,
    @required this.minHeight,
    @required this.maxHeight,
    @required this.builder,
    this.curve = Curves.easeOut,
    this.elevation = 0,
    this.backgroundColor = const Color(0x70000000),
    this.valueNotifier,
    this.duration = const Duration(milliseconds: 300),
    this.onDismiss,
  }) : super(key: key);

  @override
  _MiniplayerState createState() => _MiniplayerState();
}

class _MiniplayerState extends State<Miniplayer> with TickerProviderStateMixin {
  ValueNotifier<double> heightNotifier;
  ValueNotifier<double> dragDownPercentage = ValueNotifier(0);

  SnapPosition snap;

  ///Current y position of drag gesture
  double _dragHeight;

  ///Used to determine SnapPosition
  double _startHeight;

  bool dismissed = false;

  bool animating = false;

  ///Counts how many updates were required for a distance (onPanUpdate) -> necessary to calculate the drag speed
  int updateCount = 0;

  StreamController<double> _heightController =
      StreamController<double>.broadcast();
  AnimationController _animationController;

  void statusListener(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      //unblock touch events
      animating = false;

      _animationController.dispose();
      _animationController = AnimationController(
        vsync: this,
        duration: widget.duration,
      );
      _animationController.addStatusListener(statusListener);
    }
  }

  @override
  void initState() {
    if (widget.valueNotifier == null)
      heightNotifier = ValueNotifier(widget.minHeight);
    else
      heightNotifier = widget.valueNotifier;

    _animationController = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _animationController.addStatusListener(statusListener);

    _dragHeight = widget.minHeight;

    super.initState();
  }

  @override
  void dispose() {
    _heightController.close();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (dismissed) return Container();

    return ValueListenableBuilder(
      builder: (BuildContext context, double value, Widget child) {
        var _percentage = ((value - widget.minHeight)) /
            (widget.maxHeight - widget.minHeight);

        return Stack(
          alignment: Alignment.bottomCenter,
          children: [
            if (_percentage > 0)
              GestureDetector(
                onTap: () => _animateToHeight(widget.minHeight),
                child: Opacity(
                  opacity: _borderDouble(
                      minRange: 0, maxRange: 1, value: _percentage),
                  child: Container(color: widget.backgroundColor),
                ),
              ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                height: value,
                child: GestureDetector(
                  child: ValueListenableBuilder(
                    valueListenable: dragDownPercentage,
                    builder: (context, value, child) {
                      if (value == 0) return child;

                      return Opacity(
                        opacity: _borderDouble(
                            minRange: 0, maxRange: 1, value: 1 - value * 0.8),
                        child: Transform.translate(
                          offset: Offset(0.0, widget.minHeight * value * 0.5),
                          child: child,
                        ),
                      );
                    },
                    child: Material(
                      color: Theme.of(context).canvasColor,
                      child: Container(
                        constraints: BoxConstraints.expand(),
                        child: widget.builder(value, _percentage),
                        decoration: BoxDecoration(
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                color: Colors.black45,
                                blurRadius: widget.elevation,
                                offset: Offset(0.0, 4))
                          ],
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  onTap: () => snapToPosition(_dragHeight != widget.maxHeight
                      ? SnapPosition.MAX
                      : SnapPosition.MIN),
                  onPanStart: (details) {
                    _startHeight = _dragHeight;
                    updateCount = 0;
                  },
                  onPanEnd: (details) async {
                    ///Calculates drag speed
                    double speed =
                        (_dragHeight - _startHeight * _dragHeight < _startHeight
                                ? 1
                                : -1) /
                            updateCount *
                            100;

                    ///Define the percentage distance depending on the speed with which the widget should snap
                    double snapPercentage = 0.005;
                    if (speed <= 4)
                      snapPercentage = 0.2;
                    else if (speed <= 9)
                      snapPercentage = 0.08;
                    else if (speed <= 50) snapPercentage = 0.01;

                    ///Determine to which SnapPosition the widget should snap
                    SnapPosition snap = SnapPosition.MIN;

                    final _percentageMax = _percentageFromValueInRange(
                        min: widget.minHeight,
                        max: widget.maxHeight,
                        value: _dragHeight);

                    ///Started from expanded state
                    if (_startHeight > widget.minHeight) {
                      if (_percentageMax > 1 - snapPercentage)
                        snap = SnapPosition.MAX;
                    }

                    ///Started from minified state
                    else {
                      if (_percentageMax > snapPercentage)
                        snap = SnapPosition.MAX;
                      else

                      ///DismissedPercentage > 0.2 -> dismiss
                      if (widget.onDismiss != null &&
                          _percentageFromValueInRange(
                                  min: widget.minHeight,
                                  max: 0,
                                  value: _dragHeight) >
                              snapPercentage) snap = SnapPosition.DISMISS;
                    }

                    ///Snap to position
                    snapToPosition(snap);
                  },
                  onPanUpdate: (details) {
                    if (animating) return;
                    if (dismissed) return;

                    _dragHeight -= details.delta.dy;
                    updateCount++;

                    handleHeightChange();
                  },
                ),
              ),
            ),
          ],
        );
      },
      valueListenable: heightNotifier,
    );
  }

  ///Determines whether the panel should be updated in height or discarded
  void handleHeightChange({bool animation = false}) {
    ///Drag above minHeight
    if (_dragHeight >= widget.minHeight) {
      heightNotifier.value = _dragHeight;

      if (dragDownPercentage.value != 0) dragDownPercentage.value = 0;
    }

    ///Drag below minHeight
    else if (widget.onDismiss != null) {
      var percentageDown = _borderDouble(
          minRange: 0,
          maxRange: 1,
          value: _percentageFromValueInRange(
              min: widget.minHeight, max: 0, value: _dragHeight));

      if (dragDownPercentage.value != percentageDown)
        dragDownPercentage.value = percentageDown;

      if (percentageDown >= 1 && animation && !dismissed) {
        if (widget.onDismiss != null) widget.onDismiss();
        setState(() {
          dismissed = true;
        });
      }
    }
  }

  ///Animates the panel height according to a SnapPoint
  void snapToPosition(SnapPosition snapPosition) {
    switch (snapPosition) {
      case SnapPosition.MAX:
        _animateToHeight(widget.maxHeight);
        return;
      case SnapPosition.MIN:
        _animateToHeight(widget.minHeight);
        return;
      case SnapPosition.DISMISS:
        _animateToHeight(0);
        return;
    }
  }

  ///Animates the panel height to a specific value
  void _animateToHeight(final double h) {
    final startHeight = _dragHeight;

    Animation<double> _sizeAnimation = Tween(
      begin: startHeight,
      end: h,
    ).animate(
        CurvedAnimation(parent: _animationController, curve: widget.curve));

    _sizeAnimation.addListener(() {
      if (_sizeAnimation.value == startHeight) return;

      _dragHeight = _sizeAnimation.value;

      handleHeightChange(animation: true);
    });

    animating = true;
    _animationController.forward(from: 0);
  }
}

///Calculates the percentage of a value within a given range of values
double _percentageFromValueInRange({final double min, max, value}) {
  return (value - min) / (max - min);
}

double _borderDouble({double minRange, double maxRange, double value}) {
  if (value > maxRange) return maxRange;
  if (value < minRange) return minRange;
  return value;
}
