//
//  QuestionCard.swift
//  flashcard
//
//  Created by Wellinston Oliveira on 28/04/22.
//

import UIKit

class QuestionCard: UIControl {
    
    //declarando variáveis
    private weak var cardArea: UIControl?
    private weak var textArea: UIControl?
    private weak var title: UILabel?
    private weak var text: UILabel?
    
    private var questionText: String? {
        didSet {
            self.text?.text = questionText
        }
    }
    //declarando variáveis como string da label do flashcard
    private var answerText: String?
    
    private var titleText: String {
        return isFlipped ? "RESPOSTA" : "PERGUNTA"
    }
    
    //função de virar carta - Começa como falsa (Lado da pergunta)
    //                        Quando vira, se torna verdadeiro (lado da resposta)
    public var isFlipped: Bool = false {
        didSet {
            
            if isFlipped {
                cardArea?.backgroundColor = UIColor(red: 0.824, green: 0.447, blue: 0, alpha: 1)
                textArea?.backgroundColor = UIColor(red: 0.859, green: 0.671, blue: 0.447, alpha: 1)
                
                title?.text = "RESPOSTA"
                text?.text = answerText
                
                UIView.transition(with: self, duration: 0.5, options: .transitionFlipFromLeft, animations: nil, completion: nil)
            } else {
                cardArea?.backgroundColor = UIColor(red: 0, green: 0.369, blue: 0.686, alpha: 1)
                textArea?.backgroundColor = UIColor(red: 0.447, green: 0.631, blue: 0.792, alpha: 1)
                
                title?.text = "PERGUNTA"
                text?.text = questionText
                
                UIView.transition(with: self, duration: 0.5, options: .transitionFlipFromLeft, animations: nil, completion: nil)
            }
        }
    }
    
    private func initComplement() {
        //definindo a figura usando UiView
        let cardArea = UIControl()
        let textArea = UIControl()
        let title = UILabel()
        let text = UILabel()
        
        addSubview(cardArea)
        cardArea.addSubview(textArea)
        cardArea.addSubview(title)
        textArea.addSubview(text)
        
        layer.cornerRadius = 30
        clipsToBounds = true
        
        //Figura azul escura
        cardArea.translatesAutoresizingMaskIntoConstraints = false
        cardArea.backgroundColor = UIColor(red: 0, green: 0.369, blue: 0.686, alpha: 1)
        cardArea.layer.cornerRadius = 30
        
        //figura azul claro
        textArea.translatesAutoresizingMaskIntoConstraints = false
        textArea.backgroundColor = UIColor(red: 0.447, green: 0.631, blue: 0.792, alpha: 1)
        textArea.layer.cornerRadius = 30
        
        //Configurações de fonte
        title.translatesAutoresizingMaskIntoConstraints = false
        title.textAlignment = .center
        //ajuste flexivel do tamanho da fonte com o tamanho da figura
        title.sizeToFit()
        title.font = UIFont.boldSystemFont(ofSize: 36)
        title.textColor = .white
        title.text = titleText
        
        text.translatesAutoresizingMaskIntoConstraints = false
        text.textAlignment = .center
        text.numberOfLines = 0
        text.font = UIFont.systemFont(ofSize: 18)
        text.text = questionText
        
        //constraint UiView
        NSLayoutConstraint.activate([
            cardArea.topAnchor.constraint(equalTo: topAnchor),
            cardArea.leftAnchor.constraint(equalTo: leftAnchor),
            cardArea.rightAnchor.constraint(equalTo: rightAnchor),
            cardArea.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            title.topAnchor.constraint(equalTo: cardArea.topAnchor),
            title.leftAnchor.constraint(equalTo: cardArea.leftAnchor),
            title.rightAnchor.constraint(equalTo: cardArea.rightAnchor),
            title.heightAnchor.constraint(equalTo: cardArea.heightAnchor, multiplier: 0.28),
            
            textArea.topAnchor.constraint(equalTo: title.bottomAnchor),
            textArea.centerXAnchor.constraint(equalTo: cardArea.centerXAnchor),
            textArea.heightAnchor.constraint(equalTo: cardArea.heightAnchor, multiplier: 0.6667),
            textArea.widthAnchor.constraint(equalTo: cardArea.widthAnchor, multiplier: 0.8824),
            
            text.topAnchor.constraint(equalTo: textArea.topAnchor, constant: 10),
            text.leftAnchor.constraint(equalTo: textArea.leftAnchor, constant: 10),
            text.rightAnchor.constraint(equalTo: textArea.rightAnchor, constant: -10),
            text.bottomAnchor.constraint(equalTo: textArea.bottomAnchor, constant: -10),
        ])
        
        self.cardArea = cardArea
        self.textArea = textArea
        self.title = title
        self.text = text
        
        //ação ao clicar
        self.cardArea?.addTarget(self, action: #selector(flipCard), for: .touchUpInside)
        self.textArea?.addTarget(self, action: #selector(flipCard), for: .touchUpInside)
    }
    
    //função para a animação de virar a carta
    @objc private func flipCard() {
        isFlipped = !isFlipped
        sendActions(for: .touchUpInside)
    }
    
    //funções UiView
    override init(frame: CGRect) {
        super.init(frame: frame)
        initComplement()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initComplement()
    }
    
    public func setQuestion(question: String) {
        self.questionText = question
    }
    
    public func setAnswer(answer: String) {
        self.answerText = answer
    }
}

