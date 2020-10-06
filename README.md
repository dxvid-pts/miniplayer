[![Pub](https://img.shields.io/pub/v/miniplayer?color=2196F3)](https://pub.dev/packages/miniplayer)

A lightweight flutter package to simplify the creation of a miniplayer by providing a builder function with the current height and percentage progress. The widget responds to tap and drag gestures and is highly customizable.
**What is a miniplayer?**
Miniplayers are commonly used in media applications like Spotify and Youtube. A miniplayer can be expanded and minified and remains on the screen when minified until dismissed by the user.
See the demo below for an example.

## Demo

![demo](./example/demo_gif/demo.gif "demo")

## Usage

```dart
Stack(
  children: <Widget>[
    YourApp(),
    Miniplayer(
      minHeight: 70,
      maxHeight: 370,
      builder: (height, percentage) {
        return Center(
          child: Text('$height, $percentage'),
        );
      },
    ),
  ],
),
```

## Options

<table>
  <tr></tr>
  <tr>
    <th>Parameter</th>
    <th>Implementation</th>
    <th>Explanation</th>
  </tr>
  <tr>
    <td>onDismiss</td>
    <td>
      <pre lang="dart">
Miniplayer(
   onDismiss: () {
      //Handle onDismissed here
   }, 
),
      </pre>
    </td>
     <td>
       <img src="https://raw.githubusercontent.com/peterscodee/miniplayer/master/example/demo_gif/demo_dismiss.gif"/>
       <p>If onDismiss is set, the miniplayer can be dismissed</p>
     </td>
  </tr>
  <tr></tr>
    <tr>
      <td>valueNotifier</td>
      <td>
        <pre lang="dart">
final ValueNotifier&lt;double&gt; playerExpandProgress =
    ValueNotifier(playerMinHeight);
    </br>
Miniplayer(
   valueNotifier: playerExpandProgress, 
),
        </pre>
      </td>
       <td>
         <img src="https://raw.githubusercontent.com/peterscodee/miniplayer/master/example/demo_gif/demo_valueNotifier.gif"/>
         <p>Allows you to use a global ValueNotifier with the current progress. This can be used to hide the BottomNavigationBar.</p>
       </td>
    </tr>
</table>

## Persistence
Implementing the miniplayer as described under [usage](https://pub.dev/packages/miniplayer#usage) - for instance by wrapping it in a stack alongside the `Scaffold` body - would work out of the box but has some disadvantages. If you push a new screen via `Navigator.push` the miniplayer would disappear. What we want is a persistent miniplayer which stays on every screen.

You have the option of two methods when it comes to archiving the miniplayer's persistent state, which depends on the use case. The first method is only recommended for simple apps and use cases. If you want to use dialogs or persistent widgets such as a BottomNavigationBar, use the second (slightly more advanced) method 

## First method (Simple)
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

## Second method (Advanced)

[See example](https://pub.dev/packages/miniplayer/example)

## Roadmap
- [ ] Add a controller to be able to set positions programmatic
- [ ] Add an option to handle horizontal gestures as well (like Spotify does) 
- [ ] Rewrite the API for onDismiss (breaking change)
