import 'package:flutter/material.dart';
import '../../data/models/questionnaire_model.dart';

class QuestionCard extends StatelessWidget {
  final QuestionModel question;
  final String selectedAnswer;
  final Function(String) onAnswerSelected;
  final int questionNumber;
  final int totalQuestions;

  const QuestionCard({
    Key? key,
    required this.question,
    required this.selectedAnswer,
    required this.onAnswerSelected,
    required this.questionNumber,
    required this.totalQuestions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Question Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade700,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.shade700.withOpacity(0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    'Q$questionNumber',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'of $totalQuestions',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Question Text
            Text(
              question.text,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                height: 1.4,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 24),
            // Options Label
            Container(
              padding: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey.shade200,
                    width: 2,
                  ),
                ),
              ),
              child: Text(
                'Select one option:',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade700,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Options List
            ...question.options.asMap().entries.map((entry) {
              final index = entry.key;
              final option = entry.value;
              final isSelected = selectedAnswer == option;

              return _buildOption(
                option: option,
                index: index,
                isSelected: isSelected,
                onTap: () => onAnswerSelected(option),
              );
            }).toList(),
            // Selected Answer Indicator
            if (selectedAnswer.isNotEmpty) ...[
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.green.shade50,
                      Colors.green.shade100,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.green.shade300,
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.shade200.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.green.shade600,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Your Answer',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.green.shade800,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            selectedAnswer,
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.green.shade900,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.check_circle,
                      color: Colors.green.shade600,
                      size: 28,
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildOption({
    required String option,
    required int index,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final optionLetter = String.fromCharCode(65 + index); // A, B, C, D, E...

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        gradient: isSelected
            ? LinearGradient(
          colors: [
            Colors.blue.shade600,
            Colors.blue.shade700,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        )
            : LinearGradient(
          colors: [
            Colors.white,
            Colors.grey.shade50,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: isSelected
              ? Colors.blue.shade800
              : Colors.grey.shade300,
          width: isSelected ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: isSelected
            ? [
          BoxShadow(
            color: Colors.blue.shade700.withOpacity(0.4),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.blue.shade700.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ]
            : [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          splashColor: isSelected
              ? Colors.white.withOpacity(0.2)
              : Colors.blue.shade100.withOpacity(0.5),
          highlightColor: isSelected
              ? Colors.white.withOpacity(0.1)
              : Colors.blue.shade50.withOpacity(0.5),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                // Option Letter Circle
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: isSelected
                        ? LinearGradient(
                      colors: [
                        Colors.white,
                        Colors.grey.shade100,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                        : LinearGradient(
                      colors: [
                        Colors.grey.shade200,
                        Colors.grey.shade300,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: isSelected
                        ? [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.5),
                        blurRadius: 4,
                        spreadRadius: 1,
                      ),
                    ]
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      optionLetter,
                      style: TextStyle(
                        color: isSelected
                            ? Colors.blue.shade700
                            : Colors.grey.shade700,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Option Text
                Expanded(
                  child: Text(
                    option,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      color: isSelected ? Colors.white : Colors.grey.shade800,
                      letterSpacing: 0.3,
                      height: 1.3,
                    ),
                  ),
                ),
                // Selection Icon
                if (isSelected)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.5),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.check,
                        color: Colors.blue.shade700,
                        size: 18,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}