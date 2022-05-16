import UIKit
import CoreData

class FlashCard: UIViewController {
    
    private weak var titleLable: UILabel?
    weak var card: QuestionCard?
    
    let myButtonR = UIButton() //R = right, certo
    let myButtonW = UIButton() //W = wrong, errado
    let myButtonH = UIButton() //H = histórico
    var contPosicao = 0
    var contAcerto = 0
    let tableView = UITableView()
    
    public var selectedDeck: Deck?
    public var cardList: [Cartao] = []
    public var historicList: [Historico] = []
    
    override func loadView() {
        super.loadView()
        
        setupNavigationController()
        
        fetchCards()
        
        let card = QuestionCard()
        
        //setQuestion = lado da pergunta
        card.setQuestion(question: self.cardList[contPosicao].pergunta ?? "N/A")
        //setAnswer = lado da resposta
        card.setAnswer(answer: self.cardList[contPosicao].resposta ?? "N/A")
        card.contPosicao = "\(contPosicao + 1)/\(cardList.count)"
        card.isFlipped = false
        view.addSubview(card)
        
        //função UiView
        card.translatesAutoresizingMaskIntoConstraints = false
        
        //ativação das constraints (UiView)
        NSLayoutConstraint.activate([
            card.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            card.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            card.heightAnchor.constraint(equalToConstant: view.frame.height * 0.46),
            card.widthAnchor.constraint(equalToConstant: view.frame.width * 0.9)
        ])
        
        //criando variável para o objeto card
        self.card = card
        
        configureButton()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.titleLable?.removeFromSuperview()
    }
    
    private func setupNavigationController() {
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let title: UILabel = .init()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.text = self.selectedDeck?.nome ?? "N/A"
        title.adjustsFontSizeToFitWidth = true
        title.textAlignment = .center
        title.font = UIFont.boldSystemFont(ofSize: 30)
        
        navigationController?.navigationBar.addSubview(title)
        
        NSLayoutConstraint.activate([
            title.centerXAnchor.constraint(equalTo: (navigationController?.navigationBar.centerXAnchor)!),
            title.leftAnchor.constraint(equalTo: (navigationController?.navigationBar.leftAnchor)!, constant: 10),
            title.rightAnchor.constraint(equalTo: (navigationController?.navigationBar.rightAnchor)!, constant: -10),
            title.bottomAnchor.constraint(equalTo: (navigationController?.navigationBar.bottomAnchor)!, constant: -10)
        ])
        
        self.titleLable = title
    }
    
    //Função de ação do botão
    @objc func buttonAction(_ button: UIButton) -> Int{
        
        self.contPosicao += 1
        contAcerto = (button.tag == 1) ? contAcerto + 1 : contAcerto
        self.card?.contPosicao = "\(contPosicao + 1)/\(cardList.count)"
        
        if contPosicao < cardList.count {
            self.card?.isFlipped = false
            self.card?.setQuestion(question: self.cardList[contPosicao].pergunta ?? "N/A")
            self.card?.setAnswer(answer: self.cardList[contPosicao].resposta ?? "N/A")
            
            return contPosicao
        }
        
        if contPosicao == cardList.count {
            print("histórico criado")
            createNewHistoric(data: Date(), acertos: contAcerto, totalPerguntas: self.cardList.count, deckJogado: selectedDeck!)
        }
        
        return contPosicao
    }
    
    @objc func historicoButton(_ button: UIButton){
        guard let historicoViewController = storyboard?.instantiateViewController(withIdentifier: "historicoViewController") as? HistoricoViewController else { return }
        historicoViewController.selectedDeck = self.selectedDeck
        present(historicoViewController, animated: true)
    }
    
