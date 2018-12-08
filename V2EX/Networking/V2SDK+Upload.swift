//
//  V2SDK+Upload.swift
//  V2EX
//
//  Created by xushuifeng on 2018/12/8.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import Foundation
import GenericNetworking
import Alamofire

// https://sm.ms/doc/
extension V2SDK {
    
    class func upload(data: Data, completion: @escaping (MSUploadResponse?, Error?) -> Void) {
        let url = "https://sm.ms/api/upload"
        Alamofire.upload(data, to: url).responseData { dataResponse in
            if let data = dataResponse.data {
                if let json = try? JSONDecoder().decode(MSUploadResponse.self, from: data) {
                    completion(json, nil)
                } else {
                    completion(nil, NSError(domain: "v2ex", code: 1002, userInfo: [NSLocalizedDescriptionKey: "上传失败"]))
                }
            } else {
                completion(nil, dataResponse.error)
            }
        }
    }
}

struct MSUploadResponse: Codable {
    
    /// 上传文件状态。正常情况为 success。出现错误时为 error
    let code: String
    
    /// 上传文件时所用的文件名, eg: smms.jpg
    let filename: String
    
    /// 上传后的文件名, eg: 561cc4e3631b1.png
    let storename: String
    
    /// 文件大小, eg: 187851
    let size: Int
    
    /// 图片的宽度, eg: 1157
    let width: Int
    
    /// 图片的高度, eg: 680
    let height: Int
    
    /// 随机字符串，用于删除文件, eg: nLbCw63NheaiJp1
    let hash: String
    
    /// 删除上传的图片文件专有链接, eg: https://sm.ms/api/delete/nLbCw63NheaiJp1
    let delete: String
    
    /// 图片服务器地址, eg: https://ooo.0o0.ooo/2015/10/13/561cfc3282a13.png
    let url: String
    
    /// 图片的相对地址, eg: /2015/10/13/561cfc3282a13.png
    let path: String
    
    /// 上传图片出错时将会出现
    let msg: String
}
