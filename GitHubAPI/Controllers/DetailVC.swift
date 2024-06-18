//
//  DetailVC.swift
//  GitHubAPI
//
//  Created by Terry Jason on 2024/6/18.
//

import UIKit

// MARK: - DetailVC

final class DetailVC: UIViewController {
    
    // MARK: - Properties
    
    var item: Item? { didSet{ config() } }
    
    // MARK: - UIElement
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var icon: UIImageView = {
        let iv = UIImageView()
        
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        
        return iv
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 25)
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()
    
    private lazy var starsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()
    
    private lazy var watchersLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()
    
    private lazy var forksLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()
    
    private lazy var openIssuesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()
    
    private lazy var infoStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [
            starsLabel,
            watchersLabel,
            forksLabel,
            openIssuesLabel
        ])
        
        view.axis = .vertical
        view.alignment = .trailing
        view.spacing = 8
        
        return view
    }()
    
}

// MARK: - Life Cycle

extension DetailVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
}

// MARK: - Set

extension DetailVC {
    
    private func setup() {
        view.backgroundColor = .systemBackground
        view.addSubview(scrollView)
        
        scrollView.addSubview(contentView)
        scrollView.showsVerticalScrollIndicator = false
        
        scrollView.frame = self.view.frame
        contentView.frame = CGRect(x: self.view.frame.minX, y: self.view.frame.minY, width: self.view.frame.size.width, height: self.view.frame.size.height)
        
        scrollView.contentSize.height = contentView.frame.height
        
        [icon, titleLabel, subTitleLabel, infoStackView].forEach { subView in
            contentView.addSubview(subView)
        }
        
        icon.anchor(
            top: scrollView.topAnchor,
            left: view.leftAnchor,
            right: view.rightAnchor,
            paddingTop: 20,
            paddingLeft: 20,
            paddingRight: 20
        )
        
        let length: CGFloat = view.frame.width - 40
        
        icon.setDimensions(height: length, width: length)
        
        titleLabel.centerX(inView: view)
        titleLabel.setWidth(250)
        
        titleLabel.anchor(
            top: icon.bottomAnchor,
            paddingTop: 40
        )
        
        subTitleLabel.anchor(
            top: titleLabel.bottomAnchor,
            left: view.leftAnchor,
            paddingTop: 50,
            paddingLeft: 15
        )
        
        infoStackView.anchor(
            top: subTitleLabel.topAnchor,
            right: view.rightAnchor,
            paddingRight: 15
        )
    }
    
    private func config() {
        guard let item = item else { return }
        
        self.title = item.name
        
        let url = URL(string: item.owner.avatar_url)
        icon.sd_setImage(with: url)
        
        titleLabel.text = item.full_name
        
        subTitleLabel.text = "Written in \(item.language ?? "")"
        starsLabel.text = "\(item.stargazers_count) stars"
        watchersLabel.text = "\(item.watchers_count) watchers"
        forksLabel.text = "\(item.forks_count) forks"
        openIssuesLabel.text = "\(item.open_issues_count) issues"
    }
    
}
