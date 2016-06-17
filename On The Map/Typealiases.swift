//
//  Typealiases.swift
//  On The Map
//
//  Created by Dylan Edwards on 5/18/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

typealias BarButtonClosure = () -> Void
typealias BarButtonClosureWithButtonItemSource = (UIBarButtonItem) -> Void
typealias LoginSuccess = () -> Void
typealias GetStudentInfoArrayCompletion = ([StudentInformation]) -> Void
typealias GetDictionaryCompletion = (NSDictionary) -> Void
typealias OpenLinkClosure = (String) -> Void
