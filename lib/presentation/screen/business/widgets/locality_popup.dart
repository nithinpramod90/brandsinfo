import 'package:flutter/material.dart';

class LocalityPopup extends StatelessWidget {
  final List<String> localities;
  final String? selectedLocality;
  final Function(String) onSelected;

  const LocalityPopup({
    super.key,
    required this.localities,
    required this.selectedLocality,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 300),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: localities.length,
          itemBuilder: (context, index) {
            final locality = localities[index];
            final isSelected = locality == selectedLocality;

            return ListTile(
              selected: isSelected,
              selectedTileColor: Colors.grey[200],
              title: Text(locality),
              onTap: () {
                onSelected(locality);
                Navigator.pop(context);
              },
            );
          },
        ),
      ),
    );
  }
}
