//
//  TestClass.swift
//  Color Flow
//
//  Created by Павел Петров on 16.04.2024.
//

import UIKit
import SnapKit

class TestClass: UIViewController {
    let button = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func testPrint() {
        print("test print")
    }
    
    func testLoadUI() {
        let button = self.button
        button.setTitle("Test", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .gray
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(tapTestButton), for: .touchUpInside)
        view.addSubview(button)
        
        button.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(70)
        }
    }
    
    @objc func tapTestButton() {
        print("Button tapped")
    }
}
