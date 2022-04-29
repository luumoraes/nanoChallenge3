//
//  FlashCard.swift
//  flashcard
//
//  Created by Wellinston Oliveira on 27/04/22.
//

import UIKit

class FlashCard: UIViewController {
    
    weak var card: QuestionCard?
    
    public var selectedDeck: Deck?
    public var cardList: [Cartao] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = selectedDeck?.nome ?? "N/A"
        
        self.cardList = selectedDeck?.cartao ?? []
        
        print(cardList)
        
        let card = QuestionCard()
        
        //setQuestion = lado da pergunta
        card.setQuestion(question: self.cardList.first?.perguntas ?? "N/A")
        //setAnswer = lado da resposta
        card.setAnswer(answer: self.cardList.first?.respostas ?? "N/A")
        
        view.addSubview(card)
        
        //função UiView
        card.translatesAutoresizingMaskIntoConstraints = false
        
        //ativação das constraints (UiView)
        NSLayoutConstraint.activate([
            card.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            card.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            card.heightAnchor.constraint(equalToConstant: view.frame.height * 0.4),
            card.widthAnchor.constraint(equalToConstant: view.frame.width * 0.9)
        ])
        
        //criando variável para o objeto card
        self.card = card
    }

}
