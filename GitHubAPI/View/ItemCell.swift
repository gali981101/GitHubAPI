//
//  ItemCell.swift
//  GitHubAPI
//
//  Created by Terry Jason on 2024/6/18.
//

import UIKit

// MARK: - ItemCell

final class ItemCell: UITableViewCell {
    
    // MARK: - Properties
    
    var item: Item? { didSet { config() } }
    
    // MARK: - UIElement
    
    private lazy var avatar: UIImageView = {
        let iv = UIImageView()
        
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        
        return iv
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 3
        
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [
            titleLabel,
            descriptionLabel
        ])
        
        view.axis = .vertical
        view.alignment = .leading
        view.spacing = 4
        
        return view
    }()
    
    // MARK: - init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Setup

extension ItemCell {
    
    private func setup() {
        self.selectionStyle = .none
        
        addSubview(avatar)
        addSubview(stackView)
        
        avatar.layer.cornerRadius = 80 / 2
        avatar.setDimensions(height: 80, width: 80)
        
        avatar.centerY(
            inView: self,
            leftAnchor: leftAnchor,
            paddingLeft: 12
        )
        
        stackView.centerY(
            inView: avatar,
            leftAnchor: avatar.rightAnchor,
            paddingLeft: 8
        )
        
        stackView.anchor(
            left: avatar.rightAnchor,
            right: rightAnchor,
            paddingLeft: 8,
            paddingRight: 25
        )
    }
    
}

// MARK: - Helper Methods

extension ItemCell {
    
    private func config() {
        guard let avatarUrl = item?.owner.avatar_url else { return }
        guard let title = item?.full_name else { return }
        guard let description = item?.description else { return }
        
        DispatchQueue.global().async {
            let url = URL(string: avatarUrl)
            
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                avatar.sd_setImage(with: url)
            }
        }
        
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            titleLabel.text = title
            descriptionLabel.text = description
        }
    }
    
}


