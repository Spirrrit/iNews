//
//  MainCell.swift
//  iNews MVVM+C
//
//  Created by Слава on 22.07.2024.
//

import Foundation
import UIKit

class MainCell: UITableViewCell {
    
    static var identifier = "MainCell"
    
    let title = UILabel()
    let discription = UILabel()
    let image = UIImageView()
    let date = UILabel()
    let source = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell(viewModel: MainCellViewModel){
        title.text = viewModel.title
        discription.text = viewModel.description
        image.image = viewModel.image ?? UIImage(named: "emptyPhoto")
        date.text = viewModel.pubData.toRusString
        source.text = viewModel.source
    }
    
    //MARK: - Setup View
    private func setupView(){
        [title, discription, image , date, source].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        title.font = .boldSystemFont(ofSize: 16)
        title.numberOfLines = 2
        title.textAlignment = .natural
        
        discription.font = .systemFont(ofSize: 14)
        discription.numberOfLines = 3
        discription.textColor = .darkGray
        
        
        image.layer.masksToBounds = true
        image.layer.cornerRadius = 10
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
            
        
        date.font = .systemFont(ofSize: 14)
        date.textColor = .gray
        
        source.font = .systemFont(ofSize: 14)
        source.textColor = .systemGray
    }
}
//MARK: - Set Constraints
extension MainCell {
    private func setConstraints(){
        NSLayoutConstraint.activate([
            
            title.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            title.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 20),
            title.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            discription.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 5),
            discription.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 20),
            discription.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            image.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            image.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            image.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40),
            image.heightAnchor.constraint(equalToConstant: 100),
            image.widthAnchor.constraint(equalToConstant: 100),
            
            date.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            date.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
          
            source.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            source.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
        ])
    }
}
