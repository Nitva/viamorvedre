import 'package:flutter/material.dart';
import 'package:viamorvedre/core/theme/app_colors.dart';
import 'package:viamorvedre/core/theme/app_text_styles.dart';

class CustomSearchBar extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final String hint;
  final IconData icon;

  const CustomSearchBar({
    super.key,
    required this.onChanged,
    this.hint = 'Buscar...',
    this.icon = Icons.search,
  });

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return TextField(
      controller: _controller,
      decoration: InputDecoration(
        prefixIcon: Icon(widget.icon),
        hintText: widget.hint,
        suffixIcon: _controller.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _controller.clear();
                  widget.onChanged('');
                  setState(() {});
                },
              )
            : null,
      ),
      onChanged: (value) {
        setState(() {});
        widget.onChanged(value);
      },
    );
  }
}
