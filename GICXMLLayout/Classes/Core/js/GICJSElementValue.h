//
//  GICJSElementValue.h
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/9/6.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

@protocol GICJSElementValue <JSExport>
// 数据源。用来做绑定的
@property JSValue* dataContext;
// 获取元素属性值
-(id)getAttValue:(NSString *)attName;

// 设置元素属性值
JSExportAs(setAttValue, - (void)setAttValue:(NSString *)attName newValue:(NSString *)newValue);

// 注册事件
JSExportAs(setEvent, - (void)setEvent:(NSString *)eventName eventFunc:(JSValue *)eventFunc);

-(JSValue *)getSuperElement;
// 获取当前元素的子元素
-(NSArray *)subElements;

-(void)removeFromSupeElement;

-(instancetype)init;
@end

@interface GICJSElementValue : NSObject<GICJSElementValue>
@property (nonatomic,weak,readonly)id element;

+(JSValue *)getJSValueFrom:(id)element inContext:(id)jsContext;
@end
