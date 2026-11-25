import '../../../../core/result/result.dart';
import '../../../mistakes/domain/entities/mistake_entity.dart';
import '../../domain/entities/knowledge_node_entity.dart';
import '../../domain/repositories/knowledge_map_repository.dart';

class LocalKnowledgeMapRepository implements KnowledgeMapRepository {
  final List<KnowledgeNodeEntity> _nodes = [
    const KnowledgeNodeEntity(
      id: 'node_present_simple',
      title: 'Present Simple & Continuous',
      category: 'TENSES',
      cefrLevel: 'A2',
      masteryLevel: NodeMasteryLevel.mastered,
      masteryPercent: 95,
      ruleSummary:
          'Present Simple для регулярных действий и расписания (V/Vs). Present Continuous для момента речи и временных ситуаций (am/is/are + V-ing).',
      examples: [
        'Water boils at 100 degrees Celsius.',
        'Right now, our school team is practicing in the gym.',
      ],
      targetScreenRoute: 'GRAMMAR',
      connectedNodeIds: ['node_past_simple', 'node_present_perfect'],
    ),
    const KnowledgeNodeEntity(
      id: 'node_past_simple',
      title: 'Past Simple & Irregular Verbs',
      category: 'TENSES',
      cefrLevel: 'A2',
      masteryLevel: NodeMasteryLevel.needsReview,
      masteryPercent: 60,
      ruleSummary:
          'Действие завершилось в определенный момент в прошлом (yesterday, last summer, in 2022). Для неправильных глаголов используется 2-я форма (took, went, saw), а не 3-я!',
      examples: [
        'Last summer, our class took a fascinating trip to Lake Baikal.',
        'She saw her old friend two days ago.',
      ],
      targetScreenRoute: 'GRAMMAR',
      connectedNodeIds: ['node_present_simple', 'node_present_perfect', 'node_passive_voice'],
    ),
    const KnowledgeNodeEntity(
      id: 'node_present_perfect',
      title: 'Present Perfect (Result vs Time)',
      category: 'TENSES',
      cefrLevel: 'B1',
      masteryLevel: NodeMasteryLevel.inProgress,
      masteryPercent: 75,
      ruleSummary:
          'Связь прошлого действия с настоящим результатом. Маркеры: already, just, yet, ever, never, recently. Формула: have/has + V3.',
      examples: [
        'I have already finished all my English homework.',
        'Have you ever seen an Arctic fox in the wild?',
      ],
      targetScreenRoute: 'GRAMMAR',
      connectedNodeIds: ['node_present_simple', 'node_past_simple'],
    ),
    const KnowledgeNodeEntity(
      id: 'node_passive_voice',
      title: 'Passive Voice (Present & Past)',
      category: 'PASSIVE',
      cefrLevel: 'B1',
      masteryLevel: NodeMasteryLevel.inProgress,
      masteryPercent: 70,
      ruleSummary:
          'Фокус на объекте или результате действия. Формула: to be (is/are/was/were) + Past Participle (V3).',
      examples: [
        ' Lake Baikal is visited by thousands of eco-tourists every year.',
        'The mobile application was developed by Russian high school students.',
      ],
      targetScreenRoute: 'GRAMMAR',
      connectedNodeIds: ['node_past_simple'],
    ),
    const KnowledgeNodeEntity(
      id: 'node_conditionals_1',
      title: 'Conditionals Type 1 (Real)',
      category: 'CONDITIONALS',
      cefrLevel: 'A2',
      masteryLevel: NodeMasteryLevel.mastered,
      masteryPercent: 90,
      ruleSummary:
          'Реальное условие в будущем. В придаточном с if используется Present Simple, в главном — will + V.',
      examples: [
        'If the weather is sunny tomorrow, we will go cycling in the park.',
      ],
      targetScreenRoute: 'GRAMMAR',
      connectedNodeIds: ['node_conditionals_2'],
    ),
    const KnowledgeNodeEntity(
      id: 'node_conditionals_2',
      title: 'Conditionals Type 2 (Unreal)',
      category: 'CONDITIONALS',
      cefrLevel: 'B1',
      masteryLevel: NodeMasteryLevel.needsReview,
      masteryPercent: 55,
      ruleSummary:
          'Нереальное или маловероятное условие в настоящем/будущем (мечты, гипотезы). Формула: If + Past Simple (had/were), would + V.',
      examples: [
        'If I had more spare time, I would definitely learn how to play guitar.',
        'If I were you, I would consult an expert.',
      ],
      targetScreenRoute: 'GRAMMAR',
      connectedNodeIds: ['node_conditionals_1'],
    ),
    const KnowledgeNodeEntity(
      id: 'node_reported_speech',
      title: 'Reported Speech & Questions',
      category: 'TENSES',
      cefrLevel: 'B1',
      masteryLevel: NodeMasteryLevel.inProgress,
      masteryPercent: 68,
      ruleSummary:
          'Правило согласования времен: Present Simple → Past Simple, will → would. В косвенных вопросах прямой порядок слов (подлежащее перед сказуемым).',
      examples: [
        'He said that he was preparing for the OGE exam.',
        'She asked me where I lived.',
      ],
      targetScreenRoute: 'GRAMMAR',
      connectedNodeIds: ['node_past_simple'],
    ),
    const KnowledgeNodeEntity(
      id: 'node_prefix_neg',
      title: 'Negative Prefixes (un-, im-, in-)',
      category: 'WORD_FORMATION',
      cefrLevel: 'A2',
      masteryLevel: NodeMasteryLevel.needsReview,
      masteryPercent: 50,
      ruleSummary:
          'Отрицательные приставки: im- перед p/m (impossible, polite → impolite), in- (convenient → inconvenient), un- (happy → unhappy, known → unknown), dis- (agree → disagree).',
      examples: [
        'It is impossible for humans to survive in deep space without a suit.',
        'His unexpected arrival surprised everyone.',
      ],
      targetScreenRoute: 'WORD_FORMATION',
      connectedNodeIds: ['node_suffix_nouns', 'node_suffix_adj'],
    ),
    const KnowledgeNodeEntity(
      id: 'node_suffix_nouns',
      title: 'Noun Suffixes (-tion, -ment, -ness)',
      category: 'WORD_FORMATION',
      cefrLevel: 'A2',
      masteryLevel: NodeMasteryLevel.mastered,
      masteryPercent: 88,
      ruleSummary:
          'Образование существительных: -tion (pollute → pollution, educate → education), -ment (develop → development), -ness (kind → kindness), -er/-or (invent → inventor).',
      examples: [
        'Environmental protection is a top priority worldwide.',
        'Her kindness made a big difference.',
      ],
      targetScreenRoute: 'WORD_FORMATION',
      connectedNodeIds: ['node_prefix_neg', 'node_suffix_adj'],
    ),
    const KnowledgeNodeEntity(
      id: 'node_suffix_adj',
      title: 'Adjective Suffixes (-ful, -less, -able)',
      category: 'WORD_FORMATION',
      cefrLevel: 'B1',
      masteryLevel: NodeMasteryLevel.inProgress,
      masteryPercent: 78,
      ruleSummary:
          'Суффиксы прилагательных: -ful (use → useful, care → careful), -less (careless, helpless), -able (comfort → comfortable), -ous (danger → dangerous), -y (wind → windy).',
      examples: [
        'Smartphones are extremely useful for collaborative research.',
        'It was a wonderful experience for our youth club.',
      ],
      targetScreenRoute: 'WORD_FORMATION',
      connectedNodeIds: ['node_suffix_nouns', 'node_suffix_adv'],
    ),
    const KnowledgeNodeEntity(
      id: 'node_suffix_adv',
      title: 'Adverb Suffixes (-ly)',
      category: 'WORD_FORMATION',
      cefrLevel: 'A2',
      masteryLevel: NodeMasteryLevel.mastered,
      masteryPercent: 92,
      ruleSummary:
          'Образование наречий: прилагательное + -ly (quick → quickly, absolute → absolutely). При окончании на -y: y меняется на i (easy → easily).',
      examples: [
        'The candidate answered all assistant questions fluently and clearly.',
      ],
      targetScreenRoute: 'WORD_FORMATION',
      connectedNodeIds: ['node_suffix_adj'],
    ),
    const KnowledgeNodeEntity(
      id: 'node_lexis_global',
      title: 'IB MYP Global Contexts Lexis',
      category: 'LEXIS',
      cefrLevel: 'B1',
      masteryLevel: NodeMasteryLevel.mastered,
      masteryPercent: 85,
      ruleSummary:
          'Академическая лексика глобальных контекстов: Digital Footprint, Ethical AI, Climate Balance, Youth Culture, Cognitive Health.',
      examples: [
        'Adolescents should cultivate intentional digital balance.',
        'Sustainable technological solutions benefit urban communities.',
      ],
      targetScreenRoute: 'SRS',
      connectedNodeIds: ['node_suffix_adj', 'node_conditionals_2'],
    ),
  ];

