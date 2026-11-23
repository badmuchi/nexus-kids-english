import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:english_for_children/core/result/result.dart';
import 'package:english_for_children/features/badges/domain/entities/badge_entity.dart';
import 'package:english_for_children/features/badges/domain/repositories/badges_repository.dart';
import 'package:english_for_children/features/badges/presentation/badges_bloc.dart';
import 'package:english_for_children/features/badges/presentation/badges_event.dart';
import 'package:english_for_children/features/badges/presentation/badges_state.dart';

class MockBadgesRepository extends Mock implements BadgesRepository {}

void main() {
  late MockBadgesRepository mockRepository;

  const sampleBadge = BadgeEntity(
    id: 'badge_01',
    title: 'Снайпер времен',
    description: '100% точность в заданиях 20–28',
    icon: 'gps_fixed',
    category: 'OGE',
    isUnlocked: true,
  );

  setUp(() {
    mockRepository = MockBadgesRepository();
  });

  group('BadgesBloc Tests', () {
    test('initial state is BadgesInitial', () {
      final bloc = BadgesBloc(repository: mockRepository);
      expect(bloc.state, const BadgesInitial());
    });

    blocTest<BadgesBloc, BadgesState>(
      'emits [BadgesLoading, BadgesLoaded] when LoadBadgesEvent succeeds',
      build: () {
        when(() => mockRepository.getAllBadges())
            .thenAnswer((_) async => const Result.success([sampleBadge]));
        return BadgesBloc(repository: mockRepository);
      },
      act: (bloc) => bloc.add(const LoadBadgesEvent()),
      expect: () => [
        const BadgesLoading(),
        const BadgesLoaded([sampleBadge]),
      ],
    );

    blocTest<BadgesBloc, BadgesState>(
      'unlocks badge and reloads badges on UnlockBadgeEvent',
      build: () {
        when(() => mockRepository.unlockBadge('badge_01'))
            .thenAnswer((_) async => const Result.success(null));
        when(() => mockRepository.getAllBadges())
            .thenAnswer((_) async => const Result.success([sampleBadge]));
        return BadgesBloc(repository: mockRepository);
      },
      act: (bloc) => bloc.add(const UnlockBadgeEvent('badge_01')),
      verify: (_) {
        verify(() => mockRepository.unlockBadge('badge_01')).called(1);
        verify(() => mockRepository.getAllBadges()).called(1);
      },
    );
  });
}
