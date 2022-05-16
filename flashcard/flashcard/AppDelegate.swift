import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        if isNewUser() {
            let context = persistentContainer.newBackgroundContext()
            popularDeck(context: context)
            popualCards(context: context)
            setAsNotNewUser()
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // Verifica se o aplicativo foi aberto pela primeira vez
    private func isNewUser() -> Bool {
        return !UserDefaults.standard.bool(forKey: "isNewUser")
    }
    
    // Altera o valor booleano para informar que o usuário já abriu o app
    private func setAsNotNewUser() {
        UserDefaults.standard.set(true, forKey: "isNewUser")
    }
    
    // Função para salvar alterações no Core Data
    private func saveContext(context: NSManagedObjectContext) {
        do { try context.save() } catch { print(error) }
    }
    
    // Função para criar Decks
    private func createDeck(name: String, context: NSManagedObjectContext) {
        let newDeck = Deck(context: context)
        newDeck.setValue(name, forKey: "nome")
        saveContext(context: context)
    }
    
    // Função para criar Card
    private func createCard(pergunta: String, resposta: String, id: Int, belongsTo deck: Deck, context: NSManagedObjectContext) {
        let newCard = Cartao(context: context)
        newCard.setValue(pergunta, forKey: "pergunta")
        newCard.setValue(resposta, forKey: "resposta")
        newCard.setValue(id, forKey: "id")
        
        //Criando o relacionamento com o Deck
        deck.addToCartao(newCard)
        
        saveContext(context: context)
    }
    
    // Função para puxar o Array de Decks
    private func fetchDecks(context: NSManagedObjectContext) -> [Deck] {
        let fetchRequest = Deck.fetchRequest()
        var lista: [Deck] = []
        
        do {
            lista = try context.fetch(fetchRequest)
        } catch { print(error) }
        
        return lista
    }
    
    func popularDeck(context: NSManagedObjectContext) {
        // Array com nome dos decks
        let decks: [String] = ["Revolução Industrial", "1ª Guerra Mundial", "2ª Guerra Mundial", "Iluminismo"]
         
        for i in decks {
            createDeck(name: i, context: context)
        }
    }
    
    private func popualCards(context: NSManagedObjectContext) {
        // Puxando os Decks que foram salvos
        let listaDecks = fetchDecks(context: context)
        
        // Matriz [[]] Pergunta e outra para Resposta
        let pergunta: [[String]] = [
                    // 8
                    ["O que foi a revolução industrial?",
                     "Em quantos períodos foram divididos?",
                     "Industrialização no Brasil.",
                     "Como a revolução impactou a vida dos trabalhadores?",
                     "Impactos da revolução industrial no Brasil.",
                     "Como era a produção antes da revolução industrial?",
                     "Principais consequências da revolução industrial.",
                     "Invenções criadas na revolução industrial."],
                    
                    // 10
                    ["Como ficou conhecida a 1ª Guerra Mundial?",
                     "Qual foi o estopim da Grande Guerra?",
                     "Quais alianças eram formadas nesse contexto?",
                     "Após um longo período sem intervenção, em que ano os EUA entraram na Grande Guerra?",
                     "O que foi a Guerra das trincheiras?",
                     "O que foi a Ofensiva dos Cem Dias?",
                     "Como ficou conhecido o acordo de paz selado entre as potências vencedoras da 1ª Guerra Mundial e a Alemanha derrotada e em que ano ocorreu?",
                     "Em que período ocorreu a primeira guerra mundial?",
                     "Quais eram os impérios eram sólidos em 1914 e depois se desfizeram?",
                     "Qual era a posição do Brasil durante a Primeira Guerra Mundial?"],
                    
                    // 10
                    ["Quando ocorreu a 2ª Guerra Mundial?",
                     "Quais eventos marcaram a 2ª Guerra Mundial?",
                     "Estima-se quantas vidas foram tiradas com o conflito?",
                     "Quais foram as fases da 2ª Guerra Mundial?",
                     "Quais grupos se enfrentaram nessa guerra?",
                     "O que causou a 2ª Guerra Mundial?",
                     "O que ocorreu na década de 1920, durante a república de Weimar na Alemanha?",
                     "Quem foi Adolf Hitler?",
                     "O que foi o 'espaço vital'?",
                     "O que foi a Guerra Fria?"],
                    
                    // 8
                    ["O que o Iluminismo defendia?",
                     "Principal criação que sintetizava os ideais do Iluminismo",
                     "Grupo que iniciou a movimentação da mudança ideológica",
                     "Movimentos influenciados pelo Iluminismo no Brasil",
                     "Principais consequências do Iluminismo",
                     "Pensadores iluministas",
                     "Iluminismo: quando e onde?",
                     "O que o Iluminismo possibilitou?"]]
         
                let resposta: [[String]] = [
                    // 8
                    ["Período de grande desenvolvimento tecnológico que foi iniciado na Inglaterra a partir da segunda metade do século XVIII.",
                     "Ao todo, foram 3 revoluções industriais datadas na história.",
                     "Só começou verdadeiramente em 1930, cem anos após a Revolução Industrial Inglesa.",
                     "A insatisfação dos trabalhadores com a precarização de seu trabalho resultou no surgimento dos sindicatos e dos movimentos trabalhistas.",
                     "Um grande ciclo de industrialização do Brasil só se deu entre as décadas de 1930 e 1950 e aconteceu graças a incentivos realizados pelos governos de Getúlio Vargas e Juscelino Kubitschek.",
                     "Antes da Revolução Industrial, a produção do trabalho era manufaturada, ou seja, a fabricação de produtos era dividida entre pessoas e máquinas, representada pelo trabalho manual.",
                     "As novas relações de trabalho; a consolidação do capitalismo; a industrialização dos países; a expansão do imperialismo; o exodo rural e a urbanização; entre outras.",
                     "Máquina de vapor, em 1768, por James Watt; O telefone, por Alexander Graham Bell, em 1876; Em 1885, Karl Benz desenvolveu o primeiro carro de combustão interna; Navios, pelo inventor Robert Fulton em 1807; e mais."],
                    
                    // 10
                    ["A grande Guerra",
                     "O assassinato do arquiduque Franz Ferdinand - herdeiro do trono Austro-Húngaro, por um nacionalista sérvio bósnio. Áustria-Hungria culpou a Sérvia pelo ataque, enquanto a Rússia defendeu seu aliado (Sérvia). A Áustria-Hungria declarou guerra à Sérvia e seus aliados entraram no conflito.",
                     "“Tríplice Entente”(Grã-Bretanha, França e Rússia) e “Tríplice Aliança” (Alemanha, Império Astro-Húngaro e Itália).",
                     "Em 1917.",
                     "Principal estratégia militar utilizada na 1ª Guerra Mundial a partir de 1915, onde longos corredores de valas cavadas no solo serviram como demarcadores das posições conquistadas pelas tropas do conflito.",
                     "Foi uma série de ofensivas dos aliados (Tríplice Entente), entre 10 de agosto e 11 de novembro de 1918, que encerraram a Grande Guerra.",
                     "Tratado de Versalhes (1919).",
                     "1914-1918.",
                     "Alemão, Austro-Húngaro, Russo e Otomano.",
                     "Brasil adotou uma postura neutra em 4 de agosto de 1914 devido a relações comerciais com a Alemanha. Mudou de postura apenas em 1917, após um submarino alemão torpedear e afundar o navio brasileiro."],
                    
                    // 10
                    ["1939-1945.",
                     "Holocausto, Massacre de Babi Yar, Massacre de Katyn e bombas atômicas (Hiroshima e Nagasaki).",
                     "Mais de 60 milhões de pessoas.",
                     "Supremacia alemã, equilíbrio das forças e derrota do Eixo.",
                     "Os Aliados (Reino Unido, França, União Soviética e EUA)  e o Eixo (Alemanha, Itália e Japão).",
                     "A insatisfação de uma parte radicalizada da sociedade alemã com o desfecho da Primeira Guerra Mundial, vista como uma grande humilhação pelo Tratado de Versalhes. Sua principal causa foi o expansionismo e o militarismo da Alemanha Nazista.",
                     "O país encarou uma crise econômica duríssima, indo a falência. O cenário se agravou na Crise de 1929, que reforçou a crise da democracia liberal e fomentou movimentos autoritários e fascistas na Europa.",
                     "Líder do partido nazista que ocupou o poder da Alemanha em 1933. Hitler iniciou uma campanha de recuperação do país, de doutrinação da população e perseguição às minorias.",
                     "A ideia era formar um império para a Alemanha em territórios que haviam sido ocupados por germânicos. Era o 'Terceiro Reich',império dedicado exclusivamente para os arianos (ideia de raça pura dos nazistas) e que sobreviveriam sob exploração dos eslavos.",
                     "Período tensão geopolítica entre União Soviética e Estudos Unidos e seus respectivos aliados, após a 2ª Guerra Mundial."],
                    
                    // 8
                    ["O poder da razão em detrimento ao da fé e da religião e buscaram estender a crítica racional em todos os campos do saber humano.",
                     "Buscaram reunir todo o conhecimento produzido à luz da razão num compêndio dividido em 35 volumes: a Enciclopédia (1751-1780).",
                     "Burguesia visto que tinham poder econômico mas não tinham acesso a esfera política.",
                     "Inconfidência mineira (1789), Conjuração Baiana (1798) e a Revolução Pernambucana (1817).",
                     "Implantação da liberdade econômica e religiosa, além do fim do absolutismo e colonialismo.",
                     "Montesquieu, Voltaire, Diderot, Rousseau, Jonh Locke, Adam Smith, entre outros.",
                     "Surgiu na Europa no século XVIII.",
                     "O Iluminismo desempenhou grande influência sobre o aspecto político e intelectual de boa parte dos países ocidentais. Algumas mudanças políticas importantes aconteceram, bem como a implantação e formação de estados-nação, a ampliação de direitos civis, além da diminuição do poder da igreja."]]
        
        // Iterar cada nome de Deck
        for i in 0..<listaDecks.count {
            // Iterar cada array de pergunta e resposta
            for j in 0..<pergunta[i].count {
                createCard(pergunta: pergunta[i][j], resposta: resposta[i][j], id: i, belongsTo: listaDecks[i], context: context)
            }
        }
    }
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*r
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "flashcard")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

