// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_initialization.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$AppInitializationEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initialize,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initialize,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initialize,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_InitializeEvent value) initialize,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_InitializeEvent value)? initialize,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_InitializeEvent value)? initialize,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppInitializationEventCopyWith<$Res> {
  factory $AppInitializationEventCopyWith(AppInitializationEvent value,
          $Res Function(AppInitializationEvent) then) =
      _$AppInitializationEventCopyWithImpl<$Res, AppInitializationEvent>;
}

/// @nodoc
class _$AppInitializationEventCopyWithImpl<$Res,
        $Val extends AppInitializationEvent>
    implements $AppInitializationEventCopyWith<$Res> {
  _$AppInitializationEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$InitializeEventImplCopyWith<$Res> {
  factory _$$InitializeEventImplCopyWith(_$InitializeEventImpl value,
          $Res Function(_$InitializeEventImpl) then) =
      __$$InitializeEventImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$InitializeEventImplCopyWithImpl<$Res>
    extends _$AppInitializationEventCopyWithImpl<$Res, _$InitializeEventImpl>
    implements _$$InitializeEventImplCopyWith<$Res> {
  __$$InitializeEventImplCopyWithImpl(
      _$InitializeEventImpl _value, $Res Function(_$InitializeEventImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$InitializeEventImpl implements _InitializeEvent {
  const _$InitializeEventImpl();

  @override
  String toString() {
    return 'AppInitializationEvent.initialize()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$InitializeEventImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initialize,
  }) {
    return initialize();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initialize,
  }) {
    return initialize?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initialize,
    required TResult orElse(),
  }) {
    if (initialize != null) {
      return initialize();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_InitializeEvent value) initialize,
  }) {
    return initialize(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_InitializeEvent value)? initialize,
  }) {
    return initialize?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_InitializeEvent value)? initialize,
    required TResult orElse(),
  }) {
    if (initialize != null) {
      return initialize(this);
    }
    return orElse();
  }
}

abstract class _InitializeEvent implements AppInitializationEvent {
  const factory _InitializeEvent() = _$InitializeEventImpl;
}

