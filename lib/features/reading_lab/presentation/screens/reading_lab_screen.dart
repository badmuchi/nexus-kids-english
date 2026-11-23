import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/audio/hybrid_audio_playback_service.dart';
import '../../../../core/theme/app_theme.dart';
import '../reading_lab_bloc.dart';
import '../reading_lab_event.dart';
import '../reading_lab_state.dart';
import 'reading_story_reader_screen.dart';

class ReadingLabScreen extends StatefulWidget {
  final HybridAudioPlaybackService audioService;

  const ReadingLabScreen({
    super.key,
    required this.audioService,
  });

  @override
  State<ReadingLabScreen> createState() => _ReadingLabScreenState();
}

class _ReadingLabScreenState extends State<ReadingLabScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ReadingLabBloc>().add(const LoadReadingStoriesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📚 Reading Lab (Смысловое чтение)'),
      ),
      body: BlocBuilder<ReadingLabBloc, ReadingLabState>(
        builder: (context, state) {
          return switch (state) {
            ReadingLabInitial() || ReadingLabLoading() =>
              const Center(child: CircularProgressIndicator()),
            ReadingLabErrorState(message: final m) => Center(child: Text('Ошибка: $m')),
            ReadingLabLoaded() => _buildLoadedBody(context, state),
          };
        },
      ),
    );
  }

  Widget _buildLoadedBody(BuildContext context, ReadingLabLoaded state) {
    return Column(
      children: [
        // Grade Filter Chips
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              const Text('Класс: ', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(width: 8),
              ChoiceChip(
                label: const Text('Все'),
                selected: state.selectedGrade == null,
                selectedColor: AppTheme.primaryColor.withAlpha(40),
                onSelected: (selected) {
                  if (selected) {
                    context.read<ReadingLabBloc>().add(const FilterStoriesByGradeEvent(null));
                  }
                },
              ),
              const SizedBox(width: 8),
              for (final grade in [5, 6, 7]) ...[
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text('$grade класс'),
                    selected: state.selectedGrade == grade,
                    selectedColor: AppTheme.primaryColor.withAlpha(40),
                    onSelected: (selected) {
                      if (selected) {
                        context.read<ReadingLabBloc>().add(FilterStoriesByGradeEvent(grade));
                      }
                    },
                  ),
                ),
              ],
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: state.displayedStories.length,
            itemBuilder: (context, idx) {
              final story = state.displayedStories[idx];
              return Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                margin: const EdgeInsets.only(bottom: 14),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => BlocProvider.value(
                          value: context.read<ReadingLabBloc>(),
                          child: ReadingStoryReaderScreen(
                            story: story,
                            audioService: widget.audioService,
                          ),
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withAlpha(20),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          alignment: Alignment.center,
                          child: Text(story.coverEmoji, style: const TextStyle(fontSize: 28)),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade100,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      '${story.grade} класс',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey.shade800,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    story.theme,
                                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                story.title,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                story.summary,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  if (story.isCompleted)
                                    Text(
                                      'Решено: ${story.quizScore}/${story.questions.length} ⭐',
                                      style: const TextStyle(
                                        color: AppTheme.successColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    )
                                  else
                                    Text(
                                      '3 вопроса теста',
                                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                                    ),
                                  const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
