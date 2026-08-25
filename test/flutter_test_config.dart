import 'dart:async';

import 'package:alchemist/alchemist.dart';

/// Global golden-test hook: CI goldens render Ahem block fonts
/// deterministically so goldens stay OS-independent.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  return AlchemistConfig.runWithConfig(
    config: const AlchemistConfig(
      ciGoldensConfig: CiGoldensConfig(enabled: true),
    ),
    run: testMain,
  );
}
