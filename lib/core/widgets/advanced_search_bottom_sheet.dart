import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class AdvancedSearchBottomSheet extends StatefulWidget {
  final bool isPhysicalLibrary;

  const AdvancedSearchBottomSheet({super.key, required this.isPhysicalLibrary});

  @override
  State<AdvancedSearchBottomSheet> createState() => _AdvancedSearchBottomSheetState();
}

class _AdvancedSearchBottomSheetState extends State<AdvancedSearchBottomSheet> {
  String _selectedSort = 'advanced_search_bottom_sheet.most_relevant';

  String? _selectedCategory;
  final TextEditingController _authorController = TextEditingController();

  String? _selectedStatus;
  String? _selectedYear;
  String? _selectedLanguage;

  final List<String> _mockCategories = [
    'advanced_search_bottom_sheet.all',
    'advanced_search_bottom_sheet.references',
    'advanced_search_bottom_sheet.study_aids',
    'advanced_search_bottom_sheet.computer_science',
    'advanced_search_bottom_sheet.history',
    'advanced_search_bottom_sheet.novels'
  ];

  @override
  void dispose() {
    _authorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    const Color primaryGreen = Color(0xFF2E7D32);

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 20, right: 20, top: 15,
      ),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 40, height: 5,
                decoration: BoxDecoration(color: Colors.grey.shade400, borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 20),

            Text(
              widget.isPhysicalLibrary ? 'advanced_search_bottom_sheet.advanced_search_physical'.tr() : 'advanced_search_bottom_sheet.advanced_search_digital'.tr(),
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDarkMode ? Colors.white : primaryGreen, fontFamily: 'Cairo'),
            ),
            const SizedBox(height: 20),

            _buildDropdown(
              label: 'advanced_search_bottom_sheet.category',
              icon: Icons.category_outlined,
              value: _selectedCategory,
              items: _mockCategories,
              onChanged: (val) => setState(() => _selectedCategory = val),
            ),
            const SizedBox(height: 15),

            TextField(
              controller: _authorController,
              style: const TextStyle(fontFamily: 'Cairo'),
              decoration: InputDecoration(
                labelText: 'advanced_search_bottom_sheet.author_name'.tr(),
                prefixIcon: const Icon(Icons.person_outline),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
            const SizedBox(height: 15),

            if (widget.isPhysicalLibrary) ...[
              Row(
                children: [
                  Expanded(
                    child: _buildDropdown(
                      label: 'advanced_search_bottom_sheet.availability_status',
                      icon: Icons.inventory_2_outlined,
                      value: _selectedStatus,
                      items: [
                        'advanced_search_bottom_sheet.all',
                        'advanced_search_bottom_sheet.available',
                        'advanced_search_bottom_sheet.borrowed'
                      ],
                      onChanged: (val) => setState(() => _selectedStatus = val),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildDropdown(
                      label: 'advanced_search_bottom_sheet.publish_year',
                      icon: Icons.calendar_today_outlined,
                      value: _selectedYear,
                      items: [
                        'advanced_search_bottom_sheet.all',
                        '2024',
                        '2023',
                        '2022',
                        '2021',
                        '2020'
                      ],
                      onChanged: (val) => setState(() => _selectedYear = val),
                    ),
                  ),
                ],
              ),
            ]
            else ...[
              _buildDropdown(
                label: 'advanced_search_bottom_sheet.book_language',
                icon: Icons.language,
                value: _selectedLanguage,
                items: [
                  'advanced_search_bottom_sheet.all',
                  'advanced_search_bottom_sheet.arabic',
                  'advanced_search_bottom_sheet.english'
                ],
                onChanged: (val) => setState(() => _selectedLanguage = val),
              ),
            ],

            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 10),

            Text('advanced_search_bottom_sheet.sort_results_by'.tr(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, fontFamily: 'Cairo')),
            const SizedBox(height: 10),

            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: [
                'advanced_search_bottom_sheet.most_relevant',
                'advanced_search_bottom_sheet.newest',
                'advanced_search_bottom_sheet.oldest',
                'advanced_search_bottom_sheet.most_read'
              ].map((sortKey) {
                final isSelected = _selectedSort == sortKey;
                return ChoiceChip(
                  label: Text(sortKey.tr(), style: TextStyle(color: isSelected ? Colors.white : (isDarkMode ? Colors.white70 : Colors.black87), fontFamily: 'Cairo')),
                  selected: isSelected,
                  selectedColor: primaryGreen,
                  backgroundColor: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
                  onSelected: (selected) {
                    if (selected) setState(() => _selectedSort = sortKey);
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 30),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      side: BorderSide(color: Colors.grey.shade400),
                    ),
                    child: Text('advanced_search_bottom_sheet.cancel'.tr(), style: const TextStyle(fontSize: 16, color: Colors.grey, fontFamily: 'Cairo')),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryGreen,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text('advanced_search_bottom_sheet.apply_search'.tr(), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white, fontFamily: 'Cairo')),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown({required String label, required IconData icon, required String? value, required List<String> items, required Function(String?) onChanged}) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label.tr(),
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      ),
      value: value,
      items: items.map((e) {
        String displayText = e.contains('advanced_search_bottom_sheet.') ? e.tr() : e;
        return DropdownMenuItem(value: e, child: Text(displayText, style: const TextStyle(fontFamily: 'Cairo')));
      }).toList(),
      onChanged: onChanged,
    );
  }
}