  @override
  Future<Result<List<KnowledgeNodeEntity>>> getKnowledgeNodes() async {
    return Result.success(List.unmodifiable(_nodes));
  }

  @override
  Future<Result<List<KnowledgeNodeEntity>>> syncWithMistakes(List<MistakeEntity> mistakes) async {
    final unresolved = mistakes.where((m) => !m.isResolved).toList();

    final updated = _nodes.map((node) {
      if (node.id == 'node_past_simple') {
        final hasPastMistake = unresolved.any((m) =>
            m.prompt.contains('TAKE') || m.wrongAnswer.contains('taken') || m.correctAnswer == 'took');
        if (hasPastMistake) {
          return node.copyWith(
            masteryLevel: NodeMasteryLevel.needsReview,
            masteryPercent: 50,
          );
        }
      }

      if (node.id == 'node_conditionals_2') {
        final hasCondMistake = unresolved.any((m) =>
            m.prompt.contains('HAVE') || m.correctAnswer == 'had');
        if (hasCondMistake) {
          return node.copyWith(
            masteryLevel: NodeMasteryLevel.needsReview,
            masteryPercent: 45,
          );
        }
      }

      if (node.id == 'node_prefix_neg') {
        final hasPrefixMistake = unresolved.any((m) =>
            m.taskType == 'WORD_FORMATION' || m.wrongAnswer.contains('unpossible'));
        if (hasPrefixMistake) {
          return node.copyWith(
            masteryLevel: NodeMasteryLevel.needsReview,
            masteryPercent: 40,
          );
        }
      }

      return node;
    }).toList();

    return Result.success(updated);
  }
}
