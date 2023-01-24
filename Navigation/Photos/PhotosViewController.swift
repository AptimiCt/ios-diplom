//
//  PhotosViewController.swift
//  Navigation
//
//  Created by Александр Востриков on 06.02.2022.
//

import UIKit
import iOSIntPackage

class PhotosViewController: UIViewController {
    
    //MARK: - vars
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private var imagePublisherFacade: ImagePublisherFacade?
    private var photos: [UIImage] = []
    private var timer: Timer?
    private var countMillisecond = 0
    
    //MARK: - init
    init() {
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - override func
    override func viewDidLoad() {
        super.viewDidLoad()
        title = Constants.photoGalleryText
        imagePublisherFacade = ImagePublisherFacade()
        let userImages = Photos.fetchPhotos()
        
        startTimer()
//MARK: - начало выполнения функций с применением фильтров
        //Время выполнения 10-11 секунд
        ImageProcessor().processImagesOnThread(sourceImages: userImages, filter: .allCases[1], qos: .userInteractive) { [weak self] _ in
            self?.stopTimer()
        }
        
//        Время выполнения 5 секунд
//        ImageProcessor().processImagesOnThread(sourceImages: Photos.fetchPhotos(countPhoto: 10), filter: .allCases[3], qos: .userInitiated) { [weak self] _ in
//            self?.stopTimer()
//        }
        
        //        Время выполнения 10 секунд
//        ImageProcessor().processImagesOnThread(sourceImages: Photos.fetchPhotos(countPhoto: 9, startIndex: 5), filter: .allCases[2], qos: .background) { [weak self] _ in
//            self?.stopTimer()
//        }
        
        //        Время выполнения 6 секунд
//        ImageProcessor().processImagesOnThread(sourceImages: Photos.fetchPhotos(countPhoto: 8, startIndex: 11), filter: .allCases[4], qos: .utility) { [weak self] _ in
//            self?.stopTimer()
//        }
        
        //        Время выполнения 7 секунд
//        ImageProcessor().processImagesOnThread(sourceImages: Photos.fetchPhotos(countPhoto: 13, startIndex: 4), filter: .allCases[5], qos: .default) { [weak self] _ in
//            self?.stopTimer()
//        }
//MARK: - Окончание выполнения функций с применением фильтров
        
        imagePublisherFacade?.addImagesWithTimer(time: 1, repeat: 20, userImages: userImages)
        setupDelegate()
        setupView()
        self.collectionView.register(PhotosCollectionViewCell.self, forCellWithReuseIdentifier: Cells.cellForCollection)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        imagePublisherFacade?.subscribe(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        imagePublisherFacade?.removeSubscription(for: self)
        imagePublisherFacade?.rechargeImageLibrary()
    }
    private func startTimer(){
        timer = Timer.scheduledTimer(timeInterval: 1,
                      target: self,
                      selector: #selector(counter),
                      userInfo: nil,
                      repeats: true)
    }
    private func stopTimer(){
        timer?.invalidate()
        print("~\(countMillisecond) секунд(ы)")
    }
    @objc private func counter() {
        countMillisecond += 1
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
