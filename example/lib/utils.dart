class AudioObject {
  final String title, subtitle, img;

  const AudioObject(this.title, this.subtitle, this.img);
}

double valueFromPercentageInRange(
    {required final double min, max, percentage}) {
  return percentage * (max - min) + min;
}

double percentageFromValueInRange({required final double min, max, value}) {
  return (value - min) / (max - min);
}
