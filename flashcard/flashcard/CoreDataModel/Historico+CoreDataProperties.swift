//
//  Historico+CoreDataProperties.swift
//  flashcard
//
//  Created by Wellinston Oliveira on 28/04/22.
//
//

import Foundation
import CoreData


extension Historico {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Historico> {
        return NSFetchRequest<Historico>(entityName: "Historico")
    }

    @NSManaged public var data: Date?
    @NSManaged public var acertos: Int64
    @NSManaged public var total: Int64
    @NSManaged public var deck: Deck?

}

extension Historico : Identifiable {

}
