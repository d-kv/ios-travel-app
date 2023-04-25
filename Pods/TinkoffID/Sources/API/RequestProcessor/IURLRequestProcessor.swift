//
//  IURLRequestProcessor.swift
//  TinkoffID
//
//  Copyright (c) 2021 Tinkoff
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

import Foundation

/// Объект, выполняющий сетевые запросы
protocol IURLRequestProcessor {

    /// Выполняет сетевой запрос
    /// - Parameters:
    ///   - request: Запрос
    ///   - completion: Коллбек с результатом выполнения
    func process(_ request: URLRequest, completion: @escaping (Result<Data, Error>) -> Void)
}

extension URLSession: IURLRequestProcessor {

    enum Error: Swift.Error {
        case unknown
    }

    func process(_ request: URLRequest, completion: @escaping (Result<Data, Swift.Error>) -> Void) {
        dataTask(with: request) { data, _, error in
            guard let data = data else {
                return completion(.failure(error ?? Error.unknown))
            }

            completion(.success(data))
        }.resume()
    }
}
