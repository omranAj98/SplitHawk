
// New class for the currency search dialog
import 'package:flutter/material.dart';
import 'package:splithawk/src/core/localization/l10n/app_localizations.dart';

class CurrencySearchDialog extends StatefulWidget {
  final List<String> currencies;
  final String selectedCurrency;
  final Function(String) onCurrencySelected;

  const CurrencySearchDialog({
    super.key,
    required this.currencies,
    required this.selectedCurrency,
    required this.onCurrencySelected,
  });

  @override
  State<CurrencySearchDialog> createState() => _CurrencySearchDialogState();
}

class _CurrencySearchDialogState extends State<CurrencySearchDialog> {
  late TextEditingController _searchController;
  late List<String> filteredCurrencies;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    filteredCurrencies = List.from(widget.currencies);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterCurrencies(String query) {
    setState(() {
      filteredCurrencies =
          widget.currencies
              .where(
                (currency) =>
                    currency.toLowerCase().contains(query.toLowerCase()),
              )
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.currency),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.searchCurrency,
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: _filterCurrencies,
            ),
            SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: filteredCurrencies.length,
                itemBuilder: (context, index) {
                  final currency = filteredCurrencies[index];
                  final isSelected = currency == widget.selectedCurrency;

                  return ListTile(
                    title: Text(currency),
                    selected: isSelected,
                    tileColor:
                        isSelected ? Theme.of(context).highlightColor : null,
                    onTap: () => widget.onCurrencySelected(currency),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(AppLocalizations.of(context)!.cancel),
        ),
      ],
    );
  }
}
