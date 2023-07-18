//
//  TodaysMemoryViewController.swift
//  PigeonServices
//
//  Created by Bridge Dudley on 7/10/23.
//

import Foundation
import UIKit

class TodaysMemoryViewController: UIViewController {
    
    var memory: Memory?
    var memoryViews: [UIView] = []
    var veilViews: [UIView] = []
    
    let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.layer.borderColor = UIColor.systemPink.cgColor
        view.layer.zPosition = 1
        view.clipsToBounds = true
        view.alpha = 0
        return view
    }()
    
    let imageBackground: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 255/255, green: 0/255, blue: 255/255, alpha: 1.0)
        view.clipsToBounds = true
        view.layer.zPosition = 0.8
        view.layer.cornerRadius = 7
        view.alpha = 0
        return view
    }()
    
    let noteScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.layer.cornerRadius = 5
        scrollView.alpha = 0
        return scrollView
    }()
    
    let noteView: UITextView = {
        let view = UITextView()
        view.backgroundColor = UIColor(red: 255/255, green: 0/255, blue: 255/255, alpha: 0.1)
        view.textColor = .darkGray
        view.font = .systemFont(ofSize: 16)
        view.alpha = 0
        view.isEditable = false
        return view
    }()
    
    let openMemoryView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "heart.fill")
        view.tintColor = UIColor(red: 255/255, green: 0/255, blue: 255/255, alpha: 1.0)
        view.isUserInteractionEnabled = true
        view.alpha = 0
        return view
    }()
    
    let pigeonView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "pigeon-transparent")
        view.contentMode = .scaleAspectFit
        view.alpha = 0
        return view
    }()
    
    let bubbleView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "chatbubble")
        view.alpha = 0
        return view
    }()
    
    let bubbleTextLabel: UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: """
        Pigeon services...\n
        Please tap me to reveal a memory.
        """)
        
        // Set font and spacing attributes
        let font = UIFont.italicSystemFont(ofSize: 16.0)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1.0
        
        attributedText.addAttributes([
            .font: font,
            .paragraphStyle: paragraphStyle
        ], range: NSRange(location: 0, length: attributedText.length))
        label.attributedText = attributedText
        label.textAlignment = .left
        label.numberOfLines = 0
        label.alpha = 0
        return label
    }()
    
    let activityIndicatorView: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView(style: .gray)
        indicatorView.hidesWhenStopped = true
        return indicatorView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        addSubviews()
        self.memoryViews = [
            self.imageBackground,
            self.imageView,
            self.noteView,
            self.noteScrollView
        ]
        self.veilViews = [
            self.bubbleView,
            self.bubbleTextLabel,
            self.openMemoryView,
            self.pigeonView
        ]
        //        configureSettingsButton()
        refreshMemory()
        addTargets()
    }
    
    func addSubviews() {
        view.addSubview(imageView)
        view.addSubview(imageBackground)
        view.addSubview(noteScrollView)
        view.addSubview(openMemoryView)
        view.addSubview(pigeonView)
        view.addSubview(bubbleView)
        bubbleView.addSubview(bubbleTextLabel)
        noteScrollView.addSubview(noteView)
        view.addSubview(activityIndicatorView)
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicatorView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16)
        ])
    }
    
    func refreshMemory() {
        activityIndicatorView.startAnimating()
        MemoryManager.shared.getTodaysMemory { [weak self] mem in
            guard let self = self else { return }
            guard let mem = mem else {
                self.alertError()
                self.activityIndicatorView.stopAnimating()
                return
            }
            self.memory = mem
            self.imageView.setImageFromStorage(path: mem.imagePath)
            self.noteView.text = mem.message
            if mem.seen {
                self.fadeViews(self.memoryViews, fadeIn: true)
                self.fadeViews(self.veilViews, fadeIn: false)
            } else {
                self.fadeViews(self.veilViews, fadeIn: true)
                self.fadeViews(self.memoryViews, fadeIn: false)
            }
            self.activityIndicatorView.stopAnimating()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let imageWidth: CGFloat = view.frame.width - UI_SIDE_INSET*4
        let imageHeight: CGFloat = 400
        self.imageView.frame = CGRect(x: UI_SIDE_INSET*2, y: view.safeAreaInsets.bottom + UI_SIDE_INSET, width: imageWidth, height: imageHeight)
        let backgroundWidth = imageWidth*1.07
        let backgroundHeight = imageHeight*1.07
        self.imageBackground.frame = CGRect(x: imageView.frame.minX-(backgroundWidth-imageWidth)/2, y: imageView.frame.minY-(backgroundHeight-imageHeight)/2, width: backgroundWidth, height: backgroundHeight)
        
        let imageViewHeight: CGFloat = 150
        
        // TODO: Make the height adaptive
        self.noteScrollView.frame = CGRect(x: UI_SIDE_INSET*2, y: imageBackground.frame.maxY + UI_SIDE_INSET*2, width: imageView.frame.width, height: 150)
        self.noteView.frame = noteScrollView.bounds
        
        let openMemorySize: CGFloat = self.view.frame.width - UI_SIDE_INSET*2
        self.openMemoryView.frame = CGRect(x: UI_SIDE_INSET, y: self.view.frame.height/2 - openMemorySize/2, width: openMemorySize, height: openMemorySize)
        
        let pigeonWidth = 0.7*openMemorySize
        let pigeonHeight = 0.6*openMemorySize
        self.pigeonView.frame = CGRect(x: openMemoryView.frame.minX + (openMemorySize-pigeonWidth)/2 + 10, y: openMemoryView.frame.minY + (openMemorySize-pigeonHeight)/2, width: pigeonWidth, height: pigeonHeight)
        
        let bubbleSize = CGSize(width: view.frame.width - UI_SIDE_INSET*4, height: view.frame.height/4)
        self.bubbleView.frame = CGRect(x: UI_SIDE_INSET*2, y: view.safeAreaInsets.top + 5, width: bubbleSize.width, height: bubbleSize.height)
        
        self.bubbleTextLabel.frame = CGRect(x: 25, y: -10, width: bubbleSize.width, height: bubbleSize.height)
    }
    
    func configureSettingsButton() {
        let settingsButton = UIBarButtonItem(image: UIImage(named: "line.3.horizontal"), style: .plain, target: self, action: #selector(settingsButtonTappes))
        navigationItem.rightBarButtonItem = settingsButton
    }
    
    func addTargets() {
        let unveilTap = UITapGestureRecognizer(target: self, action: #selector(revealMemory))
        openMemoryView.addGestureRecognizer(unveilTap)
        let swipeGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
        self.view.addGestureRecognizer(swipeGestureRecognizer)
    }
    
    @objc func fadeViews(_ views: [UIView], fadeIn: Bool) {
        for v in views {
            UIView.animate(withDuration: 0.5, animations: {
                v.alpha = fadeIn ? 1.0 : 0.0
            })
        }
    }
    
    @objc func revealMemory() {
        guard let memory = self.memory else {
            alertError()
            return
        }
        MemoryManager.shared.setMemorySeen(id: memory.id!) { [weak self] success in
            guard let self = self else { return }
            if !success {
                self.alertError()
                return
            }
            self.fadeViews(self.veilViews, fadeIn: false)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                guard let self = self else { return }
                self.fadeViews(self.memoryViews, fadeIn: true)
            }
        }
    }
    
    @objc func handleSwipeGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
        let translation = gestureRecognizer.translation(in: view)
        
        if gestureRecognizer.state == .ended {
            if translation.y > 100 { // Adjust the threshold to your preference
                refreshMemory()
            }
        }
    }
    
    
    @objc func settingsButtonTappes() {
        print("hi")
    }
    
    private func alertError() {
        let alert = UIAlertController(title: "Something went wrong!",
                                      message: "Sorry babe ;(", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
        self.present(alert, animated: true)
    }
    
}

