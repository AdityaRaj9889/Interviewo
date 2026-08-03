import 'dart:convert';

class MessageModel {
  final String sender; // 'ai' or 'user'
  final String text;
  final DateTime timestamp;

  MessageModel({
    required this.sender,
    required this.text,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'sender': sender,
      'text': text,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      sender: map['sender'],
      text: map['text'],
      timestamp: DateTime.parse(map['timestamp']),
    );
  }
}

class InterviewResult {
  final int score;
  final List<String> strengths;
  final List<String> weaknesses;
  final List<String> suggestions;
  final List<String> nextTopics;

  InterviewResult({
    required this.score,
    required this.strengths,
    required this.weaknesses,
    required this.suggestions,
    required this.nextTopics,
  });

  factory InterviewResult.fromJson(String source) {
    final data = json.decode(source);
    return InterviewResult(
      score: data['final_score'] ?? 0,
      strengths: List<String>.from(data['strengths'] ?? []),
      weaknesses: List<String>.from(data['weaknesses'] ?? []),
      suggestions: List<String>.from(data['suggestions'] ?? []),
      nextTopics: List<String>.from(data['next_topics'] ?? []),
    );
  }
}
