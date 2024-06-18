//
//  MainVC.swift
//  GitHubAPI
//
//  Created by Terry Jason on 2024/6/18.
//

import UIKit
import SDWebImage

private let searchCellId = K.CellId.searchCell

// MARK: - MainVC

final class MainVC: UIViewController {
    
    // MARK: - Properties
    
    private lazy var items: [Item] = []
    private lazy var isRefresh: Bool = false
    
    // MARK: - UIElement
    
    private lazy var tableView: UITableView = UITableView()
    private lazy var searchBar: UISearchBar = UISearchBar()
    private lazy var refresher: UIRefreshControl = UIRefreshControl()
    
}

// MARK: - Life Cycle

extension MainVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
    }
    
}

// MARK: - Set

extension MainVC {
    
    private func config() {
        self.title = K.appname
        navigationController?.navigationBar.prefersLargeTitles = true
        
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        
        refresher.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(ItemCell.self, forCellReuseIdentifier: searchCellId)
        tableView.refreshControl = refresher
        tableView.rowHeight = 130
        
        tableView.fillSuperview()
        
        searchBar.sizeToFit()
        searchBar.delegate = self
        searchBar.barTintColor = .systemBackground
        searchBar.tintColor = .label
        
        searchBar.placeholder = "請輸入關鍵字搜尋"
        
        tableView.tableHeaderView = searchBar
    }
    
}

// MARK: - @objc Actions

extension MainVC {
    
    @objc private func handleRefresh()  {
        isRefresh = true
        items.removeAll(keepingCapacity: false)
        tableView.reloadData()
        searchAPI(searchText: searchBar.text!)
    }
    
}

// MARK: - API

extension MainVC {
    
    private func searchAPI(searchText: String) {
        guard !searchText.isEmpty else {
            if isRefresh { endRefresher(searchBarEmpty: true) }
            return
        }
        
        Task {
            do {
                if let repositories = try await API.searchGithubRepositories(query: searchText) {
                    items = repositories
                    
                    DispatchQueue.main.async { [weak self] in
                        guard let self else { return }
                        if isRefresh { endRefresher() }
                        
                        tableView.reloadData()
                    }
                } else {
                    DispatchQueue.main.async { [weak self] in
                        guard let self else { return }
                        items.removeAll()
                        tableView.reloadData()
                    }
                }
            } catch {
                fatalError(error.localizedDescription)
            }
        }
        
        
    }
    
}

// MARK: - Helper Methods

extension MainVC {
    
    private func endRefresher(searchBarEmpty: Bool = false) {
        if refresher.isRefreshing {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) { [unowned self] in
                refresher.endRefreshing()
                
                if searchBarEmpty {
                    let alert = UIAlertController(
                        title: "Oops",
                        message: "The data couldn't be read because it is missing.",
                        preferredStyle: .alert
                    )
                    
                    let okAction = UIAlertAction(title: "Ok", style: .cancel)
                    
                    alert.addAction(okAction)
                    
                    present(alert, animated: true)
                }
            }
        }
    }
    
}

// MARK: - UITableViewDataSource

extension MainVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: searchCellId,
            for: indexPath
        ) as! ItemCell
        
        cell.item = items[indexPath.row]
        
        return cell
    }
    
}

// MARK: - UITableViewDelegate

extension MainVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchBar.endEditing(true)
        
        let detailVC = DetailVC()
        detailVC.item = items[indexPath.row]
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
}

// MARK: - UISearchBarDelegate

extension MainVC: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
        
        items.removeAll()
        
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            tableView.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        
        guard
            let searchText = searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines),
            !searchText.isEmpty else {
            return
        }
        
        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
            searchAPI(searchText: searchText)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        searchBar.showsCancelButton = false
        searchBar.text = nil
        
        items.removeAll()
        
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            tableView.reloadData()
        }
    }
    
}
