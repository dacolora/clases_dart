import 'package:flutter/material.dart';

class AppBarItem extends StatelessWidget implements PreferredSizeWidget {
  const AppBarItem({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      flexibleSpace: SizedBox(
        child: Column(
          children: [
            const SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                    color: Colors.white,
                    onPressed: () {},
                    icon: const Icon(Icons.settings_cell_sharp)),
                IconButton(
                    color: Colors.white,
                    onPressed: () {},
                    icon: const Icon(Icons.settings_accessibility)),
                const SizedBox(
                  width: 16,
                )
              ],
            )
          ],
        ),
      ),

      backgroundColor: Colors.black,
      //shadowColor: Colors.amber,
      actions: [
        Container(
          color: Colors.red,
        )
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(42);
}
