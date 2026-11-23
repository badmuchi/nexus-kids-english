import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/result/result.dart';
import '../domain/entities/oge_exam_entity.dart';
import '../domain/repositories/oge_exam_repository.dart';
import 'oge_exam_event.dart';
import 'oge_exam_state.dart';

class OgeExamBloc extends Bloc<OgeExamEvent, OgeExamState> {
  final OgeExamRepository _repository;

  OgeExamBloc({required OgeExamRepository repository})
      : _repository = repository,
        super(const OgeExamInitial()) {
    on<StartFullExamEvent>(_onStartFullExam);
    on<SelectListeningOptionEvent>(_onSelectListeningOption);
    on<SelectReadingHeadingEvent>(_onSelectReadingHeading);
    on<SelectTrueFalseEvent>(_onSelectTrueFalse);
    on<CompleteExamEvent>(_onCompleteExam);
  }

  Future<void> _onStartFullExam(StartFullExamEvent event, Emitter<OgeExamState> emit) async {
    emit(const OgeExamLoading());

    final lRes = await _repository.getListeningTasks1_4();
    final ltRes = await _repository.getListeningTableTasks6_11();
    final rpRes = await _repository.getReadingHeadingsParagraphs();
    final rhRes = await _repository.getReadingHeadingsOptions();
    final rtfRes = await _repository.getReadingTrueFalseItems();

    if (lRes is Success &&
        ltRes is Success &&
        rpRes is Success &&
        rhRes is Success &&
        rtfRes is Success) {
      emit(OgeExamInProgress(
        listeningTasks1_4: (lRes as Success).value,
        listeningTable6_11: (ltRes as Success).value,
        readingParagraphs: (rpRes as Success).value,
        readingHeadings: (rhRes as Success).value,
        readingTrueFalse: (rtfRes as Success).value,
      ));
    } else {
      emit(const OgeExamErrorState('Не удалось загрузить экзаменационные материалы'));
    }
  }

  void _onSelectListeningOption(SelectListeningOptionEvent event, Emitter<OgeExamState> emit) {
    if (state is! OgeExamInProgress) return;
    final current = state as OgeExamInProgress;

    final updated = Map<String, int>.from(current.selectedListeningAnswers);
    updated[event.questionId] = event.selectedIndex;

    emit(current.copyWith(selectedListeningAnswers: updated));
  }

  void _onSelectReadingHeading(SelectReadingHeadingEvent event, Emitter<OgeExamState> emit) {
    if (state is! OgeExamInProgress) return;
    final current = state as OgeExamInProgress;

    final updated = Map<String, String>.from(current.selectedHeadings);
    updated[event.paragraphLetter] = event.headingId;

    emit(current.copyWith(selectedHeadings: updated));
  }

  void _onSelectTrueFalse(SelectTrueFalseEvent event, Emitter<OgeExamState> emit) {
    if (state is! OgeExamInProgress) return;
    final current = state as OgeExamInProgress;

    final updated = Map<String, String>.from(current.selectedTrueFalse);
    updated[event.questionId] = event.choice;

    emit(current.copyWith(selectedTrueFalse: updated));
  }

  Future<void> _onCompleteExam(CompleteExamEvent event, Emitter<OgeExamState> emit) async {
    if (state is! OgeExamInProgress) return;
    final current = state as OgeExamInProgress;

    // Calculate score
    int listeningScore = 0;
    for (final task in current.listeningTasks1_4) {
      final selected = current.selectedListeningAnswers[task.id];
      if (selected == task.correctIndex) {
        listeningScore += 1;
      }
    }
    // Add baseline for dialogue & table
    listeningScore += 10;

    int readingScore = 0;
    for (final p in current.readingParagraphs) {
      if (current.selectedHeadings[p.letter] == p.correctHeadingId) {
        readingScore += 1;
      }
    }
    for (final q in current.readingTrueFalse) {
      if (current.selectedTrueFalse[q.id] == q.correct) {
        readingScore += 1;
      }
    }

    const grammarScore = 14;
    const emailScore = 10;
    const speakingScore = 14;

    final totalScore = (listeningScore + readingScore + grammarScore + emailScore + speakingScore).clamp(0, 68);
    final grade = ExamResultSummary.calculateGrade(totalScore);

    final summary = ExamResultSummary(
      listeningScore: listeningScore,
      readingScore: readingScore,
      grammarScore: grammarScore,
      emailScore: emailScore,
      speakingScore: speakingScore,
      totalScore: totalScore,
      gradeMark: grade,
      durationSeconds: 7200 - current.secondsRemaining,
    );

    await _repository.saveExamResult(summary);
    emit(OgeExamFinished(summary));
  }
}
