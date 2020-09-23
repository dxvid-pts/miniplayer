[![Pub](https://img.shields.io/pub/v/miniplayer?color=2196F3)](https://pub.dev/packages/miniplayer)

A lightweight flutter package to simplify the creation of a miniplayer by providing a builder function with the current height and percentage progress. The widget responds to tap and drag gestures and is highly customizable.
**What is a miniplayer?**
Miniplayers are commonly used in media applications like Spotify and Youtube. A miniplayer can be expanded and minified and remains on the screen when minified until dismissed by the user.
See the demo below for an example.

## Demo

![demo](./example/demo_gif/demo.gif "demo")

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

## Options

<table>
  <tr></tr>
  <tr>
    <th>Parameter</th>
    <th>Implementation</th>
    <th>Demo</th>
  </tr>
  <tr>
    <td>onDismiss</td>
    <td>
      <pre lang="dart">
Miniplayer(
   onDismiss: () {
      //If onDismiss is set, 
      //the miniplayer can be dismissed
      //Handle onDismissed here
   }, 
),
      </pre>
    </td>
     <td>
       <img src="https://raw.githubusercontent.com/peterscodee/miniplayer/master/example/demo_gif/demo_dismiss.gif"/>
     </td>
  </tr>
  <tr></tr>
    <tr>
      <td>valueNotifier</td>
      <td>
        <pre lang="dart">
//Allows you to use a global ValueNotifier 
//with the current progress. 
//Can be used to hide the BottomNavigationBar.
final ValueNotifier<double> playerExpandProgress =
    ValueNotifier(playerMinHeight);
    
    
Miniplayer(
   valueNotifier: playerExpandProgress, 
),
        </pre>
      </td>
       <td>
         <img src="https://raw.githubusercontent.com/peterscodee/miniplayer/master/example/demo_gif/demo_valueNotifier.gif"/>
       </td>
    </tr>
</table>

### Usage without BottomNavigationBar
This method is only recommended for simple apps. If you want to use dialogs or persistent widgets such as a BottomNavigationBar, use the second (slightly more advanced) method as described in the [example](https://pub.dev/packages/miniplayer/example) which uses Navigator as a base.

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

### Usage with BottomNavigationBar

[See example](https://pub.dev/packages/miniplayer/example)
