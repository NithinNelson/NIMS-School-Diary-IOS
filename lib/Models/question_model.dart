class QuestionAnswer {
  QuestionAnswer(
      {this.maxScore,
      this.question,
      this.questType,
      this.rightAnswer,
      this.studAnswer,
      this.studScore,
      this.trueOrfalse,
      this.classPerc,
      this.studPerc,
      this.classPersColor,
      this.stdPersColor});
  final String? question;
  final String? questType;
  final String? rightAnswer;
  final String? studAnswer;
  final String? trueOrfalse;
  final String? studScore;
  final String? maxScore;
  final String? studPerc;
  final String? classPerc;
  final String? classPersColor;
  final String? stdPersColor;
}
