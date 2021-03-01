//
//  ViewController.swift
//  ch01-1871408-simpleApp
//
//  Created by JeongHyeon Lee on 2021/03/01.
//

import UIKit

class ViewController: UIViewController {
    
    var questions = [
        "대한민국의 수도는 무엇인가요?",
        "한국 청년들에게 가장 인기있는 대학은 무슨 대학인가요?",
        "7+21은 얼마인가요?"
    ]
    var answers = [
        "서울",
        "한성대학교",
        "28"
    ]
    var currentIndex = 0

    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        questionLabel.text = questions[currentIndex]
    }

    @IBAction func nextQuestion(_ sender: UIButton) -> Void {
        currentIndex += 1
        currentIndex %= questions.count
        
        questionLabel.text = questions[currentIndex]
        answerLabel.text = "???"
    }
    
    @IBAction func showAnswer(_ sender: UIButton) {
        answerLabel.text = answers[currentIndex]
    }
}

