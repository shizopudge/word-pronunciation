import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:word_pronunciation/src/features/app/bloc/core_initialization.dart';
import 'package:word_pronunciation/src/features/app/di/core_dependencies_scope.dart';
import 'package:word_pronunciation/src/features/app/di/core_initialization_scope.dart';
import 'package:word_pronunciation/src/features/app/presentation/app.dart';

void main() => runApp(
      CoreInitializationScope(
        builder: (context) =>
            BlocBuilder<CoreInitializationBloc, CoreInitializationState>(
          bloc: CoreInitializationScope.of(context).bloc,
          builder: (context, state) => state.maybeWhen(
            // TODO: app placeholder/splash and error
            orElse: Placeholder.new,
            success: (coreDependencies) => CoreDependenciesScope(
              coreDependencies: coreDependencies,
              child: const App(),
            ),
          ),
        ),
      ),
    );
