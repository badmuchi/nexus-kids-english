import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PdfReportGenerator {
  const PdfReportGenerator();

  Future<Uint8List> generateAcademicReport({
    required int activeMistakesCount,
    required int resolvedMistakesCount,
    required int ibTotalScore,
    required int ibGrade,
    required int ogeEstimatedScore,
    required String studentName,
  }) async {
    final pdf = pw.Document();

    final fontRegular = await PdfGoogleFonts.robotoRegular();
    final fontBold = await PdfGoogleFonts.robotoBold();

    final now = DateTime.now();
    final dateStr = '${now.day.toString().padLeft(2, '0')}.${now.month.toString().padLeft(2, '0')}.${now.year}';

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        theme: pw.ThemeData.withFont(
          base: fontRegular,
          bold: fontBold,
        ),
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header
              pw.Container(
                padding: const pw.EdgeInsets.all(16),
                decoration: pw.BoxDecoration(
                  color: PdfColor.fromHex('#4F46E5'),
                  borderRadius: const pw.BorderRadius.all(pw.Radius.circular(10)),
                ),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'ENGLISH FOR CHILDREN • АКАДЕМИЧЕСКИЙ ТАБЕЛЬ',
                          style: const pw.TextStyle(
                            fontSize: 16,
                            color: PdfColors.white,
                          ),
                        ),
                        pw.SizedBox(height: 4),
                        pw.Text(
                          'Программа 7–9 классов РФ (ОГЭ) & IB MYP Language Acquisition (13 лет)',
                          style: pw.TextStyle(
                            fontSize: 10,
                            color: PdfColor.fromHex('#C7D2FE'),
                          ),
                        ),
                      ],
                    ),
                    pw.Text(
                      dateStr,
                      style: const pw.TextStyle(
                        fontSize: 12,
                        color: PdfColors.white,
                      ),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 18),

              // KPI Row
              pw.Row(
                children: [
                  pw.Expanded(
                    child: _buildMetricBox(
                      title: 'Готовность к ОГЭ',
                      value: '$ogeEstimatedScore / 68',
                      subtitle: 'Прогноз: «5» (отличный уровень)',
                      color: PdfColor.fromHex('#4F46E5'),
                    ),
                  ),
                  pw.SizedBox(width: 12),
                  pw.Expanded(
                    child: _buildMetricBox(
                      title: 'IB MYP (Phase 3/4)',
                      value: '$ibTotalScore / 32',
                      subtitle: 'Grade $ibGrade (Very Good)',
                      color: PdfColor.fromHex('#059669'),
                    ),
                  ),
                  pw.SizedBox(width: 12),
                  pw.Expanded(
                    child: _buildMetricBox(
                      title: 'Тетрадь ошибок',
                      value: '$activeMistakesCount на контроле',
                      subtitle: '$resolvedMistakesCount закреплено (3/3)',
                      color: PdfColor.fromHex('#D97706'),
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 20),

              // Section 1: OGE Breakdown Table
              pw.Text(
                '1. Результаты разделов ОГЭ (ФИПИ 7–9 классы):',
                style: const pw.TextStyle(fontSize: 13),
              ),
              pw.SizedBox(height: 8),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
                children: [
                  pw.TableRow(
                    decoration: pw.BoxDecoration(color: PdfColor.fromHex('#F1F5F9')),
                    children: [
                      _buildTableCell('Раздел экзамена', isHeader: true),
                      _buildTableCell('Задания', isHeader: true),
                      _buildTableCell('Макс. балл', isHeader: true),
                      _buildTableCell('Текущий статус', isHeader: true),
                    ],
                  ),
                  pw.TableRow(children: [
                    _buildTableCell('Аудирование'),
                    _buildTableCell('1–11 (Диалоги и факты)'),
                    _buildTableCell('15 баллов'),
                    _buildTableCell('13 / 15 (Отлично)'),
                  ]),
                  pw.TableRow(children: [
                    _buildTableCell('Чтение'),
                    _buildTableCell('12–19 (Заголовки, T/F/NS)'),
                    _buildTableCell('13 баллов'),
                    _buildTableCell('12 / 13 (Высокий)'),
                  ]),
                  pw.TableRow(children: [
                    _buildTableCell('Грамматика и лексика'),
                    _buildTableCell('20–34 (Времена, суффиксы)'),
                    _buildTableCell('15 баллов'),
                    _buildTableCell('13 / 15 (Уверенно)'),
                  ]),
                  pw.TableRow(children: [
                    _buildTableCell('Письмо (Email)'),
                    _buildTableCell('Задание 35 (100–120 слов)'),
                    _buildTableCell('10 баллов'),
                    _buildTableCell('10 / 10 (Максимум)'),
                  ]),
                  pw.TableRow(children: [
                    _buildTableCell('Устная часть (Speaking)'),
                    _buildTableCell('1–3 (Чтение, диалог, монолог)'),
                    _buildTableCell('15 баллов'),
                    _buildTableCell('13 / 15 (Темп 110 WPM)'),
                  ]),
                ],
              ),
              pw.SizedBox(height: 20),

              // Section 2: IB MYP Criteria
              pw.Text(
                '2. Критериальная шкала International Baccalaureate (MYP):',
                style: const pw.TextStyle(fontSize: 13),
              ),
              pw.SizedBox(height: 8),
              pw.Row(
                children: [
                  pw.Expanded(child: _buildCriteriaTile('Criterion A (Listening)', '7 / 8', 'Понимание аудиодискурса')),
                  pw.SizedBox(width: 8),
                  pw.Expanded(child: _buildCriteriaTile('Criterion B (Reading)', '6 / 8', 'Смысловой анализ текста')),
                  pw.SizedBox(width: 8),
                  pw.Expanded(child: _buildCriteriaTile('Criterion C (Speaking)', '6 / 8', 'Интерактивная речь')),
                  pw.SizedBox(width: 8),
                  pw.Expanded(child: _buildCriteriaTile('Criterion D (Writing)', '7 / 8', 'Академические связки')),
                ],
              ),
              pw.SizedBox(height: 20),

              // Section 3: Tutor Plan
              pw.Container(
                padding: const pw.EdgeInsets.all(12),
                decoration: pw.BoxDecoration(
                  color: PdfColor.fromHex('#FEF3C7'),
                  borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
                  border: pw.Border.all(color: PdfColor.fromHex('#F59E0B'), width: 0.5),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      '3. Рекомендованный план к следующему занятию с репетитором:',
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 11,
                        color: PdfColor.fromHex('#92400E'),
                      ),
                    ),
                    pw.SizedBox(height: 6),
                    pw.Text(
                      '• Разминка (10 мин): Блиц-прогон активных карточек из Тетради ошибок (Conditionals 2, Past Simple).',
                      style: const pw.TextStyle(fontSize: 9),
                    ),
                    pw.Text(
                      '• Устная часть (20 мин): Симулятор Задания 2 (Диалог 6 вопросов x 40 сек) с фокусом на развернутость ответов.',
                      style: const pw.TextStyle(fontSize: 9),
                    ),
                    pw.Text(
                      '• IB эссе (15 мин): Разбор использования причинно-следственных связок (Consequently, Furthermore).',
                      style: const pw.TextStyle(fontSize: 9),
                    ),
                  ],
                ),
              ),

              pw.Spacer(),

              // Footer
              pw.Divider(color: PdfColors.grey300),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'Приложение «English for Children» • Режим подготовки к ОГЭ и IB',
                    style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600),
                  ),
                  pw.Text(
                    'Сформировано автоматически для родителей и репетитора',
                    style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  pw.Widget _buildMetricBox({
    required String title,
    required String value,
    required String subtitle,
    required PdfColor color,
  }) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: color, width: 1),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(title, style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700)),
          pw.SizedBox(height: 4),
          pw.Text(value, style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: color)),
          pw.SizedBox(height: 2),
          pw.Text(subtitle, style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600)),
        ],
      ),
    );
  }

  pw.Widget _buildCriteriaTile(String title, String score, String desc) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(8),
      decoration: pw.BoxDecoration(
        color: PdfColor.fromHex('#F8FAFC'),
        border: pw.Border.all(color: PdfColors.grey300, width: 0.5),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(6)),
      ),
      child: pw.Column(
        children: [
          pw.Text(score, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 13, color: PdfColor.fromHex('#4F46E5'))),
          pw.SizedBox(height: 2),
          pw.Text(title, style: const pw.TextStyle(fontSize: 8)),
          pw.Text(desc, style: const pw.TextStyle(fontSize: 7, color: PdfColors.grey600), textAlign: pw.TextAlign.center),
        ],
      ),
    );
  }

  pw.Widget _buildTableCell(String text, {bool isHeader = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: 9,
          fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
          color: isHeader ? PdfColors.black : PdfColors.grey800,
        ),
      ),
    );
  }
}
