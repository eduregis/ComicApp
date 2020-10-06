//
//  ShelfCollectionViewCell.swift
//  ComicApp
//
//  Created by Fernando de Lucas da Silva Gomes on 18/09/20.
//  Copyright © 2020 Eduardo Oliveira. All rights reserved.
//

import UIKit

class ShelfCollectionViewCell: UICollectionViewCell {

    weak var delegate: PopUpModalDelegate?
    
    var comic: Comic?
    var imageForCell: UIImage?
    var gesture: UITapGestureRecognizer?
    
    let progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.setProgress(0, animated: true)
        progressView.trackTintColor = .clear
        return progressView
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    func configCell(from: Comic) {
        self.progressView.setProgress(0, animated: false)
        if let image = from.image {
            self.imageView.image = UIImage(data: image)
            self.imageForCell = UIImage(data: image)
        } else {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 300))
            print(from.comicId, from.color)
            view.backgroundColor = UIColor(named: from.color ?? "Pink")
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 300))
            label.textColor = .white
            label.text = from.title
            label.font = label.font.withSize(25)
            label.lineBreakMode = .byWordWrapping
            label.numberOfLines = 3
            label.textAlignment = .center
            view.addSubview(label)
            self.imageView.image = view.asImage()
            self.imageForCell = view.asImage()
        }
        if from.status == "Lendo" {
            self.progressView.tintColor = .systemBlue
            if let finishNumber = from.finishNumber, let progressNumber = from.progressNumber {

                animateCell(progressView: self.progressView, progress: (Float(progressNumber)/Float(finishNumber)))
            }
        }
        if from.status == "Lido" {
            self.progressView.setProgress(1, animated: false)
            self.progressView.tintColor = .systemGreen
        }
        if from.status == "Quero Ler" {
            self.progressView.setProgress(0, animated: false)
        }
        self.comic = from
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
        gesture = UITapGestureRecognizer(target: self, action: #selector(openModal))
        self.addGestureRecognizer(gesture!)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        setupConstraints()
    }
    
    func setupView() {
        imageView.contentMode = .scaleAspectFill
        imageView.center = self.center
        imageView.clipsToBounds = true
        self.addSubview(imageView)
        self.addSubview(progressView)
    }
    
    func setupConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        imageView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true

        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.heightAnchor.constraint(equalToConstant: 7).isActive = true
        progressView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        progressView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -2).isActive = true
        }
    
    func animateCell(progressView: UIProgressView, progress: Float) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            UIView.animate(withDuration: 0.2) {
            progressView.setProgress(progress, animated: true)
            }
        }
    }
    
    @objc func openModal() {
        if let image = self.imageForCell, let comic = self.comic {
                      delegate?.popUpModal(image: image, comic: comic)
        }
    }
}

protocol PopUpModalDelegate: AnyObject {
    func popUpModal(image: UIImage, comic: Comic)
}

extension UIView {
    func asImage() -> UIImage {
        if #available(iOS 10.0, *) {
            let renderer = UIGraphicsImageRenderer(bounds: bounds)
            return renderer.image { rendererContext in
                layer.render(in: rendererContext.cgContext)
            }
        } else {
            UIGraphicsBeginImageContext(self.frame.size)
            self.layer.render(in: UIGraphicsGetCurrentContext()!)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return UIImage(cgImage: image!.cgImage!)
        }
    }
}
