//
//  API.swift
//  GitHubAPI
//
//  Created by Terry Jason on 2024/6/18.
//

import Foundation

enum API {
    
    static func searchGithubRepositories(query: String) async throws -> [Item]? {
        let urlString = "https://api.github.com/search/repositories?q=\(query)&sort=stars&order=desc&per_page=10"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return nil
        }
        
        let (data, response) = try await URLSession.shared.data(for: URLRequest(url: url))
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            print("Failed request with response: \(response)")
            return nil
        }
        
        do {
            let searchResult = try JSONDecoder().decode(SearchResult.self, from: data)
            return searchResult.items
        } catch {
            print("Decoding error: \(error.localizedDescription)")
            return nil
        }
    }
    
}
