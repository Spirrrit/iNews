//
//  DetailsView.swift
//  iNews MVVM+C
//
//  Created by Слава on 21.07.2024.
//

import Foundation
import UIKit

import UIKit

final class DetailsView: UIViewController {
    
    var detailViewModel: DetailsViewModel?
    var dataSource: DetailsModel?
    
    private var titleNews = UILabel()
    private var discriptionNews = UILabel()
    private var dateNews = UILabel()
    private var imageNews = UIImageView()
    private var browserButton = UIButton()
    private var storeUrlForBrowser: String?
    private var scrollView = UIScrollView()
    
    init(detailViewModel: DetailsViewModel, dataSource: DetailsModel) {
        self.detailViewModel = detailViewModel
        self.dataSource = dataSource
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//MARK: - Lificycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setConstraints()
        displayNewInfo()
    }
//MARKK: - Display info
    func displayNewInfo() {
        titleNews.text = dataSource?.title
        discriptionNews.text = dataSource?.description
        dateNews.text = dataSource?.pubData.toRusString
        imageNews.image = dataSource?.image
        storeUrlForBrowser = dataSource?.link
    }
    
//MARK: - @objc
    
    @objc func browserButtonTap() {
        detailViewModel?.userDidPressGoToBrowser(link: storeUrlForBrowser ?? "")
    }
    @objc func shareButton() {
        detailViewModel?.userDidPressShare(link: storeUrlForBrowser ?? "")
    }
    
//MARK: - Setup Views
    
    private func setupViews(){
        view.backgroundColor = .systemBackground
        view.addSubview(scrollView)
        [titleNews, imageNews, dateNews, discriptionNews, browserButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            scrollView.addSubview($0)
        }
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self , action: #selector(shareButton))
        navigationController?.navigationBar.tintColor = .darkGray
        
        titleNews.font = .boldSystemFont(ofSize: 24)
        titleNews.numberOfLines = 0
        titleNews.text  = ""
        
        discriptionNews.font = UIFont.systemFont(ofSize: 20)
        discriptionNews.numberOfLines = 0
        discriptionNews.text  = ""
        discriptionNews.textColor = .darkGray
        
        dateNews.font = UIFont.systemFont(ofSize: 20)
        dateNews.textColor = .lightGray
        dateNews.numberOfLines = 0
        dateNews.text  = ""
        
        imageNews.layer.masksToBounds = true
        imageNews.layer.cornerRadius = 12
        imageNews.contentMode = .scaleAspectFill
        imageNews.clipsToBounds = true
        
        browserButton.addTarget(self, action: #selector(browserButtonTap), for: .touchUpInside)
        browserButton.setTitle("Перейти в браузер ", for: .normal)
        browserButton.setTitleColor(.darkGray, for: .normal)
        browserButton.backgroundColor = .systemBackground
        browserButton.layer.cornerRadius = 12
        browserButton.layer.borderWidth = 1.5
        browserButton.layer.borderColor = UIColor.darkGray.cgColor
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
    }
}
//MARK: - Set Constraints
extension DetailsView {
    private func setConstraints(){

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            titleNews.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            titleNews.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            titleNews.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            titleNews.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            imageNews.topAnchor.constraint(equalTo: titleNews.bottomAnchor, constant: 20),
            imageNews.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            imageNews.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            imageNews.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
//            imageNews.heightAnchor.constraint(equalToConstant: 250),
            
            dateNews.topAnchor.constraint(equalTo: imageNews.bottomAnchor, constant: 20),
            dateNews.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            dateNews.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            dateNews.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            discriptionNews.topAnchor.constraint(equalTo: dateNews.bottomAnchor, constant: 20),
            discriptionNews.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            discriptionNews.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            discriptionNews.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            browserButton.topAnchor.constraint(equalTo: discriptionNews.bottomAnchor, constant: 20),
            browserButton.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            browserButton.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            browserButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20),
            browserButton.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            browserButton.heightAnchor.constraint(equalToConstant: 50),
        ])
        
        if dataSource?.image == UIImage(named: "emptyPhoto") {
            imageNews.heightAnchor.constraint(equalToConstant: 0).isActive = true
        } else {
            imageNews.heightAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        }
        
    }
}
