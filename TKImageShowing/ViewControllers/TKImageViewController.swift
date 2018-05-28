//
//  TKImageShowing.swift
//  TKImageShowing
//
//  Created by ThangKieu on 5/3/18.
//  Copyright © 2018 ThangKieu. All rights reserved.
//

import UIKit


class TKImageViewController: UIViewController {
    
    var images = [TKImageSource?]()
    
    var currentIndex = 0
    var maximumZoom = CGFloat(3)
    var zoomEnable = true
    var spacing = CGFloat(10)
    var backgroudColor:UIColor = .black
    weak var animatedView:UIImageView?
    
    private let actionViewHeight = CGFloat(35)
    fileprivate let cellId = "TKImageCell"
    
    private var isInCollection = false
    private var cvwCollection:UICollectionView!
    private var actionView:UIView!
    private var btnClose:UIButton!
    private var isShowActionView = true
    
    var currentCell:TKImageCell?{
        get{
            return cvwCollection.visibleCells.first as? TKImageCell
        }
    }
    
    override func viewDidLoad() {
        self.modalTransitionStyle = .crossDissolve
        self.transitioningDelegate = self
        super.viewDidLoad()
        commonInit()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        scrollItem(to: currentIndex)
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showActionView()
    }
    
    //MARK:- COMMON INIT
    
    private func commonInit(){
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.showActionView)))
        setupCollectionView()
        setupActionView()
        setupCloseButton()

    }
    
    private func setupCollectionView(){
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0
  
        self.cvwCollection = UICollectionView(frame: self.view.bounds, collectionViewLayout: flowLayout)
        self.view.addSubview(self.cvwCollection!)
        
        self.cvwCollection.isPagingEnabled = true
        self.cvwCollection.register(TKImageCell.self, forCellWithReuseIdentifier: self.cellId)
        self.cvwCollection.dataSource = self
        self.cvwCollection.delegate = self
        
        
    }
    
    private func setupActionView(){
    
        self.actionView = UIView(frame: .zero)
        self.actionView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.actionView)
        self.view.bringSubview(toFront: self.actionView)
        
        var margin:UILayoutGuide
        if #available(iOS 11.0, *) {
            margin = self.view.safeAreaLayoutGuide
        } else {
            margin = self.view.layoutMarginsGuide
        }
        self.actionView.topAnchor.constraint(equalTo: margin.topAnchor).isActive = true
        self.actionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.actionView.heightAnchor.constraint(equalToConstant: self.actionViewHeight).isActive = true
        self.actionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.actionView.isUserInteractionEnabled = true

    }
    
    private func setupCloseButton(){
        self.btnClose = UIButton(frame: CGRect(x: 10, y: 0, width: self.actionViewHeight, height: self.actionViewHeight))
        self.btnClose.setImage(UIImage(named: "ic_close"), for: .normal)
        self.btnClose.addTarget(self, action: #selector(self.closing), for: .touchUpInside)
        self.actionView.addSubview(self.btnClose)
        
    }
    
    //MARK:- Action
    @objc private func closing(){

        if let currentCell = self.cvwCollection.visibleCells.first as? TKImageCell{
            currentCell.endZoom = {[weak self] in
                self?.currentCell?.endZoom = nil
                self?.dismiss(animated: true, completion: nil)
            }
            currentCell.resetZoom(isDismiss:true)
        }
    }
    
    @objc private func showActionView(){
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
            let value =  self.isShowActionView ?  1 :  0
            self.actionView.alpha = CGFloat(value)
        }) { (_) in
            self.isShowActionView = !self.isShowActionView
        }
    }
    
    private func scrollItem(to index:Int){
        cvwCollection.scrollToItem(at: IndexPath(row: index, section: 0), at: .right, animated: false)
    }
}

//MARK:- EXTENSION UICollectionViewDataSource
extension TKImageViewController:UICollectionViewDataSource{

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.compactMap({$0}).count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellId, for: indexPath) as! TKImageCell
        let imageSource = self.images.compactMap({$0})
        cell.setImage(imageSource[indexPath.row])
        
        cell.config(isZoomable: self.zoomEnable,
                    spacing: self.spacing,
                    maximumZoom: self.maximumZoom,
                    bgColor: self.backgroudColor)
        return cell
    }
    
 
    
}

//MARK:- EXTENSION UICollectionViewDataSource
extension TKImageViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let tkCell = cell as? TKImageCell{
            tkCell.resetZoom()
        }
    }
    
    
}

//MARK: - Transition Animation
extension TKImageViewController:UIViewControllerTransitioningDelegate{
    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController)
        -> UIViewControllerAnimatedTransitioning? {
            return MoveInPresentAnimatedTransitioning(animatedView: self.animatedView)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return MoveOutPresentAnimatedTransitioning(animatedView: self.animatedView, animatedCell: self.currentCell)
    }
}
