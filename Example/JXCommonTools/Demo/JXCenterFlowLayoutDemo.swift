//
//  JXCenterFlowLayoutDemo.swift
//  JXCommonTools_Example
//
//  Created by 1 on 2023/4/14.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit
import JXCommonTools

class JXCenterFlowLayoutDemo: UIViewController, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == horizontalCV3 ||
            collectionView == verticalCV3 {
            return 3
        }
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .red
        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "4 JXCenterFlowLayout"
        view.backgroundColor = .white
        
        view.addSubview(horizontalCV)
        view.addSubview(horizontalCV3)
        view.addSubview(verticalCV)
        view.addSubview(verticalCV3)
        
        horizontalCV.snp.makeConstraints { make in
            make.top.equalTo(100)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(55)
        }
        
        horizontalCV3.snp.makeConstraints { make in
            make.height.leading.trailing.equalTo(horizontalCV)
            make.top.equalTo(horizontalCV.snp.bottom).offset(20)
        }
        
        verticalCV.snp.makeConstraints { make in
            make.top.equalTo(horizontalCV3.snp.bottom).offset(20)
            make.bottom.equalToSuperview()
            make.width.equalTo(55)
            make.trailing.equalTo(view.snp.centerX).offset(-10)
        }
        
        verticalCV3.snp.makeConstraints { make in
            make.top.bottom.width.equalTo(verticalCV)
            make.leading.equalTo(view.snp.centerX).offset(10)
        }
        
    }
    
    lazy var horizontalCV: UICollectionView = {
        let layout = JXCenterFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = .init(width: 40, height: 40)
        layout.minimumLineSpacing = 10
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.dataSource = self
        
        view.backgroundColor = .green
        view.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        return view
    }()
    
    lazy var horizontalCV3: UICollectionView = {
        let layout = JXCenterFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = .init(width: 40, height: 40)
        layout.minimumLineSpacing = 10

        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.dataSource = self
        
        view.backgroundColor = .gray
        view.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        return view
    }()
    
    

    lazy var verticalCV: UICollectionView = {
        let layout = JXCenterFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = .init(width: 40, height: 40)
        layout.minimumLineSpacing = 10

        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.dataSource = self
        
        view.backgroundColor = .green
        view.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")

        return view
    }()

    lazy var verticalCV3: UICollectionView = {
        let layout = JXCenterFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = .init(width: 40, height: 40)
        layout.minimumLineSpacing = 10

        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.dataSource = self
        
        view.backgroundColor = .gray
        view.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")

        return view
    }()
}
