## CoreDataTool 和 NSManagedObject+category

### 说明
 - CoreDataTool是对coredata的方法做一些简单封装
 - NSManagedObject+category 是对继承于NSManagedObject的类kvc时的相关方法的重写
 
### 用法

 - getList 从coredata中获取模型数组
 
```swift

  //不带条件
  var data:[Notice] =  CoreDataTool.getList()
  
  //带条件
  var data:[Notice] =  CoreDataTool.getList("type=\(1)")

  //带排序字段
  var data:[Notice] = CoreDataTool.getList("type=\(1)",sortkey: "postDate", ascending: false)
  
  //带多个排序字段
  var data:[Notice] = CoreDataTool.getList("type=\(1)",sortkeys: ["postDate",["id"]], ascending: [false,true])
  
```

  - getListFromDict 将字典数组转化为模型数组
 
 ```swift
 //var data:[[String:AnyObject]] = []
 let res_datas :[Notice] = CoreDataTool.getListFromDict(data: data)
 ```
 
 - getNewModel(dict: dict) 将字典转化为模型 
```
  let dict:[String: Any] = []
  let model:[Notice] = CoreDataTool.getNewModel(dict: dict)
```

- save 保存coredata上下文中改变的数据
```
  CoreDataTool.save()
```

- first 根据条件查找第一个
```
   var model:[Notice] = CoreDataTool.first("type=\(1)")
```

- delete删除

```
  //删除模型
  CoreDataTool.delete(model:model)
  CoreDataTool.delete(models:models)
  //根据类型和条件删除
  CoreDataTool.delete(type: Notice.self, "type=\(1)")
  
  //该方法在NSManagedObject分类中
  NSManagedObject.delete("type=\(1)")
```


## BaseModel

### 说明
 - 通用的字典数组转模型数组
 
### 用法

```
//模型继承BaseModel，属性前带@objc
 class UserModel: BaseModel {
     @objc var depId: Int32 = 0
     @objc var postId: Int32 = 0
     @objc var postName: String?
     @objc var name: String?
     @objc var userId: Int32 = 0
}

//data:[[String:AnyObject]]
 let userList:[UserModel] = UserModel.GetList(data: data)
 
 //dict: [String: Any]
  let user:UserModel = UserModel(dict:dict)
```
