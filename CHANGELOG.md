## 1.0.1

* Added dark theme support [#13](https://github.com/peterscodee/miniplayer/issues/13)
* Removed overflow errors in the example app [#14](https://github.com/peterscodee/miniplayer/issues/14)

## 1.0.0+2

* Fixed a bug introduced with the null safety release 

## 1.0.0

* Null safety
* [Android] Back button now closes the player when expanded
* Introduced `MiniplayerWillPopScope` as a drop-in replacement for `WillPopScope` to work with nested architectures
* Updated the example to match the demo

## 0.6.1

* Mark onDismiss as deprecated: Replace with onDismiss**ed**
* API cleanup

## 0.6.0

* Added AnimationController
* Bug fixes

## 0.5.0+2

* Updated documentation
* Allow gestures to intervene in animations

## 0.5.0+1

* Bug fixes
* Dismiss behaviour is more natural now

## 0.5.0

* Added onDismiss property
* If onDismiss ist set, the miniplayer can be dismissed through a drag down gesture
* Drag behaviour is more natural now
* Changed default curve to Curves.easeOut

## 0.4.1+2

* Updated the description based on a comment
  from [@jwknows](https://www.reddit.com/r/FlutterDev/comments/ihipfr/miniplayer_functionality_in_flutter/#CommentTopMeta--Created--t1_g30dh9e:~:text=I%20might%20be%20wrong%20but%20I'm,be%20%22on%20top%22%20of%20dialogs%20etc...)

## 0.4.1+1

* Updated example reference in readme

## 0.4.1

* Updated example

## 0.4.0

* Added examples and demo images
* Added duration property
* Changed elevation rendering

## 0.3.0

* Migrated from StreamBuilder to ValueListenableBuilder
* 40% improvement in response time (previous 19.2ms, now 11.5ms)
* Added valueNotifier property

## 0.2.0

* Added backgroundColor property

## 0.1.2

* Bug fixes

## 0.1.1

* Bug fixes

## 0.1.0

* Initial Open Source release