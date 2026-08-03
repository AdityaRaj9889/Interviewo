import 'package:get/get.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class AIService extends GetxService {
  late GenerativeModel _model;
  late ChatSession _chat;

  final String _apiKey = 'AQ.Ab8RN6Jf36um......';

  Future<AIService> init() async {
    _model = GenerativeModel(model: 'gemini-2.5-flash', apiKey: _apiKey);

    return this;
  }

  void startNewSession({
    required String interviewType,
    required String experienceLevel,
    String? jobDescription,
    List<String>? techStack,
  }) {
    try {
      final safeJobDescription =
          (jobDescription != null && jobDescription.trim().isNotEmpty)
              ? jobDescription
              : "No specific job description provided.";

      final safeTechStack = (techStack != null && techStack.isNotEmpty)
          ? techStack.join(", ")
          : "General technologies";

      final systemPrompt = """
You are a senior FAANG interviewer conducting a realistic technical interview.

CANDIDATE PROFILE:
- Role: $interviewType
- Experience: $experienceLevel
- Tech Stack: $safeTechStack

JOB DESCRIPTION:
$safeJobDescription

RULES:
1. Ask ONLY one question at a time.
2. Wait for user's answer.
3. Evaluate answers deeply.
4. Ask follow-up questions if answer is weak.
5. Questions must match:
   - Experience level
   - Job description
   - Tech stack
6. Total questions: 8-10
7. Maintain professional interviewer behavior.

DIFFICULTY RULES:
- 0-1 years → beginner questions
- 2-3 years → moderate coding + projects
- 4-6 years → architecture + optimization
- 7+ years → leadership + scalability

OUTPUT FORMAT:

FOR NORMAL TURN:
{
  "evaluation": "Short feedback",
  "question": "Next question",
  "difficulty": "easy/medium/hard",
  "topic": "Flutter/DSA/System Design/etc",
  "is_final": false
}

FOR FINAL TURN:
{
  "is_final": true,
  "final_score": 85,
  "hire_decision": "Hire",
  "strengths": [],
  "weaknesses": [],
  "suggestions": [],
  "next_topics": [],
  "overall_feedback": "Detailed feedback"
}

IMPORTANT:
- Return ONLY valid JSON.
- No markdown.
- No extra text.
""";

      _chat = _model.startChat(history: [Content.text(systemPrompt)]);
    } catch (e) {
      print(e);
    }
  }

  Future<String> sendMessage(String message) async {
    try {
      final response = await _chat.sendMessage(Content.text(message));

      return response.text ?? '{"error":"No response"}';
    } catch (e) {
      return '{"error":"${e.toString()}"}';
    }
  }

  // Future<void> listModels() async {
  //   final response = await http.get(
  //     Uri.parse(
  //       'https://generativelanguage.googleapis.com/v1beta/models?key=$_apiKey',
  //     ),
  //   );

  //   print(response.body);
  // }
}
