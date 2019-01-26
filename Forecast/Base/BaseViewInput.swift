//
//  BaseViewInput.swift
//  Forecast
//
//  Created by Evgenii Kyivskyi on 1/26/19.
//  Copyright © 2019 Evgenii Kyivskyi. All rights reserved.
//

import Foundation

protocol BaseViewInput: class {
    func show(error: Error)
    func showLoader()
    func hideLoader()
}
