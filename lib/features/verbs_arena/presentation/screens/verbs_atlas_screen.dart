import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/audio/hybrid_audio_playback_service.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/irregular_verb_entity.dart';
import '../verbs_bloc.dart';
import '../verbs_event.dart';
import '../verbs_state.dart';
import 'verbs_blitz_quiz_screen.dart';

class VerbsAtlasScreen extends StatefulWidget {
  final HybridAudioPlaybackService audioService;

  const VerbsAtlasScreen({
    super.key,
    required this.audioService,
  });

  @override
  State<VerbsAtlasScreen> createState() => _VerbsAtlasScreenState();
}

class _VerbsAtlasScreenState extends State<VerbsAtlasScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    context.read<VerbsBloc>().add(const LoadAllVerbsEvent());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('⚡ Арена неправильных глаголов'),
        actions: [
          IconButton(
            icon: const Icon(Icons.flash_on, color: AppTheme.accentColor),
            tooltip: 'Блиц-квиз',
            onPressed: () {
              final state = context.read<VerbsBloc>().state;
              if (state is VerbsLoaded && state.allVerbs.isNotEmpty) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => VerbsBlitzQuizScreen(
                      allVerbs: state.allVerbs,
                      audioService: widget.audioService,
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: BlocBuilder<VerbsBloc, VerbsState>(
        builder: (context, state) {
          return switch (state) {
            VerbsInitial() || VerbsLoading() => const Center(child: CircularProgressIndicator()),
            VerbsErrorState(message: final m) => Center(child: Text('Ошибка: $m')),
            VerbsLoaded() => _buildAtlasBody(context, state),
          };
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.play_arrow),
        label: const Text('Начать Блиц-квиз!'),
        onPressed: () {
          final state = context.read<VerbsBloc>().state;
          if (state is VerbsLoaded && state.allVerbs.isNotEmpty) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => VerbsBlitzQuizScreen(
                  allVerbs: state.allVerbs,
                  audioService: widget.audioService,
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildAtlasBody(BuildContext context, VerbsLoaded state) {
    final filtered = state.displayedVerbs.where((v) {
      if (_searchQuery.isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      return v.v1.toLowerCase().contains(q) ||
          v.v2.toLowerCase().contains(q) ||
          v.v3.toLowerCase().contains(q) ||
          v.translation.toLowerCase().contains(q);
    }).toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Поиск глагола или перевода...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          _searchController.clear();
                          _searchQuery = '';
                        });
                      },
                    )
                  : null,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
            ),
            onChanged: (val) => setState(() => _searchQuery = val),
          ),
        ),
        _buildRhymeFilter(context, state),
        Expanded(
          child: filtered.isEmpty
              ? const Center(child: Text('Ничего не найдено'))
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final verb = filtered[index];
                    return _buildVerbCard(verb);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildRhymeFilter(BuildContext context, VerbsLoaded state) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Row(
        children: state.rhymeGroups.map((group) {
          final isSelected = group == state.selectedGroup;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: FilterChip(
              label: Text(group),
              selected: isSelected,
              selectedColor: AppTheme.secondaryColor.withValues(alpha: 0.2),
              onSelected: (_) {
                context.read<VerbsBloc>().add(FilterVerbsByRhymeEvent(group));
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildVerbCard(IrregularVerbEntity verb) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        verb.formsTrio,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        verb.translation,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.indigo.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.volume_up, color: AppTheme.primaryColor),
                  tooltip: 'Слушать все 3 формы',
                  onPressed: () {
                    widget.audioService.speakText('${verb.v1}, ${verb.v2}, ${verb.v3}');
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                children: [
                  const Icon(Icons.chat_bubble_outline, size: 14, color: Colors.grey),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      verb.exampleSentence,
                      style: TextStyle(fontSize: 13, color: Colors.grey.shade800, fontStyle: FontStyle.italic),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.play_circle_outline, size: 18, color: Colors.grey),
                    onPressed: () {
                      widget.audioService.speakText(verb.exampleSentence);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
