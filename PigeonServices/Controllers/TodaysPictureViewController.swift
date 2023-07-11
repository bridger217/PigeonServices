//
//  TodaysPictureViewController.swift
//  PigeonServices
//
//  Created by Bridge Dudley on 7/10/23.
//

import Foundation
import UIKit

class TodaysPictureViewController: UIViewController {
    
    let imageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "test")
        view.contentMode = .scaleAspectFill
        view.layer.borderColor = UIColor.systemPink.cgColor
        view.layer.zPosition = 1
        view.clipsToBounds = true
        return view
    }()
    
    let imageBackground: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 255/255, green: 0/255, blue: 255/255, alpha: 1.0)
        view.clipsToBounds = true
        view.layer.zPosition = 0.8
        view.layer.cornerRadius = 7
        return view
    }()
    
    let noteScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.layer.cornerRadius = 5
        return scrollView
    }()
    
    let noteView: UITextView = {
        let view = UITextView()
        view.backgroundColor = UIColor(red: 255/255, green: 0/255, blue: 255/255, alpha: 0.1)
        view.textColor = .darkGray
        view.font = .systemFont(ofSize: 16)
        view.text = """
        This is a test note. I'm testing out if the text spills to
        multiple lines, will the scroll view work well? I think
        so, but I'm not sure.
        
        I got the magic stick. I know if I can hit once, I can hit
        twice.
        
        Say baby I got missed calls and emails all going in to details
        bout how you just not happy I keep changing like the leaves out
        go, go. I'll be fine on my own.
        """
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        addSubviews()
    }
    
    func addSubviews() {
        view.addSubview(imageView)
        view.addSubview(imageBackground)
        view.addSubview(noteScrollView)
        noteScrollView.addSubview(noteView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let imageWidth: CGFloat = view.frame.width - UI_SIDE_INSET*4
        let imageHeight: CGFloat = 400
        self.imageView.frame = CGRect(x: UI_SIDE_INSET*2, y: view.safeAreaInsets.bottom + UI_SIDE_INSET, width: imageWidth, height: imageHeight)
        let backgroundWidth = imageWidth*1.07
        let backgroundHeight = imageHeight*1.07
        self.imageBackground.frame = CGRect(x: imageView.frame.minX-(backgroundWidth-imageWidth)/2, y: imageView.frame.minY-(backgroundHeight-imageHeight)/2, width: backgroundWidth, height: backgroundHeight)
        
        let imageViewHeight: CGFloat = 200
        
        self.noteScrollView.frame = CGRect(x: UI_SIDE_INSET*2, y: imageBackground.frame.maxY + UI_SIDE_INSET*2, width: imageView.frame.width, height: imageViewHeight)
        self.noteView.frame = noteScrollView.bounds
    }
    
    
}

