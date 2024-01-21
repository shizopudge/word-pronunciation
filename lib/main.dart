import 'package:flutter/material.dart';
import 'package:word_pronunciation/src/features/app/di/app_initialization_scope.dart';
import 'package:word_pronunciation/src/features/app/presentation/app_initialization.dart';

void main() => runApp(
      const AppInitializationScope(
        child: AppInitialization(),
      ),
    );
