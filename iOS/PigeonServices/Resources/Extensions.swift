//
//  Extensions.swift
//  PigeonServices
//
//  Created by Bridge Dudley on 7/12/23.
//

import Foundation
import FirebaseStorage
import FirebaseStorageUI

extension UIImageView {
    func setImageFromStorage(path: String) {
        let ref = Storage.storage().reference(withPath: path)
        self.sd_setImage(with: ref, placeholderImage: nil)
    }
}
