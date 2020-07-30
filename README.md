[![Pub](https://img.shields.io/pub/v/miniplayer?color=2196F3)](https://pub.dev/packages/miniplayer)

A lightweight flutter package providing a miniplayer widget which resizes according to drag gestures and returns a builder function with the current height and percentage progress.

## Usuage

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
