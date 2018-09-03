//
//  GICEvent.h
//  GICXMLLayout
//
//  Created by gonghaiwei on 2018/7/8.
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC/ReactiveObjC.h>

@interface GICEvent : GICBehavior{
    NSString *expressionString;
//    RACDisposable *signlDisposable;
}
@property (nonatomic,readonly,strong)RACSubject *eventSubject;
@property (nonatomic,assign,readonly)BOOL onlyExistOne;//是否一个元素上面只能存在一个。默认yes
//@property (nonatomic,strong,readonly)NSString *eventName;

-(id)initWithExpresion:(NSString *)expresion __deprecated_msg("Use initWithExpresion: withEventName.");
-(id)initWithExpresion:(NSString *)expresion withEventName:(NSString *)eventName;

-(void)fire:(id)value;

+(void)createEventWithExpresion:(NSString *)expresion withEventName:(NSString *)eventName toTarget:(id)target;
//+(instancetype)createEventWithExpresion:(NSString *)expresion withTarget:(id)target;
@end
