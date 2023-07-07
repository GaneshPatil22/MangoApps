//
//  NetworkError.swift
//  MangoApp
//
//  Created by Ganesh Patil on 06/07/23.
//

import Foundation

import Foundation

enum NetworkError: Error {
    case InvalidURL(String)
    case APIError(String)
    case NoDataReceived(String)
    case DecoderError(String)
    case SomethingWentWrong(String)
}
