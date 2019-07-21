//
//  ViewController.swift
//  WordGame
//
//  Created by Tarun Gorre on 16.07.19.
//  Copyright © 2019 Tarun Gorre. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var fallingLabel: UILabel!
    @IBOutlet weak var gameOverView: UIView!
    @IBOutlet weak var fixedLabel: UILabel!
    @IBOutlet var infoView: UIView!
    
    @IBOutlet var correctAnswersButton: UIButton!
    @IBOutlet var wrongAnswersButton: UIButton!
    @IBOutlet var skippedAnswersButton: UIButton!
    @IBOutlet var totalCorrectLabel: UILabel!
    @IBOutlet var totalWrongLabel: UILabel!
    @IBOutlet var totalSkippedLabel: UILabel!

    var animator: UIViewPropertyAnimator!
    
    var allWords: [WordModel] = []
    var allSpanishWords: [String] = []
    var randomSpanishWords: [String] = []

    var correctAnswers = 0
    var wrongAnswers = 0
    var skippedAnswers = 0
    var isPaused = false
    


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        updateScoreValues()
        initViews()
    }
    
    @IBAction func startAgainClicked(_ sender: UIButton) {
         correctAnswers = 0
         wrongAnswers = 0
         skippedAnswers = 0
        updateScoreValues()
        gameOverView.isHidden = true
        startTheGame()
    }
    
    @IBAction func answerClicked(_ sender: UIButton) {
        if sender.tag == 101 {
            // CORRECT
            let correctWord = validateCorrectness()
            if correctWord {
                correctAnswers = correctAnswers+1
                updateScoreValues()
                animator.stopAnimation(true)
                startTheGame()
            } else {
                wrongAnswers = wrongAnswers+1
                updateScoreValues()
                // If wrong answers are 10 then end the game
                if (wrongAnswers == 10) {
                    endTheGame()
                } else {
                    animator.stopAnimation(true)
                    startTheGame()

                }
            }
        } else {
            // Wrong
            
            animator.stopAnimation(false)
            animator.finishAnimation(at: .end)
            
        }
        
    }
    
    @IBAction func startClicked(_ sender: UIButton) {
        infoView.isHidden = true
        if isPaused {
            animator.startAnimation()
        } else {
            startTheGame()
        }
    }
    
    @IBAction func infoClicked(_ sender: UIButton) {
        if animator.isRunning {
            animator.pauseAnimation()
            isPaused = true
        }
        infoView.isHidden = false
    }
    
    func updateScoreValues() {
        correctAnswersButton.setTitle("\(correctAnswers)", for: .normal)
        wrongAnswersButton.setTitle("\(wrongAnswers)", for: .normal)
        skippedAnswersButton.setTitle("\(skippedAnswers)", for: .normal)

    }
    
    func initViews() {
        infoView.isHidden = false
        gameOverView.isHidden = true
        JsonParser.fetchTheWords { allWords in
            DispatchQueue.main.async {
                self.allWords = allWords
                self.collectAllSpaWords()
            }
            
        }
    }
    
    func collectAllSpaWords() {
        
        allSpanishWords = allWords.map({$0.wordSpa})
        
    }
    
    func getRandomEngWord() -> String {
        guard let randomEngWord = allWords.randomElement()?.wordEng else { return "" }
        return randomEngWord
    }
    
    func translateSpaToEnglish() -> String {
        let wordObject = allWords.filter({$0.wordSpa == fallingLabel.text}).first
        return wordObject!.wordEng
        
    }
    
    func translateEngToSpanish() -> String {
        let wordObject = allWords.filter({$0.wordEng == fixedLabel.text}).first
        return wordObject!.wordSpa
        
    }

    
    
    func validateCorrectness() -> Bool {
        
        if fixedLabel.text == translateSpaToEnglish() {
            return true
        }
        
        return false
    }
    
    func startTheGame() {
        self.fallingLabel.transform = CGAffineTransform.identity
        fixedLabel.text = getRandomEngWord()
        addAnimations()
        
    }
    
    func endTheGame() {
        animator.stopAnimation(true)
        self.fallingLabel.transform = CGAffineTransform.identity

        totalCorrectLabel.text = "\(correctAnswers)"
        totalWrongLabel.text = "\(wrongAnswers)"
        totalSkippedLabel.text = "\(skippedAnswers)"

        gameOverView.isHidden = false
        
    }
    
    func addAnimations() {
        self.fallingLabel.text = probabilityOfCorrectWord()
        animator = UIViewPropertyAnimator(duration: 20, curve: .linear) {
            self.fallingLabel.transform = CGAffineTransform.identity.translatedBy(x: 0, y: UIScreen.main.bounds.maxY + self.fallingLabel.frame.size.height)
        }
        animator.startAnimation()
        animator.addCompletion { position in
            if position == .end {
                self.fallingLabel.transform = CGAffineTransform.identity
                self.skippedAnswers = self.skippedAnswers+1
                self.updateScoreValues()
                self.addAnimations()
            }
        }
    }
    
    func probabilityOfCorrectWord() -> String {
        let correctSpaWord = translateEngToSpanish()
        let randomSpaWord = allSpanishWords.randomElement()
        randomSpanishWords.append(randomSpaWord!)
        if randomSpanishWords.count == 5 {
            if !randomSpanishWords.contains(correctSpaWord) {
                randomSpanishWords.removeAll()
                return correctSpaWord
            }
        }
        
        return randomSpaWord!
    }
}

