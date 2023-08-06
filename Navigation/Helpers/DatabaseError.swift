//
//
// DatabaseError.swift
// Navigation
//
// Created by Александр Востриков
//

import Foundation

enum DatabaseError: Error {
    /// Невозможно добавить хранилище.
    case store(model: String)
    /// Не найден momd файл.
    case find(model: String, bundle: Bundle?)
    /// Дубликат поста есть в базе
    case duplicate
    /// Не найдена модель объекта.
    case wrongModel
    /// Кастомная ошибка.
    case error(description: String)
    /// Неизвестная ошибка.
    case unknown(error: Error)
}
