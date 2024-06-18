//
//  Item.swift
//  GitHubAPI
//
//  Created by Terry Jason on 2024/6/18.
//

import Foundation

struct Item: Decodable {
    let name: String
    let full_name: String
    let owner: Owner
    let language: String?
    let stargazers_count: Int
    let watchers_count: Int
    let forks_count: Int
    let open_issues_count: Int
    let description: String
}

struct Owner: Decodable {
    let login: String
    let avatar_url: String
}

struct SearchResult: Decodable {
    let items: [Item]
}


