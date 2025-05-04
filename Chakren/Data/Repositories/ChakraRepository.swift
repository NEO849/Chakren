//
//  ChakraRepository.swift
//  Chakren
//
//  Created by Michael Fleps on 03.05.25.
//

import Foundation

/// Verwaltet die Chakra-Datenquelle (z. B. JSON-Datei im Bundle)
final class ChakraRepository {
    static func fetchChakras() throws -> [Chakra] {
        // 1. JSON-Dateipfad im App-Bundle suchen
        guard let url = Bundle.main.url(forResource: "chakras", withExtension: "json") else {
            throw URLError(.fileDoesNotExist)
        }
        
        // 2. Rohdaten aus der Datei lesen
        let data = try Data(contentsOf: url)
        
        // 3. JSON-Daten in Chakra-Objekte umwandeln
        return try JSONDecoder().decode([Chakra].self, from: data)
    }
}
