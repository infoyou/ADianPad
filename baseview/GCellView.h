
#import "GView.h"

@interface GCellView : GView
{
    UIImageView* bgview;
    UIImageView* arrow;
    UIImageView* arrow2;
    BOOL passChangeBg;
}

@property (nonatomic,retain) NSDictionary* dict;

-(void) removeArrow;

@end

@interface GCellPeople : GCellView
{
}

-(void) buildCell:(NSDictionary*)dt;

@end

@class GThirdFriendViewController;
@interface GCellPeople2 : GCellView
{
}

@property (nonatomic,assign) BOOL hasAdd;
@property (nonatomic,assign) BOOL beInvite;
@property (nonatomic,assign) GThirdFriendViewController* parent;

-(void) buildCell:(NSDictionary*)dt;

@end
