//
//  SearchCategoryCollectionViewCell.swift
//  pokedex
//
//  Created by elliott kung on 2021-08-24.
//

import UIKit

class SearchCategoryCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "SearchCategoryCollectionViewCell"
    
    // MARK: UIComponents
    
    lazy var categoryImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "house")
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        return image
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "arial", size: 14)
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    public func configure(category: String, imageTitle: String){
        titleLabel.text = category
        categoryImage.image = UIImage(named: imageTitle)
    }
    
    // MARK: Initialization and LayoutSubviews
    override init(frame: CGRect){
        super.init(frame: frame)
        
        contentView.addSubview(categoryImage)
        contentView.addSubview(titleLabel)
        contentView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel.frame = CGRect(x: 5, y: contentView.frame.size.height-50, width: frame.size.width-10, height: 50)
        categoryImage.frame = CGRect(x: 5, y: 0, width: frame.size.width-10, height: contentView.frame.size.height-50)
    }
    
}
