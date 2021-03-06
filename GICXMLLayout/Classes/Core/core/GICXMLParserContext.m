//
//  GICXMLParserContext.m
//  GICXMLLayout
//
//  Created by gonghaiwei on 2018/7/7.
//

#import "GICXMLParserContext.h"

@implementation GICXMLParserContext{
    GICXMLParserContext *next;//下一个
    GICXMLParserContext *prev;//前一个
}

-(id)initWithXMLDoc:(GDataXMLDocument *)xmlDoc{
    self = [super init];
    self->_xmlDoc = xmlDoc;
    _currentTemplates = [NSMutableDictionary dictionary];
    return self;
}

static GICXMLParserContext *current;

+(instancetype)currentInstance{
    return current;
}

+(void)resetInstance:(GDataXMLDocument *)xmlDoc{
    GICXMLParserContext *context = [[GICXMLParserContext alloc] initWithXMLDoc:xmlDoc];
    if(current !=nil){
        context->prev = current;
        current->next = context;
    }
    current = context;
}

+(void)parseCompelete{
    current = current->prev;
}
@end
