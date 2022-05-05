//
//  FlashCard.swift
//  flashcard
//
//  Created by Wellinston Oliveira on 27/04/22.
//

import UIKit

class FlashCard: UIViewController {
    
    
    weak var card: QuestionCard?
    
    let myButtonR = UIButton() //R = right, certo
    let myButtonW = UIButton() //W = wrong, errado
    var contPosicao = 0
    var contAcerto = 0
    var contErro = 0
    let tableView = UITableView()
    
    public var selectedDeck: Deck?
    public var cardList: [Cartao] = []
    
    
    override func loadView() {
        super.loadView()
        
        self.title = selectedDeck?.nome ?? "N/A"
        
        fetchCards()
        
        print(cardList)
        
        let card = QuestionCard()
        
        //setQuestion = lado da pergunta
        card.setQuestion(question: self.cardList[contPosicao].pergunta ?? "N/A")
        //setAnswer = lado da resposta
        card.setAnswer(answer: self.cardList[contPosicao].resposta ?? "N/A")
        
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
        
        configureButton()
        setupTableView()
    }

    //função de ação do botão
    @objc func buttonAction(button: UIButton){
            if(myButtonR.isTouchInside || myButtonW.isTouchInside){
                contPosicao += 1
                print("Valor do contador = \(contPosicao)")
                
                if contPosicao < cardList.count {
                    self.card?.setQuestion(question: self.cardList[contPosicao].pergunta ?? "N/A")
                    self.card?.setAnswer(answer: self.cardList[contPosicao].resposta ?? "N/A")
                    return
                }
                
                print("Acabaram as perguntas")
            }
        
            if (myButtonR.isTouchInside){
                contAcerto += 1
//                print("Valor do Acerto =  \(contAcerto)")
                
            }
            if(myButtonW.isTouchInside){
                contErro += 1
//                print("Valor do Erro =   \(contErro)")
                
        }
        
    }
    
    func configureButton() {
        
        //botao direito
        myButtonR.configuration = .plain()
        myButtonR.configuration?.title = "Certo"
        //myButtonR.configuration?.baseForegroundColor
        myButtonR.configuration?.image = UIImage(systemName: "book.fill")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        myButtonR.configuration?.imagePadding = 6
        
        myButtonR.setTitle("Certo", for: .normal)
        myButtonR.backgroundColor = .systemGreen
        myButtonR.setTitleColor(.black, for: .normal)
        myButtonR.layer.cornerRadius = 20
        
        //botao esquerdo
        myButtonW.configuration = .plain()
        myButtonW.configuration?.title = "Errado"
        //myButtonW.configuration?.baseForegroundColor = .system
        myButtonW.configuration?.image = UIImage(systemName: "book.fill")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        myButtonW.configuration?.imagePadding = 6
        
        myButtonW.setTitle("Errado", for: .normal)
        myButtonW.backgroundColor = .systemRed
        myButtonW.setTitleColor(.black, for: .normal)
        myButtonW.layer.cornerRadius = 20
        
        addButtonConstraints()
        
        myButtonR.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        myButtonW.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        self.view.addSubview(myButtonR)
        self.view.addSubview(myButtonW)
    }
    
    func addButtonConstraints() {
        view.addSubview(myButtonR)
        myButtonR.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            myButtonR.rightAnchor.constraint(equalTo: self.card!.rightAnchor),
            myButtonR.topAnchor.constraint(equalTo: self.card!.bottomAnchor, constant: 10),
            myButtonR.widthAnchor.constraint(equalTo: self.card!.widthAnchor, multiplier: 0.47),
            myButtonR.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        view.addSubview(myButtonW)
        myButtonW.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            myButtonW.leftAnchor.constraint(equalTo: self.card!.leftAnchor),
            myButtonW.topAnchor.constraint(equalTo: self.card!.bottomAnchor, constant: 10),
            myButtonW.widthAnchor.constraint(equalTo: self.card!.widthAnchor, multiplier: 0.47),
            myButtonW.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
        //criação tableView
    func setupTableView() {
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.topAnchor.constraint(equalTo: self.myButtonW.bottomAnchor, constant: 10).isActive = true
        tableView.leftAnchor.constraint(equalTo: self.myButtonW.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.myButtonR.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        tableView.layer.cornerRadius = 20
        tableView.layer.borderColor = .init(red: 0, green: 0, blue: 0, alpha: 1)
        tableView.layer.borderWidth = 0.1
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    //puxar cards
    private func fetchCards() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = Cartao.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "deck.nome == %@", argumentArray: [selectedDeck?.nome ?? "N/A"])
        var auxList: [Cartao] = []
        do { auxList = try context.fetch(fetchRequest) } catch { print(error) }
        self.cardList = auxList
    }
}

extension FlashCard: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "hihihi"
        return cell
    }
}

extension FlashCard: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Histórico"
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
}
