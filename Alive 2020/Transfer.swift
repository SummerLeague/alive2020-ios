//
//  Transfer.swift
//  Alive 2020
//
//  Created by Mark Stultz on 7/8/17.
//  Copyright © 2017 Summer League. All rights reserved.
//

import Foundation
import AWSS3

class Transfer: NSObject {
    fileprivate let uuid = UUID().uuidString
    fileprivate let url: URL
    fileprivate let bucket: String
    fileprivate let key: String
    fileprivate let awsCredentials: AwsCredentials
    
    init(url: URL, bucket: String, key: String, credentials: AwsCredentials) {
        self.url = url
        self.bucket = bucket
        self.key = key
        self.awsCredentials = credentials
        super.init()
        registerConfiguration()
    }
    
    public func upload() {
        let expression = AWSS3TransferUtilityUploadExpression()
        expression.setValue("mp4", forRequestParameter: "x-amz-meta-type")
        expression.setValue("\(1080)", forRequestParameter: "x-amz-meta-width")
        expression.setValue("\(1440)", forRequestParameter: "x-amz-meta-height")
        expression.setValue("\(3)", forRequestParameter: "x-amz-meta-duration")
        
        let utility = AWSS3TransferUtility.s3TransferUtility(forKey: uuid)
        utility.uploadFile(
            url,
            bucket: bucket,
            key: key,
            contentType: "video/mp4",
            expression: expression) { (task, error) in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                }
        }
    }
    
    private func registerConfiguration() {
        guard let configuration = AWSServiceConfiguration(
            region: .USEast1,
            credentialsProvider: self) else {
                return
        }
        
        AWSS3TransferUtility.register(with: configuration, forKey: uuid)
    }
}

extension Transfer: AWSCredentialsProvider {
    func credentials() -> AWSTask<AWSCredentials> {
        let completionSource = AWSTaskCompletionSource<AWSCredentials>()
        let credentials = AWSCredentials(
            accessKey: awsCredentials.accessKeyId,
            secretKey: awsCredentials.secretAccessKey,
            sessionKey: awsCredentials.sessionToken,
            expiration: nil)
        completionSource.set(result: credentials)
        return completionSource.task
    }
    
    func invalidateCachedTemporaryCredentials() {
        print("invalidateCachedTemporaryCredentials")
    }
}