/// @nodoc
mixin _$AppInitializationState {
  InitializationProgress get initializationProgress =>
      throw _privateConstructorUsedError;
  Dependencies? get dependencies => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(InitializationProgress initializationProgress,
            Dependencies? dependencies)
        progress,
    required TResult Function(InitializationProgress initializationProgress,
            Dependencies dependencies)
        success,
    required TResult Function(
            String message,
            InitializationProgress initializationProgress,
            Dependencies? dependencies)
        error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(InitializationProgress initializationProgress,
            Dependencies? dependencies)?
        progress,
    TResult? Function(InitializationProgress initializationProgress,
            Dependencies dependencies)?
        success,
    TResult? Function(
            String message,
            InitializationProgress initializationProgress,
            Dependencies? dependencies)?
        error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(InitializationProgress initializationProgress,
            Dependencies? dependencies)?
        progress,
    TResult Function(InitializationProgress initializationProgress,
            Dependencies dependencies)?
        success,
    TResult Function(
            String message,
            InitializationProgress initializationProgress,
            Dependencies? dependencies)?
        error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ProgressInitializationState value) progress,
    required TResult Function(_SuccessInitializationState value) success,
    required TResult Function(_ErrorInitializationState value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ProgressInitializationState value)? progress,
    TResult? Function(_SuccessInitializationState value)? success,
    TResult? Function(_ErrorInitializationState value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ProgressInitializationState value)? progress,
    TResult Function(_SuccessInitializationState value)? success,
    TResult Function(_ErrorInitializationState value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AppInitializationStateCopyWith<AppInitializationState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppInitializationStateCopyWith<$Res> {
  factory $AppInitializationStateCopyWith(AppInitializationState value,
          $Res Function(AppInitializationState) then) =
      _$AppInitializationStateCopyWithImpl<$Res, AppInitializationState>;
  @useResult
  $Res call(
      {InitializationProgress initializationProgress,
      Dependencies dependencies});
}

/// @nodoc
class _$AppInitializationStateCopyWithImpl<$Res,
        $Val extends AppInitializationState>
    implements $AppInitializationStateCopyWith<$Res> {
  _$AppInitializationStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? initializationProgress = null,
    Object? dependencies = null,
  }) {
    return _then(_value.copyWith(
      initializationProgress: null == initializationProgress
          ? _value.initializationProgress
          : initializationProgress // ignore: cast_nullable_to_non_nullable
              as InitializationProgress,
      dependencies: null == dependencies
          ? _value.dependencies!
          : dependencies // ignore: cast_nullable_to_non_nullable
              as Dependencies,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProgressInitializationStateImplCopyWith<$Res>
    implements $AppInitializationStateCopyWith<$Res> {
  factory _$$ProgressInitializationStateImplCopyWith(
          _$ProgressInitializationStateImpl value,
          $Res Function(_$ProgressInitializationStateImpl) then) =
      __$$ProgressInitializationStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {InitializationProgress initializationProgress,
      Dependencies? dependencies});
}

/// @nodoc
class __$$ProgressInitializationStateImplCopyWithImpl<$Res>
    extends _$AppInitializationStateCopyWithImpl<$Res,
        _$ProgressInitializationStateImpl>
    implements _$$ProgressInitializationStateImplCopyWith<$Res> {
  __$$ProgressInitializationStateImplCopyWithImpl(
      _$ProgressInitializationStateImpl _value,
      $Res Function(_$ProgressInitializationStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? initializationProgress = null,
    Object? dependencies = freezed,
  }) {
    return _then(_$ProgressInitializationStateImpl(
      initializationProgress: null == initializationProgress
          ? _value.initializationProgress
          : initializationProgress // ignore: cast_nullable_to_non_nullable
              as InitializationProgress,
      dependencies: freezed == dependencies
          ? _value.dependencies
          : dependencies // ignore: cast_nullable_to_non_nullable
              as Dependencies?,
    ));
  }
}

/// @nodoc

class _$ProgressInitializationStateImpl
    implements _ProgressInitializationState {
  const _$ProgressInitializationStateImpl(
      {this.initializationProgress = InitializationProgress.initial,
      this.dependencies});

  @override
  @JsonKey()
  final InitializationProgress initializationProgress;
  @override
  final Dependencies? dependencies;

  @override
  String toString() {
    return 'AppInitializationState.progress(initializationProgress: $initializationProgress, dependencies: $dependencies)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProgressInitializationStateImpl &&
            (identical(other.initializationProgress, initializationProgress) ||
                other.initializationProgress == initializationProgress) &&
            (identical(other.dependencies, dependencies) ||
                other.dependencies == dependencies));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, initializationProgress, dependencies);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ProgressInitializationStateImplCopyWith<_$ProgressInitializationStateImpl>
      get copyWith => __$$ProgressInitializationStateImplCopyWithImpl<
          _$ProgressInitializationStateImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(InitializationProgress initializationProgress,
            Dependencies? dependencies)
        progress,
    required TResult Function(InitializationProgress initializationProgress,
            Dependencies dependencies)
        success,
    required TResult Function(
            String message,
            InitializationProgress initializationProgress,
            Dependencies? dependencies)
        error,
  }) {
    return progress(initializationProgress, dependencies);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(InitializationProgress initializationProgress,
            Dependencies? dependencies)?
        progress,
    TResult? Function(InitializationProgress initializationProgress,
            Dependencies dependencies)?
        success,
    TResult? Function(
            String message,
            InitializationProgress initializationProgress,
            Dependencies? dependencies)?
        error,
  }) {
    return progress?.call(initializationProgress, dependencies);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(InitializationProgress initializationProgress,
            Dependencies? dependencies)?
        progress,
    TResult Function(InitializationProgress initializationProgress,
            Dependencies dependencies)?
        success,
    TResult Function(
            String message,
            InitializationProgress initializationProgress,
            Dependencies? dependencies)?
        error,
    required TResult orElse(),
  }) {
    if (progress != null) {
      return progress(initializationProgress, dependencies);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ProgressInitializationState value) progress,
    required TResult Function(_SuccessInitializationState value) success,
    required TResult Function(_ErrorInitializationState value) error,
  }) {
    return progress(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ProgressInitializationState value)? progress,
    TResult? Function(_SuccessInitializationState value)? success,
    TResult? Function(_ErrorInitializationState value)? error,
  }) {
    return progress?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ProgressInitializationState value)? progress,
    TResult Function(_SuccessInitializationState value)? success,
    TResult Function(_ErrorInitializationState value)? error,
    required TResult orElse(),
  }) {
    if (progress != null) {
      return progress(this);
    }
    return orElse();
  }
}

abstract class _ProgressInitializationState implements AppInitializationState {
  const factory _ProgressInitializationState(
      {final InitializationProgress initializationProgress,
      final Dependencies? dependencies}) = _$ProgressInitializationStateImpl;

