import UIKit

final class MovieQuizViewController: UIViewController {
    // MARK: - Lifecycle
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var counterLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // берём текущий вопрос из массива вопросов по индексу текущего вопроса
        let currentQuestion = questions[currentQuestionIndex]
        let firstQuestion = convert(model: currentQuestion)
                show(quiz: firstQuestion)
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        let currentQuestion = questions[currentQuestionIndex] // 1
        let givenAnswer = false // 2
        
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        let currentQuestion = questions[currentQuestionIndex] // 1
        let givenAnswer = true // 2
        
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    // приватный метод, который меняет цвет рамки
    // принимает на вход булевое значение и ничего не возвращает
    private func showAnswerResult(isCorrect: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in // слабая ссылка на self
            guard let self = self else { return } // разворачиваем слабую ссылку
            
            self.showNextQuestionOrResults()
            self.imageView.layer.borderColor = UIColor.clear.cgColor
            
            
        }
        
        if isCorrect { // 1
                correctAnswers += 1 // 2
            }
            imageView.layer.masksToBounds = true
            imageView.layer.borderWidth = 8
            imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
            
           
    }
    
    // приватный метод конвертации, который принимает моковый вопрос и возвращает вью модель для главного экрана
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel( // 1
            image: UIImage(named: model.image) ?? UIImage(), // 2
            question: model.text, // 3
            questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)") // 4
        return questionStep
    }
    // приватный метод вывода на экран вопроса, который принимает на вход вью модель вопроса и ничего не возвращает
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    // приватный метод, который содержит логику перехода в один из сценариев
    // метод ничего не принимает и ничего не возвращает
    private func showNextQuestionOrResults() {
            if currentQuestionIndex == questions.count - 1 {
                let alert = UIAlertController(
                    title: "Этот раунд окончен!",
                    message: "Ваш результат: \(correctAnswers)/10",
                    preferredStyle: .alert)

                let action = UIAlertAction(title: "Сыграть еще раз", style: .default) { [weak self] _ in // слабая ссылка на self
                    guard let self = self else { return }
                    self.currentQuestionIndex = 0
                    // сбрасываем переменную с количеством правильных ответов
                    self.correctAnswers = 0
                    // заново показываем первый вопрос
                    let firstQuestion = questions[self.currentQuestionIndex]
                    let viewModel = self.convert(model: firstQuestion)
                    self.show(quiz: viewModel)
                }
                
                alert.addAction(action)
                
                self.present(alert, animated: true, completion: nil)
            }
            
            
            
            else {
                currentQuestionIndex += 1
                
                let nextQuestion = questions[currentQuestionIndex]
                let viewModel = convert(model: nextQuestion)
                
                show(quiz: viewModel)
            }
        }
}

private struct QuizQuestion {
    let image: String
    let text: String
    let correctAnswer: Bool
}

private struct QuizStepViewModel {
    let image: UIImage
    let question: String
    let questionNumber: String
}

private struct QuizResultsViewModel {
    let title: String
    let text: String
    let buttonText: String
}

