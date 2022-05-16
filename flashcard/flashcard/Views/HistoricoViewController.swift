import UIKit

class HistoricoViewController: UIViewController{
    // Declarando variaveis
    public var selectedDeck: Deck?
    public var historicList: [Historico] = []
    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Chamando funções
        fetchHistoric()
        setupTableView()
    }
    
    // Criação tableView
    func setupTableView() {
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // Função para puxar o array de histórico do Deck
    private func fetchHistoric() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        // Escolher qual tipo de atributo iremos puxar
        let fetchRequest = Historico.fetchRequest()
        
        // Determinando o tipo de organização da lista
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "data", ascending: false)]
        
        // Filtrando os atributos puxados de acordo com o nome do deck
        fetchRequest.predicate = NSPredicate(format: "deck.nome == %@", argumentArray: [self.selectedDeck?.nome ?? "N/A"])
        
        var auxList: [Historico] = []
        
        // Puxando as informações do Core Data e atribuindo a um array auxiliar
        do { auxList = try context.fetch(fetchRequest) } catch { print(error) }
        
        // Passando o array auxiliar para o array de históricos
        self.historicList = auxList
    }
}

extension HistoricoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.historicList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let historico = self.historicList[indexPath.row]
        
        let dateFormatter: DateFormatter = .init()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        cell.textLabel?.text = "\( dateFormatter.string(from: historico.data ?? Date.distantPast))\t\(historico.acertos)/\(historico.total)"
        return cell
    }
}

extension HistoricoViewController: UITableViewDelegate {
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
