import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/questionnaire_controller.dart';
import '../widgets/question_card.dart';

class QuestionnaireScreen extends StatelessWidget {
  const QuestionnaireScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final questionnaireController = Get.find<QuestionnaireController>();
    final PageController pageController = PageController();

    return Scaffold(
      appBar: AppBar(
        title: Obx(() {
          final questionnaire = questionnaireController.currentQuestionnaire.value;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                questionnaire?.title ?? 'Questionnaire',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Obx(() => Text(
                'Question ${questionnaireController.currentQuestionIndex.value + 1} of ${questionnaire?.questions.length ?? 0}',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
              )),
            ],
          );
        }),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            _showExitConfirmation(questionnaireController);
          },
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: Obx(() {
            final progress = questionnaireController.getProgressPercentage();
            return LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.white.withOpacity(0.3),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            );
          }),
        ),
      ),
      body: Stack(
        children: [
          Obx(() {
            final questionnaire = questionnaireController.currentQuestionnaire.value;

            if (questionnaire == null) {
              return const Center(child: Text('No questionnaire selected'));
            }

            return Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: questionnaire.questions.length,
                    itemBuilder: (context, index) {
                      final question = questionnaire.questions[index];
                      return SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Obx(() => QuestionCard(
                          key: ValueKey(question.id + questionnaireController.getAnswerForQuestion(question.id)),
                          question: question,
                          selectedAnswer: questionnaireController.getAnswerForQuestion(question.id),
                          onAnswerSelected: (answer) {
                            questionnaireController.selectAnswer(question.id, answer);
                          },
                          questionNumber: index + 1,
                          totalQuestions: questionnaire.questions.length,
                        )),
                      );
                    },
                    onPageChanged: (index) {
                      questionnaireController.currentQuestionIndex.value = index;
                    },
                  ),
                ),
                _buildNavigationButtons(questionnaireController, pageController, context),
              ],
            );
          }),

          // Loading overlay for submission
          Obx(() {
            if (questionnaireController.isSubmitting.value) {
              return Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Submitting your answers...',
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons(
      QuestionnaireController controller,
      PageController pageController,
      BuildContext context,
      ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Obx(() {
          // Disable buttons while submitting
          final isSubmitting = controller.isSubmitting.value;

          return Row(
            children: [
              Obx(() {
                final hasPrevious = controller.currentQuestionIndex.value > 0;
                return Expanded(
                  child: Visibility(
                    visible: hasPrevious,
                    maintainSize: true,
                    maintainAnimation: true,
                    maintainState: true,
                    child: OutlinedButton.icon(
                      onPressed: hasPrevious && !isSubmitting
                          ? () {
                        pageController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                          : null,
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Previous'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: BorderSide(color: Colors.blue.shade700),
                        foregroundColor: Colors.blue.shade700,
                      ),
                    ),
                  ),
                );
              }),
              const SizedBox(width: 16),
              Expanded(
                child: Obx(() {
                  final questionnaire = controller.currentQuestionnaire.value;
                  final isLastQuestion = controller.currentQuestionIndex.value ==
                      (questionnaire?.questions.length ?? 0) - 1;

                  return ElevatedButton.icon(
                    onPressed: isSubmitting
                        ? null
                        : isLastQuestion
                        ? controller.submitAnswers
                        : () {
                      pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    icon: Icon(isLastQuestion ? Icons.send : Icons.arrow_forward),
                    label: Text(isLastQuestion ? 'Submit' : 'Next'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: isLastQuestion ? Colors.green : Colors.blue.shade700,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: Colors.grey.shade400,
                    ),
                  );
                }),
              ),
            ],
          );
        }),
      ),
    );
  }

  void _showExitConfirmation(QuestionnaireController controller) {
    final answeredCount = controller.selectedAnswers.length;

    if (answeredCount > 0 && !controller.isSubmitting.value) {
      Get.dialog(
        AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Exit Questionnaire?'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('You have answered:'),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Obx(() => Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: Colors.green.shade700,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${controller.selectedAnswers.length} of ${controller.currentQuestionnaire.value?.questions.length ?? 0} questions',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade900,
                      ),
                    ),
                  ],
                )),
              ),
              const SizedBox(height: 16),
              const Text('Your progress will be lost if you exit now.'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                controller.clearSelection();
                Get.back();
                Get.back();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Exit'),
            ),
          ],
        ),
      );
    } else if (answeredCount == 0) {
      Get.back();
    }
  }
}