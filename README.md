[![Pub](https://img.shields.io/pub/v/miniplayer?color=2196F3)](https://pub.dev/packages/miniplayer)

A lightweight flutter package to simplify the creation of a miniplayer by providing a builder function with the current height and percentage progress. The widget responds to tap and drag gestures and is highly customizable.

## Demo

<img src="https://s6.gifyu.com/images/ezgif.com-crop125b86630b69240f.gif" height="355"/>

## Usage

```dart
Miniplayer(
  minHeight: 70,
  maxHeight: 370,
  builder: (height, percentage) {
    return Center(
      child: Text('$height, $percentage'),
    );
  },
),
```
#### Default usage

```dart
import 'package:flutter/material.dart';
import 'package:miniplayer/miniplayer.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Miniplayer Demo',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
      builder: (context, child) { // <--- Important part
        return Stack(
          children: [
            child,
            Miniplayer(
              minHeight: 70,
              maxHeight: 370,
              builder: (height, percentage) {
                if(percentage > 0.2)
                  //return Text('!mini');
                else 
                  //return Text('mini');
              },
            ),
          ],
        );
      },
    );
  }
}
```

#### Usage with BottomNavigationBar

```
Example coming soon!
```
