enum SnapPosition { MAX, MIN, DISMISS }

///Calculates the percentage of a value within a given range of values
double percentageFromValueInRange({final double min, max, value}) {
  return (value - min) / (max - min);
}

double borderDouble({double minRange, double maxRange, double value}) {
  if (value > maxRange) return maxRange;
  if (value < minRange) return minRange;
  return value;
}
