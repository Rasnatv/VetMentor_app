class QuestionModel {
  final String question;
  final List<String> options;
  final int correctIndex;

  const QuestionModel({
    required this.question,
    required this.options,
    required this.correctIndex,
  });
}

// The single, main 15-question mock test shown on the home screen.
final List<QuestionModel> dummyQuestions = [
  QuestionModel(
    question: 'Which organ in animals is primarily responsible for insulin production?',
    options: ['Liver', 'Pancreas', 'Kidney', 'Spleen'],
    correctIndex: 1,
  ),
  QuestionModel(
    question: 'The normal body temperature of a healthy dog is approximately:',
    options: ['36.5°C', '38.5°C', '41.5°C', '43.5°C'],
    correctIndex: 1,
  ),
  QuestionModel(
    question: 'Which of these is a ruminant animal?',
    options: ['Horse', 'Pig', 'Cow', 'Dog'],
    correctIndex: 2,
  ),
  QuestionModel(
    question: 'Rabies is caused by which type of pathogen?',
    options: ['Bacteria', 'Virus', 'Fungus', 'Protozoa'],
    correctIndex: 1,
  ),
  QuestionModel(
    question: 'The study of animal diseases is known as:',
    options: ['Zoology', 'Veterinary Pathology', 'Botany', 'Entomology'],
    correctIndex: 1,
  ),
  QuestionModel(
    question: 'Which vitamin deficiency causes night blindness in animals?',
    options: ['Vitamin A', 'Vitamin C', 'Vitamin D', 'Vitamin K'],
    correctIndex: 0,
  ),
  QuestionModel(
    question: 'Foot and Mouth Disease mainly affects:',
    options: ['Birds', 'Cloven-hoofed animals', 'Reptiles', 'Fish'],
    correctIndex: 1,
  ),
  QuestionModel(
    question: 'The gestation period of a cow is approximately:',
    options: ['150 days', '210 days', '283 days', '330 days'],
    correctIndex: 2,
  ),
  QuestionModel(
    question: 'Which of the following is an anticoagulant used in blood collection?',
    options: ['Saline', 'EDTA', 'Glucose', 'Formalin'],
    correctIndex: 1,
  ),
  QuestionModel(
    question: 'Mastitis in dairy animals affects which organ?',
    options: ['Udder', 'Liver', 'Lungs', 'Heart'],
    correctIndex: 0,
  ),
  QuestionModel(
    question: 'Which council regulates veterinary education in India?',
    options: ['MCI', 'ICAR', 'Veterinary Council of India', 'AICTE'],
    correctIndex: 2,
  ),
  QuestionModel(
    question: 'The heart of a mammal has how many chambers?',
    options: ['2', '3', '4', '5'],
    correctIndex: 2,
  ),
  QuestionModel(
    question: 'Deworming in livestock is done to control:',
    options: ['Viral infections', 'Internal parasites', 'Fungal growth', 'Nutrient deficiency'],
    correctIndex: 1,
  ),
  QuestionModel(
    question: 'Which of these is a zoonotic disease?',
    options: ['Anthrax', 'Mastitis', 'Bloat', 'Laminitis'],
    correctIndex: 0,
  ),
  QuestionModel(
    question: 'Artificial Insemination in cattle is primarily used to:',
    options: [
      'Treat infections',
      'Improve breed genetics',
      'Increase milk fat',
      'Prevent bloat',
    ],
    correctIndex: 1,
  ),
];