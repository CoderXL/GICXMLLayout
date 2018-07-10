//
//  GICListItem.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/6.
//

#import "GICListItem.h"

#import "GICStringConverter.h"
#import "GICNumberConverter.h"
#import "GICListTableViewCell.h"

//@interface GICListItem (){
//    
//}
//
//@end

@implementation GICListItem
+(NSString *)gic_elementName{
    return @"list-item";
}

+(NSDictionary<NSString *,GICValueConverter *> *)gic_propertySetters{
    return @{
             @"id":[[GICStringConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 GICListItem *item = (GICListItem *)target;
                 item->_identifyString = value;
             }],
             @"selection-style":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 [target setValue:value forKey:@"selectionStyle"];
             }],
             @"event-item-select":[[GICStringConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 GICListItem *item = (GICListItem *)target;
                 item.itemSelectEvent = [[GICListItemSelectedEvent alloc] initWithExpresion:value];
                 [item.itemSelectEvent attachTo:target];
             }],
             @"item-height":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 GICListItem *item = (GICListItem *)target;
                 item->itemHeight = [value floatValue];
             }],
             };
}

-(BOOL)gic_parseOnlyOneSubElement{
    return YES;
}

-(CGFloat)cellHeight{
    if(self->itemHeight>0)
        return self->itemHeight;
    return _cellAutoHeight;
}

-(void)setCellHeight:(CGFloat)cellHeight{
    if(cellHeight>_cellAutoHeight){
        _cellAutoHeight = cellHeight;
        if(self.delegate)
            [self.delegate listItem:self cellHeightUpdate:cellHeight];

    }
//    if(_cellAutoHeight != cellHeight){
//        _cellAutoHeight = cellHeight;
//        if(self.delegate)
//            [self.delegate listItem:self cellHeightUpdate:cellHeight];
//    }
}

-(NSObject *)gic_getSuperElement{
    return (NSObject *)self.delegate;
}

-(void)gic_parseSubElements:(NSArray<GDataXMLElement *> *)children{
    if(children.count==1){
        self.xmlDoc = [[GDataXMLDocument alloc] initWithRootElement:children[0]];
    }
}

-(UITableViewCell *)getCell:(UITableView *)target{
    GICListTableViewCell *cell = [target dequeueReusableCellWithIdentifier:self.identifyString];
    if(cell == nil){
         cell = [[GICListTableViewCell alloc] initWithListItem:self];
    }else{
        cell.listItem = self;
    }
    return cell;
}
@end
