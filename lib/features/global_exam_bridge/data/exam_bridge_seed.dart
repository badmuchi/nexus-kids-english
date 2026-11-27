import '../domain/models/exam_bridge_models.dart';

class ExamBridgeSeed {
  static const List<BridgeReadingPassage> passages = [
    BridgeReadingPassage(
      id: 'rb_1',
      title: 'Urban Vertical Farming & Future Megacities',
      topicTag: 'Environmental Science • B1+/B2',
      text:
          'As global urban populations continue to expand, traditional agriculture faces mounting pressure from limited arable land and long-distance supply chains. Vertical farming—the practice of growing crops in vertically stacked layers inside controlled indoor environments—offers a promising alternative. By utilizing hydroponic nutrient solutions and precisely tuned LED lighting, indoor farms can operate year-round regardless of external weather conditions. Moreover, they consume up to 90 percent less water than conventional fields because moisture is captured and recirculated. Nevertheless, critics point out that high electricity demands for artificial lighting and climate control currently make vertical farms economically viable mainly for leafy greens and herbs rather than staple grains like wheat or rice.',
      keyVocabulary: [
        'arable land — пахотная земля',
        'hydroponic — гидропонный (без почвы)',
        'economically viable — экономически рентабельный',
        'staple grains — основные зерновые культуры',
      ],
      questions: [
        BridgeReadingQuestion(
          prompt: '[TOEFL Inference] Why are staple grains rarely grown in vertical farms today?',
          format: InternationalExamTrack.toefl,
          options: [
            'They require too much water to recirculate',
            'High energy costs make their indoor production unprofitable',
            'LED lights prevent wheat and rice from germinating',
            'Consumers prefer only leafy greens from urban farms',
          ],
          correctIndex: 1,
          explanation:
              'В последнем предложении указано, что высокие затраты на электричество делают вертикальные фермы рентабельными в основном для зелени и трав, а не для основных зерновых.',
        ),
        BridgeReadingQuestion(
          prompt: '[IELTS T/F/NG] Vertical farms completely eliminate the need for any water input.',
          format: InternationalExamTrack.ielts,
          options: ['TRUE', 'FALSE', 'NOT GIVEN'],
          correctIndex: 1,
          explanation:
              'FALSE: в тексте сказано "consume up to 90 percent less water" (потребляют на 90% меньше), а не полностью обходятся без воды.',
        ),
        BridgeReadingQuestion(
          prompt: '[IELTS T/F/NG] Most European governments already subsidize vertical farming projects.',
          format: InternationalExamTrack.ielts,
          options: ['TRUE', 'FALSE', 'NOT GIVEN'],
          correctIndex: 2,
          explanation:
              'NOT GIVEN: в тексте ничего не говорится о государственных субсидиях в Европе.',
        ),
      ],
    ),
    BridgeReadingPassage(
      id: 'rb_2',
      title: 'The Bioluminescent World of the Deep Ocean',
      topicTag: 'Marine Biology • B1+/B2',
      text:
          'Below a depth of 200 meters, sunlight fades into perpetual twilight, yet the deep ocean is far from dark. Roughly 76 percent of marine organisms living in the water column produce their own light through a chemical reaction called bioluminescence. Unlike incandescent bulbs, which waste most of its energy as heat, biological light is nearly 100 percent efficient. Deep-sea creatures deploy this living glow for diverse survival strategies: the anglerfish dangles a luminous lure to attract prey, while certain squid release glowing clouds to confuse predators before darting away. Other species use faint underside illumination—known as counter-illumination—to match the dim light filtering from above, effectively erasing their silhouette from predators lurking below.',
      keyVocabulary: [
        'perpetual twilight — вечные сумерки',
        'luminous lure — светящаяся приманка',
        'counter-illumination — контриллюминация (маскировка светом)',
        'lurking — затаившийся',
      ],
      questions: [
        BridgeReadingQuestion(
          prompt: '[TOEFL Vocabulary] The word "deploy" in the passage is closest in meaning to:',
          format: InternationalExamTrack.toefl,
          options: ['hide', 'utilize', 'imitate', 'abandon'],
          correctIndex: 1,
          explanation:
              'В контексте "deploy this living glow for diverse survival strategies" глагол deploy означает «использовать, применять» (utilize).',
        ),
        BridgeReadingQuestion(
          prompt: '[IELTS T/F/NG] Bioluminescence generates less wasted heat than traditional incandescent bulbs.',
          format: InternationalExamTrack.ielts,
          options: ['TRUE', 'FALSE', 'NOT GIVEN'],
          correctIndex: 0,
          explanation:
              'TRUE: лампы накаливания теряют большую часть энергии в виде тепла, тогда как биологический свет эффективен почти на 100%.',
        ),
      ],
    ),
  ];

