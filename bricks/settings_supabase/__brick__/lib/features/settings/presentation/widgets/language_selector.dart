import 'package:flutter/material.dart';

class LanguageSelector extends StatelessWidget {
  final String currentLanguage;
  final ValueChanged<String> onLanguageChanged;

  const LanguageSelector({
    super.key,
    required this.currentLanguage,
    required this.onLanguageChanged,
  });

  static const List<LanguageOption> _languages = [
    LanguageOption('system', 'System', 'Follow system language', '🌐'),
    LanguageOption('en', 'English', 'English', '🇺🇸'),
    LanguageOption('ko', 'Korean', '한국어', '🇰🇷'),
    LanguageOption('ja', 'Japanese', '日本語', '🇯🇵'),
    LanguageOption('zh', 'Chinese', '中文', '🇨🇳'),
    LanguageOption('es', 'Spanish', 'Español', '🇪🇸'),
    LanguageOption('fr', 'French', 'Français', '🇫🇷'),
    LanguageOption('de', 'German', 'Deutsch', '🇩🇪'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Choose Language',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.6,
            ),
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: _languages.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final language = _languages[index];
                return _buildLanguageOption(context, language);
              },
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildLanguageOption(BuildContext context, LanguageOption language) {
    final isSelected = currentLanguage == language.code;
    
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.outline.withOpacity(0.3),
          width: isSelected ? 2 : 1,
        ),
        color: isSelected
            ? Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3)
            : Colors.transparent,
      ),
      child: ListTile(
        leading: Text(
          language.flag,
          style: const TextStyle(fontSize: 24),
        ),
        title: Text(
          language.name,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurface,
          ),
        ),
        subtitle: Text(
          language.nativeName,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        trailing: isSelected
            ? Icon(
                Icons.check_circle,
                color: Theme.of(context).colorScheme.primary,
              )
            : null,
        onTap: () => onLanguageChanged(language.code),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}

class LanguageOption {
  final String code;
  final String name;
  final String nativeName;
  final String flag;

  const LanguageOption(this.code, this.name, this.nativeName, this.flag);
}