//
//  PastPicturesViewController.swift
//  PigeonServices
//
//  Created by Bridge Dudley on 7/12/23.
//

import Foundation
import UIKit

class PastMemoriesViewController: UIViewController {
    
    private let imageCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    private var memories: [Memory] = []
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        title = "Image Grid"
        
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        imageCollectionView.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.reuseIdentifier)
        
        view.addSubview(imageCollectionView)
        NSLayoutConstraint.activate([
            imageCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            imageCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // Add the refresh control to the collection view
        if #available(iOS 10.0, *) {
            imageCollectionView.refreshControl = refreshControl
        } else {
            imageCollectionView.addSubview(refreshControl)
        }
        
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        
        fetchData()
    }
    
    @objc private func refreshData() {
        fetchData()
    }
    
    private func fetchData() {
        MemoryManager.shared.getPastMemories { [weak self] memories in
            DispatchQueue.main.async {
                self?.memories = memories ?? []
                self?.imageCollectionView.reloadData()
                self?.refreshControl.endRefreshing() // End the refreshing animation
            }
        }
    }
}

extension PastMemoriesViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.reuseIdentifier, for: indexPath) as? ImageCell else {
            return UICollectionViewCell()
        }
        
        let memory = memories[indexPath.item]
        cell.imageView.setImageFromStorage(path: memory.imagePath)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 10
        let collectionViewWidth = collectionView.bounds.width
        let itemWidth = (collectionViewWidth - padding) / 2
        return CGSize(width: itemWidth, height: itemWidth)
    }
}

class ImageCell: UICollectionViewCell {
    
    static let reuseIdentifier = "ImageCell"
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
