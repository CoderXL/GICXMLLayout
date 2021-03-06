//
//  GICJSCore.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/9/7.
//

#import "GICJSCore.h"
#import "GICJSConsole.h"
#import "GICXMLHttpRequest.h"
#import "NSBundle+GICXMLLayout.h"
#import <objc/runtime.h>
#import <JavaScriptCore/JSBase.h>

// 立即同步执行JS的垃圾回收机制(既然苹果没有将整个API开放出来，我个人觉得还是慎用为上，因为js本身有独立的垃圾回收机制，我们不应该强制的去干预)
void JSSynchronousGarbageCollectForDebugging(JSContextRef ctx);

@implementation NSObject (GICScript)
-(JSContext *)gic_JSContext{
    return objc_getAssociatedObject(self, "gic_JSContext");
}

-(void)setGic_JSContext:(JSContext *)jsContext{
    objc_setAssociatedObject(self, "gic_JSContext", jsContext, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end

@implementation GICJSCore
+(JSContext *)findJSContextFromElement:(NSObject *)element{
    JSContext *context = [element gic_JSContext];
    if(context){
        return context;
    }
    NSObject *superEl = [element gic_getSuperElement];
    if(superEl == nil){
        context = [[JSContext alloc] init];
        context.exceptionHandler = ^(JSContext *context, JSValue *exception) {
            NSLog(@"JSException: %@",exception);
        };
        // 注入GICJSCore
        [self extend:context];
        
        [element setGic_JSContext:context];
        return context;
    }
    return [self findJSContextFromElement:superEl];
}

+(void)extend:(JSContext *)context { return [self extend:context logHandler:nil]; }
+(void)extend:(JSContext*)context logHandler:(void (^)(NSString*,NSArray*,NSString*))logHandler;
{
    // 添加setTimeout方法
    context[@"setTimeout"] = ^(JSValue* function, JSValue* timeout) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)([timeout toInt32] * NSEC_PER_MSEC)), dispatch_get_main_queue(), ^{
            [function callWithArguments:@[]];
        });
    };
    // 添加alert 方法
    context[@"alert"] = ^(JSValue* message){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[message toString] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    };
    
    context[@"XMLHttpRequest"] = [GICXMLHttpRequest class];
    context[@"console"] = [[GICJSConsole alloc] initWithLogHandler:logHandler];
    // 垃圾回收。为了能够及时回收内存，GC的调用很有必要。
    context[@"gc"] = @{};
    context[@"gc"][@"collect"] = ^(JSValue *sync){
        if([sync toBool]){
            // 强制同步调用
            JSSynchronousGarbageCollectForDebugging([JSContext currentContext].JSGlobalContextRef);
        }else{
            // 这种方式并不会立即执行垃圾回收，而是会在下一次的"时机"到了就会去执行，相对于完全不调用来说，这种方式垃圾收集的时机会更加的靠前
            JSGarbageCollect([JSContext currentContext].JSGlobalContextRef);
        }
    };
    
    NSString *jsCoreString = [NSBundle gic_jsCoreString];
    [context evaluateScript:jsCoreString];
//    [context evaluateScript:@"var GIC = window.GIC;"];
    
//    context[@"createElement"] = ^{
//        NSArray<JSValue *> *args = [JSContext currentArguments];
//        NSString *elementName = [[args firstObject] toString];
//        Class c = [GICElementsCache classForElementName:elementName];
//        return [c new];
//    };
}

@end
