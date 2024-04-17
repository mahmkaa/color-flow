//
//  GameCell.swift
//  Color Flow
//
//  Created by Павел Петров on 12.04.2024.
//

import UIKit

class GameCell: UICollectionViewCell {
    static let reuseIdentifire = "GameCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 5
        contentView.clipsToBounds = true
    }
}
