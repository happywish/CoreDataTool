//
//  NSManagedObject.swift
//  OA
//
//  Created by 洪继伟 on 2021/12/16.
//

import UIKit
import CoreData

extension NSManagedObject {
    
    //网络请求的属性多于自定义模型属性的时候，需要重写这2个方法
    public override class func setValue(_ value: Any?, forUndefinedKey key: String) {}
    public override func setValue(_ value: Any?, forUndefinedKey key: String) {}
    
    //不知道 为什么不加会报错
    open override class func value(forUndefinedKey key: String) -> Any? {
        return nil
    }
    open override func value(forUndefinedKey key: String) -> Any? {
        return nil
    }
    
    /// 根据类型和条件删除
    class func delete(_ whereStr:String?=nil)  {
        
        let TEntity = NSFetchRequest<NSManagedObject>(entityName: self.description())
        if let _where = whereStr {
            TEntity.predicate = NSPredicate(format: _where)
        }

        do {
            let models:[NSManagedObject] = try CoreDataTool.context.fetch(TEntity)
                for model in models {
                    CoreDataTool.context.delete(model)
                }
                
            if CoreDataTool.context.hasChanges {
                try CoreDataTool.context.save()
                }
            
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
}
