//
//  CoreDataTool.swift
//  OA
//
//  Created by 洪继伟 on 2021/12/16.
//


import UIKit
import CoreData

/*
 * 注意
 * 当coredata数据库发生变化，app升级-coredata迁移升级
 * https://blog.csdn.net/chocolateloveme/article/details/40430385
 * 指定加载的数据库版本
 */
class CoreDataTool: NSObject {

    static let container: NSPersistentContainer = {
        
        let temp = NSPersistentContainer(name: "OA")
        
        temp.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return temp
        
    }()
    
    static let context: NSManagedObjectContext = container.viewContext
    
    
    /// 创建一个新模型
    /// - Returns: 模型类型
    static func getNewModel<T:NSManagedObject>(mType:T.Type) -> T {
           //创建一个实例并给属性赋值
        let name = "\(mType.self)"
        let model = NSEntityDescription.insertNewObject(forEntityName: name, into: context) as! T
        
        return model
    }
    
    /// 创建模型
    /// - Parameter dict: 字段字典
    /// - Returns: 对象
    static func getNewModel<T:NSManagedObject>(dict:[String: Any]) -> T{
        let model:T = getNewModel(mType: T.self)
        model.setValuesForKeys(dict)
        return model
    }
    
    
    /// 从字典数组中获取数据
    /// - Parameter data: 字典数组
    /// - Returns: 数据
    static func getListFromDict<T:NSManagedObject>(data:AnyObject?) -> [T]{
        
        guard let _data = data else { return []}
        
        let dictArr = _data as! [[String:AnyObject]]
        
        var list:[T] = []
        for dict in dictArr {
            let model:T = getNewModel(dict: dict)
            list.append(model)
        }
       
        return list
    }
    
    
    /// 保存
    static func save() {
        
        //MARK: todo 是否要加锁  ==注释==
        if context.hasChanges {
            do {
                try context.save()
                
                print("coredata save successful.")
                
            } catch {
   
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
        
    }

    /// 根据条件获取队列
    /// - Returns: 条件："name = \"算法（第4版）\""
    static func getList<T:NSManagedObject> (_ whereStr:String?=nil) -> [T] {
        
        let Query = NSFetchRequest<T>(entityName: T.description())
        if let _where = whereStr {
            Query.predicate = NSPredicate(format: _where)
        }
        
        
        do {
            return try context.fetch(Query)
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }

    }
    
    
    
    
    /// 根据条件获取队列
    /// - Returns: 条件："name = \"算法（第4版）\""
    static func getList<T:NSManagedObject> (_ whereStr:String?=nil, sortkey: String? = nil, ascending: Bool? = false) -> [T] {
        
        var sortkeys:[String] = []
        var ascendings:[Bool] = []
        
        if let _sortkey = sortkey {
            sortkeys.append(_sortkey)
            ascendings.append(ascending!)
        }
        
        return getList(whereStr, sortkeys: sortkeys, ascending: ascendings)
    }
    
    
    /// 根据条件获取队列
    /// - Returns: 条件："name = \"算法（第4版）\""
    static func getList<T:NSManagedObject> (_ whereStr:String?=nil, sortkeys: [String]? = nil, ascending: [Bool]? = nil) -> [T] {
        
        let Query = NSFetchRequest<T>(entityName: T.description())
        if let _where = whereStr {
            if _where.count>0 {
                Query.predicate = NSPredicate(format: _where)
            }
        }
        
        var sorts:[NSSortDescriptor] = []
        if let _sortkeys = sortkeys {
            
            for i in 0..<_sortkeys.count {
                
                var asc = false
                if let _ascending = ascending {
                    if _ascending.count > i{
                        asc = _ascending[i]
                    }
                }
                
                let sort = NSSortDescriptor(key: _sortkeys[i], ascending: asc)
                sorts.append(sort)
            }
            
            Query.sortDescriptors = sorts
        }
        
        
        do {
            return try context.fetch(Query)
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    
    
    /// 根据条件查找第一个
    /// - Returns:
    static func first<T:NSManagedObject> (whereStr:String?=nil) -> T? {
        
        let list:[T] =  getList(whereStr)
        
        if list.count>0
        {
            return list[0]
        }
 
        return nil
    }
    
    
    /// 删除
    static func delete<T:NSManagedObject> (model:T)  {
        do {
            context.delete(model)
            if context.hasChanges {
                try context.save()
            }
        } catch {
            print("\(error)")
        }
    }
    
    
    /// 删除
    static func delete<T:NSManagedObject> (models:[T])  {
        do {
            
            for model in models {
                context.delete(model)
            }
            
            if context.hasChanges {
                try context.save()
            }
        } catch {
            print("\(error)")
        }
    }
    
    
    /// 根据类型和条件删除
    static func delete<T:NSManagedObject> (type:T.Type,_ whereStr:String?=nil)  {
        
        let TEntity = NSFetchRequest<T>(entityName: T.description())
        if let _where = whereStr {
            TEntity.predicate = NSPredicate(format: _where)
        }

        do {
              let models = try context.fetch(TEntity)
                for model in models {
                    context.delete(model)
                }
                
                if context.hasChanges {
                    try context.save()
                }
            
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }

    }
}
