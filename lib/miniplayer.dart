library miniplayer;

import 'dart:async';

import 'package:flutter/material.dart';

typedef Widget MiniplayerBuilder(double height, double percentage);

class Miniplayer extends StatefulWidget {
  final double minHeight;
  final double maxHeight;
  final MiniplayerBuilder builder;
  final Curve curve;
  final double elevation;
  final Color backgroundColor;
  final ValueNotifier<double> valueNotifier;

  const Miniplayer({
    Key key,
    @required this.minHeight,
    @required this.maxHeight,
    @required this.builder,
    this.curve = Curves.easeInQuart,
    this.elevation = 0,
    this.backgroundColor = const Color(0x70000000),
    this.valueNotifier,
  }) : super(key: key);

  @override
  _MiniplayerState createState() => _MiniplayerState();
}

class _MiniplayerState extends State<Miniplayer> with TickerProviderStateMixin {
  ValueNotifier<double> heightNotifier;

  double _height;
  double _prevHeight;

  //Used to set the height after the animation is complete
  double _endHeight;
  bool _up;

  StreamController<double> _heightController =
      StreamController<double>.broadcast();
  AnimationController _animationController;
  Animation<double> _sizeAnimation;

  @override
  void initState() {
    if (widget.valueNotifier == null)
      heightNotifier = ValueNotifier(widget.minHeight);
    else
      heightNotifier = widget.valueNotifier;

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 300,
      ),
    );

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.reset();
        heightNotifier.value = _endHeight;
        _height = _endHeight;
      }
    });

    _height = widget.minHeight;
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
                  opacity: _percentage,
                  child: Container(color: widget.backgroundColor),
                ),
              ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                height: value,
                child: GestureDetector(
                  child: Material(
                    elevation: widget.elevation,
                    child: Container(
                      constraints: BoxConstraints.expand(),
                      child: widget.builder(value, _percentage),
                    ),
                  ),
                  onTap: () {
                    bool up = _height != widget.maxHeight;
                    _animateToHeight(up ? widget.maxHeight : widget.minHeight);
                  },
                  onPanEnd: (details) async {
                    if (_up)
                      _animateToHeight(widget.maxHeight);
                    else
                      _animateToHeight(widget.minHeight);
                  },
                  onPanUpdate: (details) {
                    _prevHeight = _height;

                    //details.delta.dy < 0 -> -- = +
                    var h = _height -= details.delta.dy;

                    //Makes sure that height !> maxHeight && !< minHeight
                    if (h > widget.maxHeight) h = widget.maxHeight;
                    if (h < widget.minHeight) h = widget.minHeight;

                    //Makes sure that the widget wont rebuild unnecessarily
                    if (_prevHeight == h &&
                        (h == widget.minHeight || h == widget.maxHeight))
                      return;

                    _height = h;
                    if (_height == widget.maxHeight)
                      _up = true;
                    else if (_height == widget.minHeight)
                      _up = false;
                    else
                      _up = _prevHeight < _height;

                    heightNotifier.value = h;
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

  void _animateToHeight(final double h) {
    _endHeight = h;
    _sizeAnimation = Tween(
      begin: _height,
      end: h,
    ).animate(
        CurvedAnimation(parent: _animationController, curve: widget.curve));

    _sizeAnimation.addListener(() {
      if (!(_sizeAnimation.value > widget.maxHeight) &&
          !(_sizeAnimation.value < widget.minHeight))
        heightNotifier.value = _sizeAnimation.value;
    });
    _animationController.forward();
  }
}
