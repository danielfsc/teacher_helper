import 'package:flutter/material.dart';

List<Color> availableColors = [
  const Color(0xff42a5f5),
  const Color(0xff4caf50),
  const Color(0xffffeb3b),
  const Color(0xffff9800),
  const Color(0xfff44336),
  const Color(0xff9c27b0),
  const Color(0xff607d8b),
];

class ColorPicker extends StatefulWidget {
  final Function
      onSelectColor; // This function sends the selected color to outside
  final Color initialColor; // The default picked color
  final bool circleItem; // Determnie shapes of color cells

  const ColorPicker({
    Key? key,
    required this.onSelectColor,
    required this.initialColor,
    this.circleItem = true,
  }) : super(key: key);

  @override
  _ColorPickerState createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  // This variable used to determine where the checkmark will be
  Color? _pickedColor;

  @override
  void initState() {
    super.initState();
    _pickedColor = widget.initialColor;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 50,
            childAspectRatio: 1 / 1,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10),
        itemCount: availableColors.length,
        itemBuilder: (context, index) {
          final itemColor = availableColors[index];
          return InkWell(
            onTap: () {
              widget.onSelectColor(itemColor);
              setState(() {
                _pickedColor = itemColor;
              });
            },
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                  color: itemColor,
                  shape: widget.circleItem == true
                      ? BoxShape.circle
                      : BoxShape.rectangle,
                  border: Border.all(width: 1, color: Colors.grey)),
              child: itemColor == _pickedColor
                  ? const Center(
                      child: Icon(
                        Icons.check,
                        color: Colors.white,
                      ),
                    )
                  : Container(),
            ),
          );
        },
      ),
    );
  }
}
