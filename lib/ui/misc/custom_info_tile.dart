import 'package:flutter/material.dart';
import 'package:sasae_flutter_app/ui/misc/custom_material_tile.dart';

class CustomInfoTile extends StatelessWidget {
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
  Widget build(BuildContext context) => CustomMaterialTile(
        func: func,
        borderRadius: 12,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              leading == null
                  ? Icon(
                      leadingIcon,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    )
                  : Text(
                      leading!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  reverse: true,
                  child: Text(
                    trailing,
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
