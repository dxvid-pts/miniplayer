import 'package:miniplayer/miniplayer.dart';

extension SelectedColorExtension on PanelState {
  int get heightCode {
    switch (this) {
      case PanelState.MIN:
        return -1;
      case PanelState.MAX:
        return -2;
      case PanelState.DISMISS:
        return -3;
      default:
        return -1;
    }
  }
}

///Calculates the percentage of a value within a given range of values
double percentageFromValueInRange({final double min, max, value}) {
  return (value - min) / (max - min);
}

double borderDouble({double minRange, double maxRange, double value}) {
  if (value > maxRange) return maxRange;
  if (value < minRange) return minRange;
  return value;
}
