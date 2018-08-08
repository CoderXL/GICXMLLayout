//
//  NSObject+GICDataContext.h
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/4.
//

#import <Foundation/Foundation.h>

@interface NSObject (GICDataContext)



/**
 数据上下文
 */
@property (nonatomic,strong)id gic_DataContext;

-(void)setGic_DataContext:(id)gic_DataContext updateBinding:(BOOL)update;

/**
 是否自动继承父节点的数据源。默认yes
 如果设为 no，那么只有在显示设置DataContenxt的情况下才会触发绑定更新
 */
@property (nonatomic,assign)BOOL gic_isAutoInheritDataModel;

/**
 强制更新数据源。但不会对gic_DataContenxt赋值
 */
-(void)gic_updateDataContext:(id)superDataContenxt;


/**
 获取本身已经设置的数据源。非递归获取

 @return <#return value description#>
 */
-(id)gic_self_dataContext;

/**
 获取数据源，但是忽略非自动继承的数据源

 @return <#return value description#>
 */
-(id)gic_DataContenxtIgnorNotAutoInherit:(BOOL)isIgnorNotAutoInherit;
@end
