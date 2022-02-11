import 'package:flutter/material.dart';

class CustomFilterChip extends StatefulWidget {
  final String chipLabel;
  final List<CustomFilterChip> selectionList;

  const CustomFilterChip(
      {Key? key, required this.chipLabel, required this.selectionList})
      : super(key: key);

  @override
  _CustomFilterChipState createState() => _CustomFilterChipState();
}

class _CustomFilterChipState extends State<CustomFilterChip> {
  var _isSelected = false;

  void unselect() {
    setState(() {
      _isSelected = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(widget.chipLabel),
      selected: _isSelected,
      selectedColor: Theme.of(context).primaryColorLight,
      onSelected: (value) {
        setState(() {
          _isSelected = value;
          _isSelected
              ? widget.selectionList.add(widget)
              : widget.selectionList.remove(widget);
        });
      },
    );
  }
}
