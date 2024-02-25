import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:word_pronunciation/src/features/word/domain/entity/word_history_filter.dart';

part 'word_history_filter.freezed.dart';

@freezed
class WordHistoryFilterEvent with _$WordHistoryFilterEvent {
  const factory WordHistoryFilterEvent.select({
    required final WordHistoryFilter filter,
  }) = _SelectWordHistoryFilterEvent;
}

/// {@template word_history_filter_bloc}
/// Блок фильтра истории
/// {@endtemplate}
class WordHistoryFilterBloc
    extends Bloc<WordHistoryFilterEvent, WordHistoryFilter> {
  /// {@macro word_history_filter_bloc}
  WordHistoryFilterBloc() : super(WordHistoryFilter.all) {
    on<WordHistoryFilterEvent>(
      (event, emit) => event.map(
        select: (event) => _select(event, emit),
      ),
    );
  }

  void _select(_SelectWordHistoryFilterEvent event,
          Emitter<WordHistoryFilter> emit) =>
      emit(event.filter);
}
