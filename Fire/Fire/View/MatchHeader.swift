//
//  MatchHeader.swift
//  Fire
//
//  Created by mohamed elgharpawi on 11/5/20.
//  Copyright © 2020 mohamed elgharpawi. All rights reserved.
//

import UIKit
private let cellIdentifier = "matchCell"

protocol MatchHeaderDelegate : class{
    func matchHaeder(_ header :MatchHeader , wantsToStartChatWith uid: String)
}
class MatchHeader: UICollectionReusableView {
    
    //MARK:- Proprities
    var matches = [Match](){
        didSet{
            collectionView.reloadData()
        }
    }
   weak var delegate :  MatchHeaderDelegate?
    
    private let matchLabel : UILabel = {
        let label = UILabel()
        label.text = "New Matches"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        return label
        
    }()
    private lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.delegate = self
        cv.dataSource = self
        
        cv.register(MatchCell.self, forCellWithReuseIdentifier: cellIdentifier)

        return cv
        
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(matchLabel)
        matchLabel.anchor(top: topAnchor, left: leftAnchor, paddingTop: 12, paddingLeft: 12)
        addSubview(collectionView)
        collectionView.anchor(top: matchLabel.bottomAnchor, left: leftAnchor,bottom: bottomAnchor ,right: rightAnchor, paddingTop: 4, paddingLeft: 12, paddingBottom: 24,paddingRight: 12)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
// MARK: - UICollectionViewDelegate
extension MatchHeader : UICollectionViewDelegate{
    
    
}
// MARK: - UICollectionViewDataSource
extension MatchHeader : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return matches.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! MatchCell
        let viewModel = MatchCellViewModel(match: matches[indexPath.row])
        cell.viewModel = viewModel
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let uid  = matches[indexPath.row].uid else { return  }
        delegate?.matchHaeder(self, wantsToStartChatWith: uid)
    }
    
    
    
}
// MARK: - UICollectionViewDataSource

extension MatchHeader : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 117)
    }
}