    func configureButton() {
        
        //Botao direito
        myButtonR.configuration = .plain()
        myButtonR.configuration?.title = "Lembro"
        myButtonR.configuration?.image = UIImage(systemName: "checkmark.circle.fill")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        myButtonR.configuration?.imagePadding = 6
        
        myButtonR.setTitle("Lembro", for: .normal)
        myButtonR.backgroundColor = .systemGreen
        myButtonR.setTitleColor(.white, for: .normal)
        myButtonR.layer.cornerRadius = 20
        
        //Botao esquerdo
        myButtonW.configuration = .plain()
        myButtonW.configuration?.title = "Não lembro"
        myButtonW.configuration?.image = UIImage(systemName: "xmark.circle.fill")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        myButtonW.configuration?.imagePadding = 6
        
        myButtonW.setTitle("Não lembro", for: .normal)
        myButtonW.backgroundColor = .systemRed
        myButtonW.setTitleColor(.white, for: .normal)
        myButtonW.layer.cornerRadius = 20
        
        //Botao histórico
        myButtonH.configuration = .plain()
        myButtonH.configuration?.title = "Histórico"
        myButtonH.configuration?.image = UIImage(systemName: "clock.fill")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        myButtonH.configuration?.imagePadding = 6
        
        myButtonH.setTitle("Histórico", for: .normal)
        myButtonH.backgroundColor = UIColor(red: 0, green: 0.369, blue: 0.686, alpha: 1)
        myButtonH.setTitleColor(.white, for: .normal)
        myButtonH.layer.cornerRadius = 20
        myButtonH.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        
        addButtonConstraints()
        
        myButtonR.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
        myButtonR.tag = 1
        myButtonW.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
        myButtonH.addTarget(self, action: #selector(historicoButton(_:)), for: .touchUpInside)
        
        self.view.addSubview(myButtonR)
        self.view.addSubview(myButtonW)
        self.view.addSubview(myButtonH)
    }
    
    func addButtonConstraints() {
        view.addSubview(myButtonR)
        myButtonR.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            myButtonR.rightAnchor.constraint(equalTo: self.card!.rightAnchor),
            myButtonR.topAnchor.constraint(equalTo: self.card!.bottomAnchor, constant: 30),
            myButtonR.widthAnchor.constraint(equalTo: self.card!.widthAnchor, multiplier: 0.47),
            myButtonR.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        view.addSubview(myButtonW)
        myButtonW.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            myButtonW.leftAnchor.constraint(equalTo: self.card!.leftAnchor),
            myButtonW.topAnchor.constraint(equalTo: self.card!.bottomAnchor, constant: 30),
            myButtonW.widthAnchor.constraint(equalTo: self.card!.widthAnchor, multiplier: 0.47),
            myButtonW.heightAnchor.constraint(equalToConstant: 60)
        ])
    
        view.addSubview(myButtonH)
        myButtonH.translatesAutoresizingMaskIntoConstraints = false
    
        NSLayoutConstraint.activate([
            myButtonH.leftAnchor.constraint(equalTo: self.myButtonW.leftAnchor),
            myButtonH.topAnchor.constraint(equalTo: self.myButtonR.bottomAnchor, constant: 30),
            myButtonH.rightAnchor.constraint(equalTo: self.myButtonR.rightAnchor),
            myButtonH.heightAnchor.constraint(equalToConstant: 60)
    ])
}
    
    // Puxar o array de card do Core Data
    private func fetchCards() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = Cartao.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "deck.nome == %@", argumentArray: [selectedDeck?.nome ?? "N/A"])
        var auxList: [Cartao] = []
        do { auxList = try context.fetch(fetchRequest) } catch { print(error) }
        self.cardList = auxList
    }
    
    // Criar um novo histório
    private func createNewHistoric(data: Date, acertos: Int, totalPerguntas: Int, deckJogado: Deck) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        // Criar um novo histórico
        let newHistorico = Historico(context: context)
        // Atribuindo valores aos atributos do histórico
        newHistorico.setValue(data, forKey: "data")
        newHistorico.setValue(acertos, forKey: "acertos")
        newHistorico.setValue(totalPerguntas, forKey: "total")
            
        // Adicionar o novo histórico no deck jogado
        deckJogado.addToHistorico(newHistorico)
        
        // Salvando as alterações no Core Data
        saveContext(context: context)
    }
        
    // Função para salvar as alterações no Core Data
    private func saveContext(context: NSManagedObjectContext) {
        do { try context.save() } catch { print(error) }
    }
}