  static const List<BridgeListeningTask> listeningTasks = [
    BridgeListeningTask(
      id: 'lt_toefl_1',
      title: 'Campus Conversation: Robotics Club Lab Access',
      examType: InternationalExamTrack.toefl,
      accentCode: 'en-US',
      transcript:
          'Hi Professor Miller, I am Alex from the junior robotics team. Our regional competition is next Friday, and we still need to calibrate our optical sensors. Could we get extended access to the engineering lab until 8 PM this week? Normally the lab closes at 5, so I can issue you a temporary student badge, provided one of our graduate assistants stays in the building to supervise.',
      question: 'Under what condition can Alex use the engineering lab until 8 PM?',
      options: [
        'If the competition is postponed until next month',
        'If a graduate assistant remains in the building to supervise',
        'If the team brings their own optical sensors from home',
        'If Alex pays a deposit for the student badge',
      ],
      correctIndex: 1,
      rationale:
          'Профессор разрешает выдать временный пропуск при условии ("provided"), что один из аспирантов останется в здании для присмотра.',
    ),
    BridgeListeningTask(
      id: 'lt_ielts_1',
      title: 'Academic Orientation: University Library & Study Pods',
      examType: InternationalExamTrack.ielts,
      accentCode: 'en-GB',
      transcript:
          'Welcome to the North Wing Library. While the ground floor is designated for quiet individual reading, the second floor houses twelve soundproof group study pods. Students may reserve a pod online for up to two hours per day using their university email. Please note that food is strictly prohibited inside the pods, although bottled water with a secure cap is permitted.',
      question: 'What is the maximum daily booking time for a group study pod?',
      options: [
        'One hour',
        'Two hours',
        'Three hours',
        'Unlimited if booked by email',
      ],
      correctIndex: 1,
      rationale:
          'В британском объявлении чётко указано: "reserve a pod online for up to two hours per day".',
    ),
  ];

  static const List<BridgeSpeakingPrompt> speakingPrompts = [
    BridgeSpeakingPrompt(
      id: 'sp_toefl_1',
      examType: InternationalExamTrack.toefl,
      topic: 'TOEFL Independent Speaking (Task 1)',
      prompt:
          'Do you agree or disagree with the following statement? High school students should be required to learn a second foreign language before graduation. Use specific reasons and examples to support your opinion.',
      bulletPoints: [
        '15 seconds to prepare your thesis + 2 reasons',
        '45 seconds to speak clearly and continuously',
        'Aim for 1 clear position + 1 concrete example',
      ],
      prepSeconds: 15,
      speakSeconds: 45,
      usefulPhrases: [
        'Personally, I strongly believe that...',
        'First and foremost, learning an additional language...',
        'For instance, in my own school experience...',
        'Therefore, making it mandatory would benefit...',
      ],
    ),
    BridgeSpeakingPrompt(
      id: 'sp_ielts_1',
      examType: InternationalExamTrack.ielts,
      topic: 'IELTS Speaking Part 2 (Cue Card)',
      prompt: 'Describe a skill you learned outside of school that you found very useful.',
      bulletPoints: [
        'What the skill is and how you started learning it',
        'Who helped you or what resources you used',
        'How long it took to become confident',
        'And explain why this skill is valuable to you today',
      ],
      prepSeconds: 60,
      speakSeconds: 120,
      usefulPhrases: [
        'I would like to talk about a practical skill I picked up...',
        'What initially sparked my interest was...',
        'At first, I struggled with..., but gradually...',
        'Looking back, mastering this has given me...',
      ],
    ),
  ];

  static const List<BridgeWritingPrompt> writingPrompts = [
    BridgeWritingPrompt(
      id: 'wr_toefl_1',
      examType: InternationalExamTrack.toefl,
      title: 'TOEFL Academic Discussion',
      scenario:
          'Dr. Vance (Environmental Studies): Today we are discussing city transport. Should governments spend more money expanding high-speed bicycle lanes or improving electric public buses?\n\nMaya: I think electric buses help everyone, including elderly citizens and commuters traveling long distances in bad weather.\nLiam: True, but dedicated bike lanes are much cheaper to build and encourage daily physical exercise while cutting traffic congestion.',
      targetWords: 100,
      timerMinutes: 10,
      starterFrames: [
        'While both Maya and Liam raise valid points, I believe...',
        'Building on Liam’s argument about congestion...',
        'Furthermore, from an environmental perspective...',
        'Consequently, prioritizing ... would yield greater long-term benefits.',
      ],
    ),
    BridgeWritingPrompt(
      id: 'wr_ielts_1',
      examType: InternationalExamTrack.ielts,
      title: 'IELTS Task 2 Bridge Essay',
      scenario:
          'Some people believe that teenagers should focus exclusively on academic subjects at school, while others think practical life skills such as financial literacy and coding are equally important. Discuss both views and give your own opinion.',
      targetWords: 150,
      timerMinutes: 20,
      starterFrames: [
        'In recent years, there has been ongoing debate regarding...',
        'On the one hand, proponents of traditional academic subjects argue that...',
        'On the other hand, practical competencies such as coding...',
        'In conclusion, I firmly believe that a balanced curriculum...',
      ],
    ),
  ];
}
