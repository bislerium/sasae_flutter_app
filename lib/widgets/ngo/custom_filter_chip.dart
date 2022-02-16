import 'package:flutter/material.dart';

class CustomFilterChip extends StatefulWidget {
  final String chipLabel;
  final List<String> selectionList;

  const CustomFilterChip(
      {Key? key, required this.chipLabel, required this.selectionList})
      : super(key: key);

  @override
  _CustomFilterChipState createState() => _CustomFilterChipState();
}

class _CustomFilterChipState extends State<CustomFilterChip> {
  var _isSelected = false;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(widget.chipLabel),
      selected: _isSelected,
      checkmarkColor: Theme.of(context).colorScheme.onPrimaryContainer,
      selectedColor: Theme.of(context).colorScheme.primaryContainer,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: StadiumBorder(
          side: BorderSide(
        color: Theme.of(context).colorScheme.outline,
      )),
      onSelected: (value) {
        setState(() {
          _isSelected = value;
          _isSelected
              ? widget.selectionList.add(widget.chipLabel)
              : widget.selectionList.remove(widget.chipLabel);
        });
      },
    );
  }
}
