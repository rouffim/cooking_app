class SliderModel {
  double min = 1;
  double max = 16;
  double value;
  int divisions;
  Function onChange;
  Function onReset;

  void init() {
    this.divisions = max.toInt() - min.toInt();
  }
}