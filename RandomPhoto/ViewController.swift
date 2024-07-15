//
//  ViewController.swift
//  RandomPhoto
//
//  Created by Tsuen Hsueh on 2021/9/11.
//

import UIKit

class ViewController: UIViewController {

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .white
        return imageView
    }()
    
    private let button: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("Click me!", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    let colors: [UIColor] = [
        .systemGray,
        .systemRed,
        .systemOrange,
        .systemTeal,
        .systemGreen,
        .systemBlue,
        .systemPink,
        .systemYellow,
        .systemPurple,
        .systemIndigo
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // change the background color
        view.backgroundColor = .systemPink
        view.addSubview(imageView)
        imageView.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
        imageView.center = view.center
        
        view.addSubview(button)
        
        getRandomPhoto()
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }

    @objc func didTapButton() {
        getRandomPhoto()
        view.backgroundColor = colors.randomElement()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        button.frame = CGRect(
            x: 30,
            y: view.frame.size.height-150-view.safeAreaInsets.bottom,
            width: view.frame.size.width-60,
            height: 55
        )
    }
    
    func getRandomPhoto() {
        if let url = URL(string: "https://picsum.photos/600") {
            NetworkManager.shared.fetchData(from: url) { [weak self] data, response, error in
                if let error = error {
                    print("Error: \(error)")
                    return
                }

                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.imageView.image = image
                    }
                }
            }
        }
    }

}
