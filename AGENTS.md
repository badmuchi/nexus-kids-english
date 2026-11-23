# AGENTS.md — Архитектурный эталон (English for Children • 13 лет)

Проект: интерактивное образовательное приложение для изучения английского языка подростком 13 лет (подготовка к ОГЭ 7–9 классы РФ + International Baccalaureate MYP Phase 3/4).

## 1. Стек и принципы Clean Architecture (Feature-first)
- **UI:** Flutter Material 3, строгий LTR (`TextDirection.ltr`), современная палитра для подростков (Indigo/Cyan/Amber), карточный дизайн.
- **Стейт-менеджмент:** `flutter_bloc` + `equatable` (все стейты и события иммутабельны с `const`).
- **БД:** `drift` + `drift_flutter` (реактивные стримы SQLite, кодогенерация через `dart run build_runner build --delete-conflicting-outputs`).
- **Результаты операций:** монада `Result<T>` (`Success<T>` / `Error<T>`). Никаких `throw` в презентационный слой.
- **Озвучка:** `HybridAudioPlaybackService` (переключение UK/US естественных нейросетевых голосов TTS + локальные ассеты через `just_audio`).
- **Валидация ответов:** `EnglishAnswerEvaluator` (толерантность к 1 опечатке по Левенштейну, поддержка контракций `don't / do not`, `I'm / I am`, нормализация типографических апострофов).

## 2. Структура `lib/`
- `lib/core/`
  - `audio/`: `HybridAudioPlaybackService`, `JustAudioPlaybackService`, `TtsSpeechService`.
  - `database/`: `AppDatabase` (Drift), авто-заполнение сидов `seedDatabaseIfEmpty()`.
  - `error/`: иерархия `AppFailure` (`DatabaseFailure`, `ValidationFailure`, etc.).
  - `logging/`: `AppLogger`.
  - `result/`: монадный тип `Result<T>`.
  - `settings/`: `SecureAppSettingsStorage` (акцент US/UK, темы, цели).
  - `theme/`: `AppTheme` (Material 3 light/dark темы).
- `lib/features/dashboard/`: Главный экран-хаб с прогрессом ОГЭ, фазой IB, стриком и плитками быстрого доступа.
- `lib/features/oge_trainer/`:
  - `OgeGrammarScreen`: Задания 20–28 (видо-временные формы глаголов, пассивный залог, условные предложения 1-2, косвенная речь, степени сравнения).
  - `OgeWordFormationScreen`: Задания 29–34 (префиксы и суффиксы).
  - `OgeEmailScreen`: Задание 35 (электронное письмо с живым подсчетом 100-120 слов и чеклистом критериев).
  - `OgeSpeakingScreen`: Устная часть (задания 1-3 с таймером 1.5 мин подготовки / 2 мин речи, вопросами ассистента и планом монолога).
- `lib/features/ib_myp/`:
  - `IbUnitsScreen` & `IbUnitDetailScreen`: Юниты по Global Contexts, Statement of Inquiry, исследовательские вопросы (Factual, Conceptual, Debatable) и задания по критериям A, B, C, D.
- `lib/features/srs/`:
  - `SrsScreen`: интервальные карточки FSRS с оценкой ответов, озвучкой произношения и IPA.
- `lib/features/goals/`:
  - `GoalsScreen`: трекер рубежей (68/68 баллов ОГЭ, критерии IB, привычка 15 минут в день).

## 3. Чек-лист качества
- [x] `flutter analyze` — 0 issues.
- [x] `flutter test` — 100% pass (13/13 тестов).
- [x] Автоматический посев сидов при первом запуске из `assets/seed/`.
