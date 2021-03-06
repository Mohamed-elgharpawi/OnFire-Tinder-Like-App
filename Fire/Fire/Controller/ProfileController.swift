//
//  ProfileController.swift
//  Fire
//
//  Created by mohamed elgharpawi on 10/24/20.
//  Copyright © 2020 mohamed elgharpawi. All rights reserved.
//

import UIKit
import SDWebImage
private let reuseIdentifier = "ProfileCell"

protocol ProfileControllerDelegate:class {
    func profileController(_ controller : ProfileController , didLikeUser user : User)
    func profileController(_ controller : ProfileController , didDislikeUser user : User)

}
class ProfileController: UIViewController {
    //MARK:- Properties
    weak var delegate : ProfileControllerDelegate?
    var last = 0
    private let user : User
    private lazy var viewModel = ProfileViewModel(user: user)
    private lazy var barStackView = SegmentBarView(numberOfSegments: viewModel.imageURLs.count)

    private lazy var collectionView : UICollectionView = {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width+100)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: frame, collectionViewLayout: layout)
        cv.showsHorizontalScrollIndicator = false
        cv.isPagingEnabled = true
        cv.register(ProfileCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        cv.delegate = self
        cv.dataSource = self
    
        
        return cv
    }()
    
    private let blurView : UIVisualEffectView = {
        let blur = UIBlurEffect(style: .regular)
        let view = UIVisualEffectView(effect: blur)
        return view
        
    }()
    
    private let dismissButton:UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "dismiss_down_arrow").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handelDismiss), for: .touchUpInside)
        return button
        
    }()
    private let infoLabel:UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 25)
        return label
        
    }()
    private let professionLabel:UILabel = {
        let label = UILabel()
       
        label.font = UIFont.systemFont(ofSize: 20)
        return label
        
    }()
    private let bioLabel:UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 20)
        return label
        
    }()
    
    private lazy var disLike :UIButton = {
       let btn = createBtn(withImage: #imageLiteral(resourceName: "dismiss_circle"))
        btn.addTarget(self, action: #selector(handelDislike), for: .touchUpInside)
        return btn
        
    }()

    private lazy var superLike :UIButton = {
        let btn = createBtn(withImage: #imageLiteral(resourceName: "super_like_circle"))
        btn.addTarget(self, action: #selector(handelSuperLike), for: .touchUpInside)

         return btn
        
    }()
    private lazy var like :UIButton = {
        let btn = createBtn(withImage: #imageLiteral(resourceName: "like_circle"))
        btn.addTarget(self, action: #selector(handelLike), for: .touchUpInside)

         return btn
        
    }()

    //MARK:- Lifecycle

     init(user : User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        configUi()
        loadUserDate()
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return .portrait
    }
    
    //MARK:- Actions
   @objc func handelDismiss()  {
    dismiss(animated: true, completion: nil)
        
    }
    @objc func handelDislike(){
        delegate?.profileController(self, didDislikeUser: user)
        
    }
    
    @objc func handelSuperLike(){
        
    }
    @objc func handelLike(){
        delegate?.profileController(self, didLikeUser: user)
        
    }
    
    

    
    

    //MARK:- Helpers
    func configUi()  {
        view.backgroundColor = .white
        view.addSubview(collectionView)
        view.addSubview(dismissButton)
        dismissButton.setDimensions(height: 40, width: 40)
        dismissButton.anchor(top: collectionView.bottomAnchor, right: view.rightAnchor, paddingTop: -20, paddingRight: 16)
        let infoStack = UIStackView(arrangedSubviews: [infoLabel,professionLabel,bioLabel])
        infoStack.spacing = 4
        infoStack.axis = .vertical
        view.addSubview(infoStack)
        infoStack.anchor(top: collectionView.bottomAnchor , left: view.leftAnchor , right: view.rightAnchor, paddingTop: 12,paddingLeft: 12,paddingRight: 12)
       
        configBottomControls()
        configuerBarStckView()
        view.addSubview(blurView)
        blurView.anchor(top: view.topAnchor , left: view.leftAnchor ,bottom : view.safeAreaLayoutGuide.topAnchor, right: view.rightAnchor)
    }
    
    func configBottomControls()  {
        let stack = UIStackView(arrangedSubviews: [disLike,superLike,like])
        stack.distribution = .fillEqually
        view.addSubview(stack)
        stack.spacing = -32
        stack.setDimensions(height: 80, width: 300)
        stack.centerX(inView: view)
        stack.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 32)
        
    }
    func createBtn(withImage image : UIImage) ->UIButton{
        let btn = UIButton(type: .system)
        btn.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        btn.contentMode = .scaleAspectFill
        return btn
    }
    
    func loadUserDate()  {
        infoLabel.attributedText = viewModel.userDetailsAtrributedStr
        professionLabel.text = viewModel.profission
        bioLabel.text = viewModel.bio
        
        
    }
    
    func configuerBarStckView()  {
        
        view.addSubview(barStackView)
        barStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 8, paddingLeft: 8,  paddingRight: 8,height: 4)
       
        
    }
    
}





//MARK:- UICollectionViewDelegate
extension ProfileController : UICollectionViewDelegate{
   
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
 
        
            barStackView.markedSegment(index: indexPath.row)
    }
   
  
}

//MARK:- UICollectionViewDataSource

extension ProfileController : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.imageCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ProfileCell
       // cell.imageView.sd_setImage(with:URL(string:  viewModel.imageURLS[indexPath.row]))
        
        
        cell.imageView.sd_setImage(with: viewModel.imageURLs[indexPath.row])
        return cell
    }
    
    
    
}
//MARK:- UICollectionViewDelegateFlowLayout
extension ProfileController : UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.width+100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
}


