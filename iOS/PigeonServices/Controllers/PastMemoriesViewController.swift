//
//  PastPicturesViewController.swift
//  PigeonServices
//
//  Created by Bridge Dudley on 7/12/23.
//

import UIKit
import SDWebImage

class PastMemoriesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // Define your properties here
    private var memories: [Memory] = []
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureNavBar()
        
        // Configure the collection view
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(MemoryCell.self, forCellWithReuseIdentifier: "MemoryCell")
        
        // Add the collection view to the view controller's view
        view.addSubview(collectionView)
        
        // Configure constraints for the collection view
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // Configure the refresh control
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        collectionView.refreshControl = refreshControl
        
        // Fetch past memories
        fetchPastMemories()
    }
    
    @objc func refresh() {
        fetchPastMemories()
    }
    
    func fetchPastMemories() {
        MemoryManager.shared.getPastMemories { [weak self] memories in
            DispatchQueue.main.async {
                self?.memories = memories ?? []
                self?.collectionView.reloadData()
                self?.refreshControl.endRefreshing()
            }
        }
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemoryCell", for: indexPath) as! MemoryCell
        let memory = memories[indexPath.item]
        cell.imageView.setImageFromStorage(path: memory.imagePath)
        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSize = (collectionView.bounds.width - 2) / 3
        return CGSize(width: itemSize, height: itemSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let memory = memories[indexPath.item]
        let memoryViewController = TodaysMemoryViewController()
        memoryViewController.configure(memory: memory)
        navigationController?.pushViewController(memoryViewController, animated: true)
    }
    
    private func configureNavBar() {
        // Create the logo image view and set the image
        let logoImageView = UIImageView(image: UIImage(named: "pigeon-wide-2"))
        logoImageView.contentMode = .scaleAspectFit // Adjust this to your needs
        
        // Add the logo image view to the view hierarchy
        view.addSubview(logoImageView)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        // Set up constraints to position the logo at the top center of the screen
        NSLayoutConstraint.activate([
            // Center the logo horizontally in the superview
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            // Set the top constraint to a value that positions the logo above the safe area
            logoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10), // You can adjust the constant to your desired position
            // Set the width of the logo image view
            logoImageView.widthAnchor.constraint(equalToConstant: 140), // Adjust the width to your desired size
            // Set the height of the logo image view
            logoImageView.heightAnchor.constraint(equalToConstant: 100) // Adjust the height to your desired size
        ])
    }
}

class MemoryCell: UICollectionViewCell {
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Add the image view to the cell's content view
        contentView.addSubview(imageView)
        
        // Configure constraints for the image view
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
