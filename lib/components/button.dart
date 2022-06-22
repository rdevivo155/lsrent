
class Button {
  const Button({
    required this.name,
    required this.icon
  });


  final String name;
  final String icon;

  String get assetName => name;
  String get assetIcon => icon;

  @override
  String toString() => "$name (name=$name)";
}
