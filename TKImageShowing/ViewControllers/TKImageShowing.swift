//
//  TKImageShowing.swift
//  TKImageShowing
//
//  Created by ThangKieu on 5/3/18.
//  Copyright © 2018 ThangKieu. All rights reserved.
//

import UIKit


open class TKImageShowing: UIViewController, Zoomable{
    
    open var canZoom: Bool = true
    open var bgColor: UIColor = .black
    open var spacing: CGFloat = CGFloat(10)
    open var maximumZoom: CGFloat = CGFloat(3)
    
    
    open var images = [TKImageSource?]()
    open var currentIndex = 0
    open weak var animatedView:UIImageView?
    open var originIndex = 0
    
    private let actionViewHeight = CGFloat(34)
    fileprivate let cellId = "TKImageCell"
    
    internal var cwCollection:UICollectionView!
    
    private var isInCollection = false
    private var actionView:UIView!
    private var btnClose:UIButton!
    private var isShowActionView = true
    private var transitionStyle: UIModalTransitionStyle = .crossDissolve
    private var presentationStyle: UIModalPresentationStyle  = .fullScreen
       
   open var currentCell:TKImageCell?{
       get{
           return cwCollection.visibleCells.first as? TKImageCell
       }
   }

   open override var modalTransitionStyle: UIModalTransitionStyle {
       get {
           return transitionStyle
       }
       set {
           self.transitionStyle = newValue
       }
   }
   
   open override var modalPresentationStyle: UIModalPresentationStyle {
       get {
           return presentationStyle
       }
       set {
           self.presentationStyle = newValue
       }
   }
    
    override open func viewDidLoad() {
        self.modalTransitionStyle = .crossDissolve
        self.transitioningDelegate = self
        super.viewDidLoad()
        commonInit()
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.originIndex = currentIndex
        scrollItem(to: currentIndex)
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showActionView()
    }
    
    //MARK:- COMMON INIT
    
    func commonInit() {
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.showActionView)))
        setupCollectionView()
        setupActionView()
        setupCloseButton()

    }
    
    func setupCollectionView() {
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0
  
        self.cwCollection = UICollectionView(frame: self.view.bounds, collectionViewLayout: flowLayout)
        self.view.addSubview(self.cwCollection!)
        
        self.cwCollection.isPagingEnabled = true
        self.cwCollection.register(TKImageCell.self, forCellWithReuseIdentifier: self.cellId)
        self.cwCollection.dataSource = self
        self.cwCollection.delegate = self
        
        
    }
    
    func setupActionView() {
    
        self.actionView = UIView(frame: .zero)
        self.actionView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.actionView)
        self.view.bringSubviewToFront(self.actionView)
        
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
    
    func setupCloseButton() {
        self.btnClose = UIButton(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
        let imvClose = UIImageView(frame: CGRect(x: 12.5, y: 12.5, width: 15, height: 15))
        imvClose.contentMode = .scaleToFill
        
        let bundle = Bundle(for: TKImageShowing.self)
        let bundleURL = bundle.resourceURL?.appendingPathComponent("TKImageShowing.bundle")
        let resource = Bundle(url: bundleURL!)
        imvClose.image = UIImage(named: "close.png", in: resource, compatibleWith: nil)
        self.btnClose.setImage(nil, for: .normal)
        self.btnClose.contentMode = .scaleToFill
        self.btnClose.addTarget(self, action: #selector(self.closing), for: .touchUpInside)
        self.actionView.addSubview(imvClose)
        btnClose.center = imvClose.center
        self.actionView.addSubview(self.btnClose)
        
    }
    
    //MARK:- Action
    @objc func closing() {

        if let currentCell = self.cwCollection.visibleCells.first as? TKImageCell{
            currentCell.endZoom = {[weak self] in
                self?.currentCell?.endZoom = nil
                self?.dismiss(animated: true, completion: nil)
            }
            currentCell.resetZoom(isDismiss:true)
        }
    }
    
    @objc func showActionView() {
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
            let value =  self.isShowActionView ?  1 :  0
            self.actionView.alpha = CGFloat(value)
        }) { (_) in
            self.isShowActionView = !self.isShowActionView
        }
    }
    
    func scrollItem(to index:Int) {
        cwCollection.scrollToItem(at: IndexPath(row: index, section: 0), at: .right, animated: false)
    }
}
 //MARK:- UICollectionViewDelegate
extension TKImageShowing:UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let tkCell = cell as? TKImageCell{
            tkCell.resetZoom()
        }
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let center = CGPoint(x: scrollView.contentOffset.x + (scrollView.frame.width / 2), y: (scrollView.frame.height / 2))
        if let indexPath = self.cwCollection.indexPathForItem(at: center) {
            self.currentIndex = indexPath.row
        }
    }
}

extension TKImageShowing:UICollectionViewDataSource {
    //MARK:- EXTENSION UICollectionViewDataSource
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.compactMap({$0}).count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellId, for: indexPath) as! TKImageCell
        let imageSource = self.images.compactMap({$0})
        cell.setImage(imageSource[indexPath.row])
        
        cell.config(with: self)
        return cell
    }
    
}

//MARK: - Transition Animation
extension TKImageShowing:UIViewControllerTransitioningDelegate {
    public func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController)
        -> UIViewControllerAnimatedTransitioning? {
            return MoveInPresentAnimatedTransitioning(animatedView: self.animatedView)
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return MoveOutPresentAnimatedTransitioning(animatedView: self.animatedView, animatedCell: self.currentCell, isAnimated: self.originIndex == self.currentIndex)
    }
}
