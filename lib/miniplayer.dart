library miniplayer;

import 'dart:async';

import 'package:flutter/material.dart';

typedef Widget MiniplayerBuilder(double height, double percentage);

class Miniplayer extends StatefulWidget {
  final double minHeight;
  final double maxHeight;
  final MiniplayerBuilder builder;
  final Curve curve;

  const Miniplayer(
      {Key key,
      @required this.minHeight,
      @required this.maxHeight,
      @required this.builder,
      this.curve = Curves.easeInQuart})
      : super(key: key);

  @override
  _MiniplayerState createState() => _MiniplayerState();
}

class _MiniplayerState extends State<Miniplayer> with TickerProviderStateMixin {
  double _height;
  double _prevHeight;

  //Used to set Size after animation is complete
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
              SizedBox(
                height: snapshot.data,
                child: GestureDetector(
                  child: widget.builder(snapshot.data, _percentage),
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
                    var h = _height -=
                        details.delta.dy; //details.delta.dy < 0 -> -- = +

                    //Make sure height !> maxHeight && !< minHeight
                    if (h > widget.maxHeight)
                      h = widget.maxHeight;
                    else if (h < widget.minHeight) h = widget.minHeight;

                    if (_prevHeight == h &&
                        (h == widget.minHeight || h == widget.maxHeight))
                      return;

                    //print('h: ' + h.toString());

                    _height = h;
                    _up = _prevHeight < _height;

                    _heightController.add(h);
                  },
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
      _heightController.add(_sizeAnimation.value);
    });
    _animationController.forward();
  }
}
