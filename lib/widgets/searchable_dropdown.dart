import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class SearchableDropdown<T> extends StatefulWidget {
  final List<T> items;
  final List<T> selectedItems;
  final ValueChanged<List<T>> onConfirm;
  final String Function(T) displayItem;
  final String searchLabel;
  final String placeholder;

  const SearchableDropdown({
    Key? key,
    required this.items,
    required this.selectedItems,
    required this.onConfirm,
    required this.displayItem,
    this.searchLabel = 'Search...',
    this.placeholder = 'Select Items',
  }) : super(key: key);

  @override
  _SearchableDropdownState<T> createState() => _SearchableDropdownState<T>();
}

class _SearchableDropdownState<T> extends State<SearchableDropdown<T>> {
  late List<T> _filteredItems;
  late List<T> _selectedItems;
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.items;
    _selectedItems = widget.selectedItems;
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterItems(String query) {
    setState(() {
      _filteredItems = widget.items
          .where((item) => widget.displayItem(item).toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.placeholder),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _searchController,
            onChanged: _filterItems,
            decoration: InputDecoration(
              labelText: widget.searchLabel,
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView(
              children: _filteredItems
                  .map((item) => ListTile(
                        title: Text(widget.displayItem(item)),
                        trailing: _selectedItems.contains(item)
                            ? Icon(Icons.check, color: Colors.green)
                            : null,
                        onTap: () {
                          setState(() {
                            if (_selectedItems.contains(item)) {
                              _selectedItems.remove(item);
                            } else {
                              _selectedItems.add(item);
                            }
                          });
                        },
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            widget.onConfirm(_selectedItems);
            Navigator.of(context).pop();
          },
          child: const Text('Confirm'),
        ),
      ],
    );
  }
}
