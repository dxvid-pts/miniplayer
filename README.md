[![Pub](https://img.shields.io/pub/v/miniplayer?color=2196F3)](https://pub.dev/packages/miniplayer)

A lightweight flutter package to simplify the creation of a miniplayer by providing a builder function with the current height and percentage progress. The widget responds to tap and drag gestures and is highly customizable.
**What is a miniplayer?**
Miniplayers are commonly used in media applications like Spotify and Youtube. A miniplayer can be expanded and minified and remains on the screen when minified until dismissed by the user.
See the demo below for an example.

Tutorial: https://www.youtube.com/watch?v=umhl2hakkcY

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
    <th>Example</th>
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
  <tr></tr>
    <tr>
      <td>controller</td>
      <td>
        <pre lang="dart">
final MiniplayerController controller = MiniplayerController();
    </br>
Miniplayer(
   controller: controller, 
),
  </br>
controller.animateToHeight(state: PanelState.MAX);
        </pre>
      </td>
       <td></td>
    </tr>
</table>

## Persistence
Implementing the miniplayer as described under [usage](https://pub.dev/packages/miniplayer#usage) - for instance by wrapping it inside a `Stack` in the `Scaffold` body - would work out of the box but has some disadvantages. If you push a new screen via `Navigator.push` the miniplayer would disappear. What we want is a persistent miniplayer which stays on the screen.

If you want to archive persistency, you have the choice between two embedding options, which depends on your use case. The [first method](https://pub.dev/packages/miniplayer#first-method-simple) is only recommended for simple apps. If you want to use dialogs or other persistent widgets such as a BottomNavigationBar, the [second](https://pub.dev/packages/miniplayer#second-method-advanced) (slightly more advanced) method is the right fit for you.

## First method (Simple)
Using a `Stack` in the [builder](https://api.flutter.dev/flutter/material/MaterialApp/builder.html) method
```dart
import 'package:flutter/material.dart';
import 'package:miniplayer/miniplayer.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Miniplayer example',
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
Using a `Stack` in combination with a custom `Navigator`

```dart
import 'package:flutter/material.dart';
import 'package:miniplayer/miniplayer.dart';

void main() => runApp(MyApp());

final _navigatorKey = GlobalKey();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Miniplayer example',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFFFAFAFA),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MiniplayerWillPopScope(
      onWillPop: () async {
        final NavigatorState navigator = _navigatorKey.currentState;
        if (!navigator.canPop()) return true;
        navigator.pop();

        return false;
      },
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            Navigator(
              key: _navigatorKey,
              onGenerateRoute: (RouteSettings settings) => MaterialPageRoute(
                settings: settings,
                builder: (BuildContext context) => FirstScreen(),
              ),
            ),
            Miniplayer(
              minHeight: 70,
              maxHeight: 370,
              builder: (height, percentage) => Center(
                child: Text('$height, $percentage'),
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: 0,
          fixedColor: Colors.blue,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.mail),
              label: 'Messages',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            )
          ],
        ),
      ),
    );
  }
}

class FirstScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Demo: FirstScreen')),
      body: Container(
        constraints: BoxConstraints.expand(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SecondScreen()),
              ),
              child: const Text('Open SecondScreen'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context, rootNavigator: true).push(
                MaterialPageRoute(builder: (context) => ThirdScreen()),
              ),
              child: const Text('Open ThirdScreen with root Navigator'),
            ),
          ],
        ),
      ),
    );
  }
}

class SecondScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Demo: SecondScreen')),
      body: Center(child: Text('SecondScreen')),
    );
  }
}

class ThirdScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Demo: ThirdScreen')),
      body: Center(child: Text('ThirdScreen')),
    );
  }
}
```

## Roadmap
- [ ] Provide better examples
- [ ] Add an option to handle horizontal gestures as well (like Spotify does) 
- [ ] Rewrite the API for onDismiss (breaking change)
  - [x] Marked onDismiss ad deprecated
