import 'package:flutter/material.dart';

class RecentSearchesList extends StatelessWidget {
  final List<String> searches;
  final Function(String) onTap;

  const RecentSearchesList({
    Key? key,
    required this.searches,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return searches.isEmpty
        ? Center(child: Text('No recent searches'))
        : ListView.builder(
            itemCount: searches.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: const Icon(Icons.history),
                title: Text(searches[index]),
                trailing: IconButton(
                  icon: const Icon(Icons.north_west),
                  onPressed: () => onTap(searches[index]),
                ),
                onTap: () => onTap(searches[index]),
              );
            },
          );
  }
}
