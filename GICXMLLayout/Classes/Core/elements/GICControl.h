//
//  GICControl.h
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/8/3.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

@interface GICControl : ASControlNode{
    __weak ASDisplayNode *currentDisplayNode;
}
@property (nonatomic, readonly,weak) ASDisplayNode  * normalNode;
@property (nonatomic, readonly,weak) ASDisplayNode  * highlightNode;
@property (nonatomic, readonly,weak) ASDisplayNode  * disableNode;
@property (nonatomic, readonly,weak) ASDisplayNode  * selectedNode;


//@property (nonatomic, readonly) GICEvent  * highlightEvent;
//@property (nonatomic, readonly) GICEvent  * enableEvent;
//@property (nonatomic, readonly) GICEvent  * selectedEvent;
@end
