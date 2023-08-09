//
//
// PhotoViewModel.swift
// Navigation
//
// Created by Александр Востриков
//
    

import UIKit

final class PhotoViewModel {
    
    private var photo: [UIImage] = []
    
    init(photo: [UIImage]) {
        self.photo = photo
    }
    
    func numberOfItems() -> Int {
        photo.count
    }
    
    func getPhoto(at index: Int) -> UIImage {
        photo[index]
    }
}
