import 'package:flutter/material.dart';

import '../services/learning_storage.dart';

class LearningProgress {
  final int vocabularyCount;
  final int streakDays;
  final int reviewRate;

  const LearningProgress({
    this.vocabularyCount = 214,
    this.streakDays = 12,
    this.reviewRate = 87,
  });
}

class LearningStorageService {
  static const String _vocabularyCountKey = 'learning_vocabulary_count';
  static const String _streakDaysKey = 'learning_streak_days';
  static const String _reviewRateKey = 'learning_review_rate';
  static const String _quizScoreKey = 'learning_quiz_score';
  static const String _quizTotalKey = 'learning_quiz_total';

  static Future<void> saveVocabularyCount(int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_vocabularyCountKey, value);
  }

  static Future<void> saveStreakDays(int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_streakDaysKey, value);
  }

  static Future<void> saveReviewRate(int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_reviewRateKey, value);
  }

  static Future<void> saveQuizResult(int score, int total) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_quizScoreKey, score);
    await prefs.setInt(_quizTotalKey, total);
  }

  static Future<LearningProgress> loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final vocabularyCount = prefs.getInt(_vocabularyCountKey) ?? 214;
    final streakDays = prefs.getInt(_streakDaysKey) ?? 12;
    final reviewRate = prefs.getInt(_reviewRateKey) ?? 87;
    return LearningProgress(
      vocabularyCount: vocabularyCount,
      streakDays: streakDays,
      reviewRate: reviewRate,
    );
  }
}