  @override
  InitializationProgress get initializationProgress;
  @override
  Dependencies? get dependencies;
  @override
  @JsonKey(ignore: true)
  _$$ProgressInitializationStateImplCopyWith<_$ProgressInitializationStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SuccessInitializationStateImplCopyWith<$Res>
    implements $AppInitializationStateCopyWith<$Res> {
  factory _$$SuccessInitializationStateImplCopyWith(
          _$SuccessInitializationStateImpl value,
          $Res Function(_$SuccessInitializationStateImpl) then) =
      __$$SuccessInitializationStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {InitializationProgress initializationProgress,
      Dependencies dependencies});
}

/// @nodoc
class __$$SuccessInitializationStateImplCopyWithImpl<$Res>
    extends _$AppInitializationStateCopyWithImpl<$Res,
        _$SuccessInitializationStateImpl>
    implements _$$SuccessInitializationStateImplCopyWith<$Res> {
  __$$SuccessInitializationStateImplCopyWithImpl(
      _$SuccessInitializationStateImpl _value,
      $Res Function(_$SuccessInitializationStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? initializationProgress = null,
    Object? dependencies = null,
  }) {
    return _then(_$SuccessInitializationStateImpl(
      initializationProgress: null == initializationProgress
          ? _value.initializationProgress
          : initializationProgress // ignore: cast_nullable_to_non_nullable
              as InitializationProgress,
      dependencies: null == dependencies
          ? _value.dependencies
          : dependencies // ignore: cast_nullable_to_non_nullable
              as Dependencies,
    ));
  }
}

/// @nodoc

class _$SuccessInitializationStateImpl implements _SuccessInitializationState {
  const _$SuccessInitializationStateImpl(
      {required this.initializationProgress, required this.dependencies});

  @override
  final InitializationProgress initializationProgress;
  @override
  final Dependencies dependencies;

  @override
  String toString() {
    return 'AppInitializationState.success(initializationProgress: $initializationProgress, dependencies: $dependencies)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SuccessInitializationStateImpl &&
            (identical(other.initializationProgress, initializationProgress) ||
                other.initializationProgress == initializationProgress) &&
            (identical(other.dependencies, dependencies) ||
                other.dependencies == dependencies));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, initializationProgress, dependencies);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SuccessInitializationStateImplCopyWith<_$SuccessInitializationStateImpl>
      get copyWith => __$$SuccessInitializationStateImplCopyWithImpl<
          _$SuccessInitializationStateImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(InitializationProgress initializationProgress,
            Dependencies? dependencies)
        progress,
    required TResult Function(InitializationProgress initializationProgress,
            Dependencies dependencies)
        success,
    required TResult Function(
            String message,
            InitializationProgress initializationProgress,
            Dependencies? dependencies)
        error,
  }) {
    return success(initializationProgress, dependencies);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(InitializationProgress initializationProgress,
            Dependencies? dependencies)?
        progress,
    TResult? Function(InitializationProgress initializationProgress,
            Dependencies dependencies)?
        success,
    TResult? Function(
            String message,
            InitializationProgress initializationProgress,
            Dependencies? dependencies)?
        error,
  }) {
    return success?.call(initializationProgress, dependencies);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(InitializationProgress initializationProgress,
            Dependencies? dependencies)?
        progress,
    TResult Function(InitializationProgress initializationProgress,
            Dependencies dependencies)?
        success,
    TResult Function(
            String message,
            InitializationProgress initializationProgress,
            Dependencies? dependencies)?
        error,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(initializationProgress, dependencies);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ProgressInitializationState value) progress,
    required TResult Function(_SuccessInitializationState value) success,
    required TResult Function(_ErrorInitializationState value) error,
  }) {
    return success(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ProgressInitializationState value)? progress,
    TResult? Function(_SuccessInitializationState value)? success,
    TResult? Function(_ErrorInitializationState value)? error,
  }) {
    return success?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ProgressInitializationState value)? progress,
    TResult Function(_SuccessInitializationState value)? success,
    TResult Function(_ErrorInitializationState value)? error,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(this);
    }
    return orElse();
  }
}

abstract class _SuccessInitializationState implements AppInitializationState {
  const factory _SuccessInitializationState(
          {required final InitializationProgress initializationProgress,
          required final Dependencies dependencies}) =
      _$SuccessInitializationStateImpl;

