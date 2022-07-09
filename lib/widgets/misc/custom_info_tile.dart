import 'package:flutter/material.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_material_tile.dart';

class CustomInfoTile extends StatefulWidget {
  final IconData? leadingIcon;
  final String trailing;
  final String? leading;
  final void Function()? func;
  const CustomInfoTile(
      {Key? key,
      this.leadingIcon,
      this.leading,
      required this.trailing,
      this.func})
      : super(key: key);

  @override
  State<CustomInfoTile> createState() => _CustomInfoTileState();
}

class _CustomInfoTileState extends State<CustomInfoTile> {
  @override
  Widget build(BuildContext context) => CustomMaterialTile(
        func: widget.func,
        borderRadius: 12,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              widget.leading == null
                  ? Icon(
                      widget.leadingIcon,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    )
                  : Text(
                      widget.leading!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  reverse: true,
                  child: Text(
                    widget.trailing,
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
