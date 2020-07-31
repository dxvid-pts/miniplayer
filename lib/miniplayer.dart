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

  const Miniplayer({
    Key key,
    @required this.minHeight,
    @required this.maxHeight,
    @required this.builder,
    this.curve = Curves.easeInQuart,
    this.elevation = 0,
  }) : super(key: key);

  @override
  _MiniplayerState createState() => _MiniplayerState();
}

class _MiniplayerState extends State<Miniplayer> with TickerProviderStateMixin {
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
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 300,
      ),
    );

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.reset();
        _heightController.add(_endHeight);
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
    return StreamBuilder(
      initialData: widget.minHeight,
      stream: _heightController.stream,
      builder: (context, AsyncSnapshot<double> snapshot) {
        if (snapshot.hasData) {
          var _percentage = ((snapshot.data - widget.minHeight)) /
              (widget.maxHeight - widget.minHeight);

          return Stack(
            alignment: Alignment.bottomCenter,
            children: [
              if (_percentage > 0)
                GestureDetector(
                  onTap: () => animateToHeight(widget.minHeight),
                  child: Container(
                      color: Colors.black.withOpacity(_percentage * 0.5)),
                ),
              Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  height: snapshot.data,
                  child: GestureDetector(
                    child: Material(
                      elevation: widget.elevation,
                      child: Container(
                        constraints: BoxConstraints.expand(),
                        child: widget.builder(snapshot.data, _percentage),
                      ),
                    ),
                    onTap: () {
                      bool up = _height != widget.maxHeight;
                      animateToHeight(up ? widget.maxHeight : widget.minHeight);
                    },
                    onPanEnd: (details) async {
                      if (_up)
                        animateToHeight(widget.maxHeight);
                      else
                        animateToHeight(widget.minHeight);
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

                      _heightController.add(h);
                    },
                  ),
                ),
              ),
            ],
          );
        } else
          return Container();
      },
    );
  }

  void animateToHeight(final double h) {
    _endHeight = h;
    _sizeAnimation = Tween(
      begin: _height,
      end: h,
    ).animate(
        CurvedAnimation(parent: _animationController, curve: widget.curve));

    _sizeAnimation.addListener(() {
      if (!(_sizeAnimation.value > widget.maxHeight) &&
          !(_sizeAnimation.value < widget.minHeight))
        _heightController.add(_sizeAnimation.value);
    });
    _animationController.forward();
  }
}
