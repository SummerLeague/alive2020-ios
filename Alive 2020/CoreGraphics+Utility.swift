//
//  CoreGraphics+Utility.swift
//  Alive 2020
//
//  Created by Mark Stultz on 6/25/17.
//  Copyright © 2017 Summer League. All rights reserved.
//

import CoreGraphics

extension CGFloat {
    public static var deg2rad: CGFloat { return pi / 180.0 }
    public static var rad2deg: CGFloat { return 180.0 / pi }
}

extension CGAffineTransform {
    func scale() -> CGSize {
        return CGSize(
            width: sqrt(self.a * self.a + self.c * self.c),
            height: sqrt(self.b * self.b + self.d * self.d))
    }
    
    func rotation() -> CGFloat {
        return CGFloat(atan2f(Float(self.b), Float(self.a)))
    }
    
    func degrees() -> CGFloat {
        return rotation() * CGFloat.rad2deg
    }
}
