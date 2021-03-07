import 'package:flutter/material.dart';

class MiniplayerWillPopScope extends StatefulWidget {
  const MiniplayerWillPopScope({
    Key? key,
    required this.child,
    required this.onWillPop,
  }) : super(key: key);

  final Widget child;
  final WillPopCallback onWillPop;

  @override
  _MiniplayerWillPopScopeState createState() => _MiniplayerWillPopScopeState();

  static _MiniplayerWillPopScopeState? of(BuildContext context) {
    return context.findAncestorStateOfType<_MiniplayerWillPopScopeState>();
  }
}

class _MiniplayerWillPopScopeState extends State<MiniplayerWillPopScope> {
  ModalRoute<dynamic>? _route;

  _MiniplayerWillPopScopeState? _descendant;

  set descendant(state) {
    _descendant = state;
    updateRouteCallback();
  }

  Future<bool> onWillPop() async {
    bool? willPop;
    if (_descendant != null) {
      willPop = await _descendant!.onWillPop();
    }
    if (willPop == null || willPop) {
      willPop = await widget.onWillPop();
    }
    return willPop;
  }

  void updateRouteCallback() {
    _route?.removeScopedWillPopCallback(onWillPop);
    _route = ModalRoute.of(context);
    _route?.addScopedWillPopCallback(onWillPop);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    var parentGuard = MiniplayerWillPopScope.of(context);
    if (parentGuard != null) {
      parentGuard.descendant = this;
    }
    updateRouteCallback();
  }

  @override
  void dispose() {
    _route?.removeScopedWillPopCallback(onWillPop);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
