//
//  BaseModel.swift
//  OA
//
//  Created by 洪继伟 on 2021/12/14.
//

import UIKit

//重要：字段需要带上 @objc
class BaseModel: NSObject {

    override init(){
        super.init()
    }
    // 字典转模型
    required init(dict: [String: Any])
    {
        super.init()
        setValuesForKeys(dict)
    }
    
    //网络请求的属性多于自定义模型属性的时候，需要重写这2个方法
     override class func setValue(_ value: Any?, forUndefinedKey key: String) {

     }
     override func setValue(_ value: Any?, forUndefinedKey key: String) {

      }
 
    
    class func GetList<T:BaseModel>(data:AnyObject?) -> [T]{
        
        guard let _data = data else { return []}
        
        let dictArr = _data as! [[String:AnyObject]]
        
        var list:[T] = []
        for dict in dictArr {
            let model:T = T.init(dict: dict)
            list.append(model)
        }
       
        return list
    }
    
}
