import 'package:flutter/material.dart';
import 'screens/audio_screen.dart';
import 'widgets/player.dart';
import 'utils.dart';

ValueNotifier<AudioObject?> currentlyPlaying = ValueNotifier(null);

const double playerMinHeight = 70;
const double playerMaxHeight = 370;
const miniplayerPercentageDeclaration = 0.2;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Miniplayer Demo',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              AppBar(title: Text('Miniplayer Demo')),
              Expanded(
                child: AudioUi(
                  onTap: (audioObject) => currentlyPlaying.value = audioObject,
                ),
              ),
            ],
          ),
          ValueListenableBuilder(
            valueListenable: currentlyPlaying,
            builder: (BuildContext context, AudioObject? audioObject,
                    Widget? child) =>
                audioObject != null
                    ? DetailedPlayer(audioObject: audioObject)
                    : Container(),
          ),
        ],
      ),
      bottomNavigationBar: ValueListenableBuilder(
        valueListenable: playerExpandProgress,
        builder: (BuildContext context, double height, Widget? child) {
          final value = percentageFromValueInRange(
              min: playerMinHeight, max: playerMaxHeight, value: height);

          var opacity = 1 - value;
          if (opacity < 0) opacity = 0;
          if (opacity > 1) opacity = 1;

          return SizedBox(
            height:
                kBottomNavigationBarHeight - kBottomNavigationBarHeight * value,
            child: Transform.translate(
              offset: Offset(0.0, kBottomNavigationBarHeight * value * 0.5),
              child: Opacity(
                opacity: opacity,
                child: OverflowBox(
                  maxHeight: kBottomNavigationBarHeight,
                  child: child,
                ),
              ),
            ),
          );
        },
        child: BottomNavigationBar(
          currentIndex: 0,
          selectedItemColor: Colors.blue,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Feed'),
            BottomNavigationBarItem(
                icon: Icon(Icons.library_books), label: 'Library'),
          ],
        ),
      ),
    );
  }
}
