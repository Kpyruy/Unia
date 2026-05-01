import 'package:flutter_test/flutter_test.dart';
import 'package:unia/l10n.dart';

void main() {
  test('Unia supports only English and Slovak locales', () {
    expect(AppL10n.supportedLocales, ['en', 'sk']);
    expect(AppL10n.of('de').locale, 'en');
  });

  test('visible app branding uses Unia', () {
    expect(AppL10n.of('en').appName, 'Unia');
    expect(AppL10n.of('sk').appName, 'Unia');
    expect(AppL10n.of('en').onboardingWelcomeTitle, 'Welcome to Unia');
    expect(AppL10n.of('sk').onboardingWelcomeTitle, 'Vitajte v Unia');
  });
}
