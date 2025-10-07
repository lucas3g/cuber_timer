import 'package:cuber_timer/app/core/domain/entities/app_language.dart';
import 'package:cuber_timer/app/shared/translate/translate.dart';
import 'package:flutter/material.dart';

import '../../../di/dependency_injection.dart';
import '../../../shared/services/locale_service.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final LocaleService _localeService = getIt<LocaleService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(translate('settings_page.title_appbar')),
      ),
      body: AnimatedBuilder(
        animation: _localeService,
        builder: (context, child) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  translate('settings_page.language_section_title'),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),
                _LanguageCard(
                  language: translate('settings_page.portuguese'),
                  languageEnum: AppLanguage.portuguese,
                  flagEmoji: '🇧🇷',
                  isSelected: _localeService.currentLanguage == AppLanguage.portuguese,
                  onTap: () => _changeLanguage(AppLanguage.portuguese),
                ),
                const SizedBox(height: 12),
                _LanguageCard(
                  language: translate('settings_page.english'),
                  languageEnum: AppLanguage.english,
                  flagEmoji: '🇺🇸',
                  isSelected: _localeService.currentLanguage == AppLanguage.english,
                  onTap: () => _changeLanguage(AppLanguage.english),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _changeLanguage(AppLanguage language) async {
    if (_localeService.currentLanguage == language) return;

    await _localeService.changeLocale(language.locale);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(translate('settings_page.language_changed')),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

class _LanguageCard extends StatelessWidget {
  final String language;
  final AppLanguage languageEnum;
  final String flagEmoji;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageCard({
    required this.language,
    required this.languageEnum,
    required this.flagEmoji,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isSelected ? 4 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Colors.transparent,
          width: 2,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: isSelected ? null : onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Text(
                flagEmoji,
                style: const TextStyle(fontSize: 32),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  language,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: Theme.of(context).colorScheme.primary,
                  size: 28,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
