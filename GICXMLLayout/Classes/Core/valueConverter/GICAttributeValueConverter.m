//
//  GICPropertyConverter.m
//  GDataXMLNode_GIC
//
//  Created by 龚海伟 on 2018/7/2.
//

#import "GICAttributeValueConverter.h"

@implementation GICAttributeValueConverter
//-(id)initWithName:(NSString *)name{
//    self = [super init];
//    _name = name;
//    return self;
//}

-(id)convertAnimationValue:(id)from to:(id)to per:(CGFloat)per{
    return nil;
}

-(id)initWithPropertySetter:(GICPropertySetter)propertySetter{
    self = [super init];
    self.propertySetter  = propertySetter;
    return self;
}

-(id)initWithPropertySetter:(GICPropertySetter)propertySetter withGetter:(GICPropertyGetter)propertyGetter{
    self = [super init];
    self.propertySetter  = propertySetter;
    self.propertyGetter = propertyGetter;
    return self;
}

//-(void)setProperty:(UIView *)view withXMLStringValue:(NSString *)xmlStringValue{
//    
//}
@end
