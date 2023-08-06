//
//
// PostCellBuilder.swift
// Navigation
//
// Created by Александр Востриков
//
    

import Foundation

struct PostCellBuilder {
    
    func makeBodyImageViewCellViewModel(_ type: BodyImageViewCellViewModel.CellType,
                                        onCellUpdate: (() -> Void)? = nil) -> BodyImageViewCellViewModel {
        switch type {
        case .text:
            return BodyImageViewCellViewModel(
                bodyText: "",
                type: .text,
                onCellUpdate: onCellUpdate
            )
            
        case .image:
            return BodyImageViewCellViewModel(
                bodyText: "",
                type: .image,
                onCellUpdate: onCellUpdate
            )
        }
    }
}
