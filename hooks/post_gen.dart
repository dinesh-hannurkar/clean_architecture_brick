import 'dart:io';
import 'package:mason/mason.dart';

/// This hook runs automatically AFTER the brick is generated.
///
/// It runs `flutter pub get` to install all packages immediately.
Future<void> run(HookContext context) async {
  final logger = context.logger;
  final projectName = context.vars['project_name'];
  final appDisplayName = context.vars['app_display_name'];

  logger.info('');
  logger.success('🎉 $appDisplayName ($projectName) scaffolded successfully!');
  logger.info('');
  logger.info('📦 Running flutter pub get...');

  final result = await Process.run('flutter', ['pub', 'get'], runInShell: true);

  if (result.exitCode == 0) {
    logger.success('✅ flutter pub get completed!');
  } else {
    logger.err('❌ flutter pub get failed. Run it manually.');
    logger.detail(result.stderr.toString());
  }

  logger.info('');
  logger.info('─────────────────────────────────────────────');
  logger.success('🚀 Your project is ready!');
  logger.info('');
  logger.info('📂 Project:     $appDisplayName');
  logger.info('📦 Package:     $projectName');
  logger.info('🎨 Primary:     #${context.vars['primary_color']}');
  logger.info('🎨 Secondary:   #${context.vars['secondary_color']}');
  logger.info('');
  logger.info('Next steps:');
  logger.info('  1. Open lib/main.dart and configure your app entry point');
  logger.info('  2. Add your features in lib/features/');
  logger.info(
    '  3. Register dependencies in lib/core/data/network/injection.dart',
  );
  logger.info(
    '  4. Add routes in lib/core/presentation/navigation/app_router.dart',
  );
  logger.info('─────────────────────────────────────────────');
}