  @override
  InitializationProgress get initializationProgress;
  @override
  Dependencies get dependencies;
  @override
  @JsonKey(ignore: true)
  _$$SuccessInitializationStateImplCopyWith<_$SuccessInitializationStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ErrorInitializationStateImplCopyWith<$Res>
    implements $AppInitializationStateCopyWith<$Res> {
  factory _$$ErrorInitializationStateImplCopyWith(
          _$ErrorInitializationStateImpl value,
          $Res Function(_$ErrorInitializationStateImpl) then) =
      __$$ErrorInitializationStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String message,
      InitializationProgress initializationProgress,
      Dependencies? dependencies});
}

/// @nodoc
class __$$ErrorInitializationStateImplCopyWithImpl<$Res>
    extends _$AppInitializationStateCopyWithImpl<$Res,
        _$ErrorInitializationStateImpl>
    implements _$$ErrorInitializationStateImplCopyWith<$Res> {
  __$$ErrorInitializationStateImplCopyWithImpl(
      _$ErrorInitializationStateImpl _value,
      $Res Function(_$ErrorInitializationStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? initializationProgress = null,
    Object? dependencies = freezed,
  }) {
    return _then(_$ErrorInitializationStateImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      initializationProgress: null == initializationProgress
          ? _value.initializationProgress
          : initializationProgress // ignore: cast_nullable_to_non_nullable
              as InitializationProgress,
      dependencies: freezed == dependencies
          ? _value.dependencies
          : dependencies // ignore: cast_nullable_to_non_nullable
              as Dependencies?,
    ));
  }
}

/// @nodoc

class _$ErrorInitializationStateImpl implements _ErrorInitializationState {
  const _$ErrorInitializationStateImpl(
      {required this.message,
      required this.initializationProgress,
      this.dependencies});

  @override
  final String message;
  @override
  final InitializationProgress initializationProgress;
  @override
  final Dependencies? dependencies;

  @override
  String toString() {
    return 'AppInitializationState.error(message: $message, initializationProgress: $initializationProgress, dependencies: $dependencies)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ErrorInitializationStateImpl &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.initializationProgress, initializationProgress) ||
                other.initializationProgress == initializationProgress) &&
            (identical(other.dependencies, dependencies) ||
                other.dependencies == dependencies));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, message, initializationProgress, dependencies);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ErrorInitializationStateImplCopyWith<_$ErrorInitializationStateImpl>
      get copyWith => __$$ErrorInitializationStateImplCopyWithImpl<
          _$ErrorInitializationStateImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(InitializationProgress initializationProgress,
            Dependencies? dependencies)
        progress,
    required TResult Function(InitializationProgress initializationProgress,
            Dependencies dependencies)
        success,
    required TResult Function(
            String message,
            InitializationProgress initializationProgress,
            Dependencies? dependencies)
        error,
  }) {
    return error(message, initializationProgress, dependencies);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(InitializationProgress initializationProgress,
            Dependencies? dependencies)?
        progress,
    TResult? Function(InitializationProgress initializationProgress,
            Dependencies dependencies)?
        success,
    TResult? Function(
            String message,
            InitializationProgress initializationProgress,
            Dependencies? dependencies)?
        error,
  }) {
    return error?.call(message, initializationProgress, dependencies);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(InitializationProgress initializationProgress,
            Dependencies? dependencies)?
        progress,
    TResult Function(InitializationProgress initializationProgress,
            Dependencies dependencies)?
        success,
    TResult Function(
            String message,
            InitializationProgress initializationProgress,
            Dependencies? dependencies)?
        error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(message, initializationProgress, dependencies);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ProgressInitializationState value) progress,
    required TResult Function(_SuccessInitializationState value) success,
    required TResult Function(_ErrorInitializationState value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ProgressInitializationState value)? progress,
    TResult? Function(_SuccessInitializationState value)? success,
    TResult? Function(_ErrorInitializationState value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ProgressInitializationState value)? progress,
    TResult Function(_SuccessInitializationState value)? success,
    TResult Function(_ErrorInitializationState value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class _ErrorInitializationState implements AppInitializationState {
  const factory _ErrorInitializationState(
      {required final String message,
      required final InitializationProgress initializationProgress,
      final Dependencies? dependencies}) = _$ErrorInitializationStateImpl;

  String get message;
  @override
  InitializationProgress get initializationProgress;
  @override
  Dependencies? get dependencies;
  @override
  @JsonKey(ignore: true)
  _$$ErrorInitializationStateImplCopyWith<_$ErrorInitializationStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
