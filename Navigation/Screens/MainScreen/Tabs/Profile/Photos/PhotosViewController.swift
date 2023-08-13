//
//  PhotosViewController.swift
//  Navigation
//
//  Created by Александр Востриков on 06.02.2022.
//

import UIKit
import iOSIntPackage

class PhotosViewController: UIViewController, PhotosViewControllerProtocol {
    
    //MARK: - vars
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private var imagePublisherFacade: ImagePublisherFacade?
    private var photos: [UIImage] = []
    private var imagesFromPhoto: [UIImage] = []

    
    //MARK: - init
    init() {
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .createColor(lightMode: .white, darkMode: .gray)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - override func
    override func viewDidLoad() {
        super.viewDidLoad()
        title = Constants.photoGalleryText
        imagePublisherFacade = ImagePublisherFacade()
        
        Photos.fetchPhotos { [weak self] imagesFromPhoto in
            self?.imagesFromPhoto =  imagesFromPhoto
        }
    
        imagePublisherFacade?.addImagesWithTimer(time: 1, repeat: 20, userImages: imagesFromPhoto)
        setupDelegate()
        setupView()
        self.collectionView.register(PhotosCollectionViewCell.self, forCellWithReuseIdentifier: Cells.cellForCollection)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        imagePublisherFacade?.subscribe(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        imagePublisherFacade?.removeSubscription(for: self)
        imagePublisherFacade?.rechargeImageLibrary()
    }
}

//MARK: - extension
extension PhotosViewController {
    private func setupDelegate(){
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    private func setupView() {
        view.addSubview(collectionView)
        collectionView.pin(to: view)
    }
}

extension PhotosViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: Cells.cellForCollection,
                                                                for: indexPath) as! PhotosCollectionViewCell
        collectionCell.photoImageView.image = photos[indexPath.item]
        return collectionCell
    }
}

extension PhotosViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (Constants.screenWeight / 3) - 12
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }
}

extension PhotosViewController: ImageLibrarySubscriber {
    func receive(images: [UIImage]) {
        photos = images
        collectionView.reloadData()
    }
}
