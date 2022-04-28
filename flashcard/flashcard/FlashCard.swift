//
//  FlashCard.swift
//  flashcard
//
//  Created by Wellinston Oliveira on 27/04/22.
//

import UIKit

class FlashCard: UIViewController {
    
    weak var card: QuestionCard?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let card = QuestionCard()
        
        //setQuestion = lado da pergunta
        card.setQuestion(question: "Quando começou a segunda guerra?")
        //setAnswer = lado da resposta
        card.setAnswer(answer: "1939")
        
        view.addSubview(card)
        
        //função UiView
        card.translatesAutoresizingMaskIntoConstraints = false
        
        //ativação das constraints (UiView)
        NSLayoutConstraint.activate([
            card.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            card.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            card.heightAnchor.constraint(equalToConstant: view.frame.height * 0.4),
            card.widthAnchor.constraint(equalToConstant: view.frame.width * 0.9)
        ])
        
        //criando variável para o objeto card
        self.card = card
    }

}
