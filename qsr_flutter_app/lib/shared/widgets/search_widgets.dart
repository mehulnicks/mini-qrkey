import 'package:flutter/material.dart';

/// Reusable search bar widget
class AppSearchBar extends StatefulWidget {
  final String? hintText;
  final Function(String) onChanged;
  final Function(String)? onSubmitted;
  final TextEditingController? controller;
  final Widget? leading;
  final Widget? trailing;
  final bool autofocus;
  final bool enabled;

  const AppSearchBar({
    super.key,
    required this.onChanged,
    this.hintText,
    this.onSubmitted,
    this.controller,
    this.leading,
    this.trailing,
    this.autofocus = false,
    this.enabled = true,
  });

  @override
  State<AppSearchBar> createState() => _AppSearchBarState();
}

class _AppSearchBarState extends State<AppSearchBar> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _showClearButton = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _focusNode = FocusNode();
    _showClearButton = _controller.text.isNotEmpty;
    
    _controller.addListener(_onTextChanged);
    if (widget.autofocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _focusNode.requestFocus();
      });
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    if (widget.controller == null) {
      _controller.dispose();
    }
    _focusNode.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final text = _controller.text;
    widget.onChanged(text);
    
    setState(() {
      _showClearButton = text.isNotEmpty;
    });
  }

  void _clearSearch() {
    _controller.clear();
    widget.onChanged('');
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        enabled: widget.enabled,
        onSubmitted: widget.onSubmitted,
        decoration: InputDecoration(
          hintText: widget.hintText ?? 'Search...',
          hintStyle: TextStyle(color: Colors.grey[500]),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          prefixIcon: widget.leading ?? 
              Icon(Icons.search, color: Colors.grey[500]),
          suffixIcon: _showClearButton
              ? IconButton(
                  icon: Icon(Icons.clear, color: Colors.grey[500]),
                  onPressed: _clearSearch,
                )
              : widget.trailing,
        ),
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}

/// Search suggestions widget
class SearchSuggestions extends StatelessWidget {
  final List<String> suggestions;
  final Function(String) onSuggestionTap;
  final String? currentQuery;
  final Widget? emptyState;

  const SearchSuggestions({
    super.key,
    required this.suggestions,
    required this.onSuggestionTap,
    this.currentQuery,
    this.emptyState,
  });

  @override
  Widget build(BuildContext context) {
    if (suggestions.isEmpty) {
      return emptyState ?? const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListView.separated(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: suggestions.length,
        separatorBuilder: (context, index) => Divider(
          height: 1,
          color: Colors.grey[200],
        ),
        itemBuilder: (context, index) {
          final suggestion = suggestions[index];
          return ListTile(
            dense: true,
            leading: Icon(
              Icons.search,
              size: 18,
              color: Colors.grey[400],
            ),
            title: _buildHighlightedText(suggestion),
            onTap: () => onSuggestionTap(suggestion),
          );
        },
      ),
    );
  }

  Widget _buildHighlightedText(String text) {
    if (currentQuery == null || currentQuery!.isEmpty) {
      return Text(text, style: const TextStyle(fontSize: 14));
    }

    final query = currentQuery!.toLowerCase();
    final textLower = text.toLowerCase();
    final index = textLower.indexOf(query);

    if (index == -1) {
      return Text(text, style: const TextStyle(fontSize: 14));
    }

    return RichText(
      text: TextSpan(
        style: const TextStyle(fontSize: 14, color: Colors.black87),
        children: [
          if (index > 0)
            TextSpan(text: text.substring(0, index)),
          TextSpan(
            text: text.substring(index, index + query.length),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFFFF9933),
            ),
          ),
          if (index + query.length < text.length)
            TextSpan(text: text.substring(index + query.length)),
        ],
      ),
    );
  }
}

/// Search filter chips widget
class SearchFilterChips extends StatelessWidget {
  final List<SearchFilter> filters;
  final List<String> selectedFilters;
  final Function(String) onFilterToggle;
  final bool multiSelect;

  const SearchFilterChips({
    super.key,
    required this.filters,
    required this.selectedFilters,
    required this.onFilterToggle,
    this.multiSelect = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = selectedFilters.contains(filter.key);
          
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(
                filter.label,
                style: TextStyle(
                  fontSize: 12,
                  color: isSelected ? Colors.white : Colors.grey[700],
                ),
              ),
              selected: isSelected,
              onSelected: (_) => onFilterToggle(filter.key),
              selectedColor: const Color(0xFFFF9933),
              backgroundColor: Colors.grey[100],
              side: BorderSide(
                color: isSelected 
                    ? const Color(0xFFFF9933)
                    : Colors.grey[300]!,
              ),
              showCheckmark: false,
            ),
          );
        },
      ),
    );
  }
}

/// Search results header widget
class SearchResultsHeader extends StatelessWidget {
  final int totalResults;
  final String? query;
  final List<String>? activeFilters;
  final VoidCallback? onClearFilters;

  const SearchResultsHeader({
    super.key,
    required this.totalResults,
    this.query,
    this.activeFilters,
    this.onClearFilters,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  _getResultsText(),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
              ),
              if (activeFilters != null && activeFilters!.isNotEmpty)
                TextButton(
                  onPressed: onClearFilters,
                  child: const Text(
                    'Clear filters',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
            ],
          ),
          if (activeFilters != null && activeFilters!.isNotEmpty) ...[
            const SizedBox(height: 4),
            Wrap(
              spacing: 4,
              children: activeFilters!.map((filter) => Chip(
                label: Text(
                  filter,
                  style: const TextStyle(fontSize: 10),
                ),
                backgroundColor: const Color(0xFFFF9933).withOpacity(0.1),
                side: const BorderSide(color: Color(0xFFFF9933)),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              )).toList(),
            ),
          ],
        ],
      ),
    );
  }

  String _getResultsText() {
    final resultsText = totalResults == 1 
        ? '1 result'
        : '$totalResults results';
        
    if (query != null && query!.isNotEmpty) {
      return '$resultsText for "$query"';
    }
    
    return resultsText;
  }
}

/// Search filter model
class SearchFilter {
  final String key;
  final String label;
  final IconData? icon;

  const SearchFilter({
    required this.key,
    required this.label,
    this.icon,
  });
}

/// Debounced search widget
class DebouncedSearch extends StatefulWidget {
  final Function(String) onSearch;
  final Duration debounceDuration;
  final String? hintText;
  final Widget? leading;
  final Widget? trailing;

  const DebouncedSearch({
    super.key,
    required this.onSearch,
    this.debounceDuration = const Duration(milliseconds: 500),
    this.hintText,
    this.leading,
    this.trailing,
  });

  @override
  State<DebouncedSearch> createState() => _DebouncedSearchState();
}

class _DebouncedSearchState extends State<DebouncedSearch> {
  late TextEditingController _controller;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onTextChanged() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(widget.debounceDuration, () {
      widget.onSearch(_controller.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppSearchBar(
      controller: _controller,
      hintText: widget.hintText,
      leading: widget.leading,
      trailing: widget.trailing,
      onChanged: (_) {}, // Handled by debounce
    );
  }
}

// Import for Timer
import 'dart:async';
