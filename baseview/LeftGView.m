
#import "LeftGView.h"
#import "ImageNetManager.h"
#import "GDefine.h"
#import "UIView_Extras.h"
#import "GImageView.h"
#import "ADSessionInfo.h"
#define KHangJianJu 18.0
@implementation LeftGView 

- (id)initWithFrame:(CGRect)frame
{
	if((self = [super initWithFrame:frame]))
	{
        self.backgroundColor = [UIColor clearColor];
        [self upDataView];
	}
    return self;
}
- (CGSize)getString:(NSString *)string fontNum:(float)fontNum
{
    UIFont *font = [UIFont boldSystemFontOfSize:fontNum];
    CGSize size = [string sizeWithFont:font constrainedToSize:CGSizeMake(160, MAXFLOAT)];
    return size;
    
}
- (void)upDataView
{

    UIImageView *backImage = [[UIImageView alloc]initWithFrame:self.bounds];
    backImage.image = IMG(leftBgImage);
    [self addSubview:backImage];
    [backImage release];
    
    UIImageView *ewmbgImage = [[UIImageView alloc]initWithFrame:CGRectMake(20, 20, 160, 160)];
    ewmbgImage.image = IMG(ewmbg);
    [self addSubview:ewmbgImage];
    [ewmbgImage release];
    
    [self buildImage:[ADSessionInfo sharedSessionInfo].qrcode_url frame:CGRectMake(30, 30, 160-20, 160-20) defaultimg:IMG(bItem_iconDefalut)];
    
    UILabel *labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(20, 195.0, 160, 20)];
    labelTitle.backgroundColor = [UIColor clearColor];
    labelTitle.textColor = [UIColor whiteColor];
    labelTitle.font = [UIFont boldSystemFontOfSize:18.0];
    labelTitle.text = LTXT(TKN_LEFT_TITLE);
    labelTitle.textAlignment = NSTextAlignmentCenter;
    [self addSubview:labelTitle];
    [labelTitle release];
    
    
    float Oy = 195.0+70;
    CGSize mingchengSize = [self getString:[NSString stringWithFormat:@"%@%@",LTXT(TKN_MINGCHEHNG),[ADSessionInfo sharedSessionInfo].store_name] fontNum:16.0];
    UILabel *mingchengLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, Oy, mingchengSize.width, mingchengSize.height)];
    mingchengLabel.text =[NSString stringWithFormat:@"%@%@",LTXT(TKN_MINGCHEHNG),[ADSessionInfo sharedSessionInfo].store_name];
    mingchengLabel.numberOfLines = 0;
    mingchengLabel.textAlignment = NSTextAlignmentLeft;
    mingchengLabel.font = [UIFont boldSystemFontOfSize:16.0];
    mingchengLabel.backgroundColor = [UIColor clearColor];
    mingchengLabel.textColor = [UIColor whiteColor];
    [self addSubview:mingchengLabel];
    [mingchengLabel release];
    
    Oy += KHangJianJu + mingchengSize.height;
    
    CGSize mendiandizhiSize = [self getString:[NSString stringWithFormat:@"%@%@",LTXT(TKN_MENDIANDIZHI),[ADSessionInfo sharedSessionInfo].store_address] fontNum:16.0];
    UILabel *mendiandizhiLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, Oy, mendiandizhiSize.width, mendiandizhiSize.height)];
    mendiandizhiLabel.text =[NSString stringWithFormat:@"%@%@",LTXT(TKN_MENDIANDIZHI),[ADSessionInfo sharedSessionInfo].store_address];
    mendiandizhiLabel.numberOfLines = 0;
    mendiandizhiLabel.textAlignment = NSTextAlignmentLeft;
    mendiandizhiLabel.font = [UIFont boldSystemFontOfSize:16.0];
    mendiandizhiLabel.backgroundColor = [UIColor clearColor];
    mendiandizhiLabel.textColor = [UIColor whiteColor];
    [self addSubview:mendiandizhiLabel];
    [mendiandizhiLabel release];
    
    Oy += KHangJianJu + mendiandizhiSize.height;
    
    CGSize phoneSize = [self getString:[NSString stringWithFormat:@"%@%@",LTXT(TKN_MENDIANDIANHUA),[ADSessionInfo sharedSessionInfo].store_telephone] fontNum:16.0];
    UILabel *phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, Oy, phoneSize.width, phoneSize.height)];
    phoneLabel.numberOfLines = 0;
    phoneLabel.text =[NSString stringWithFormat:@"%@%@",LTXT(TKN_MENDIANDIANHUA),[ADSessionInfo sharedSessionInfo].store_telephone];
    phoneLabel.textAlignment = NSTextAlignmentLeft;
    phoneLabel.font = [UIFont boldSystemFontOfSize:16.0];
    phoneLabel.backgroundColor = [UIColor clearColor];
    phoneLabel.textColor = [UIColor whiteColor];
    [self addSubview:phoneLabel];
    [phoneLabel release];
    
    Oy += KHangJianJu + phoneSize.height;
    
    CGSize peopleSize = [self getString:[NSString stringWithFormat:@"%@%@",LTXT(TKN_CAOZUOYUAN),[ADSessionInfo sharedSessionInfo].nick_name] fontNum:16.0];
    UILabel *peopleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, Oy, peopleSize.width, peopleSize.height)];
    peopleLabel.numberOfLines = 0;
    peopleLabel.text =[NSString stringWithFormat:@"%@%@",LTXT(TKN_CAOZUOYUAN),[ADSessionInfo sharedSessionInfo].nick_name];
    peopleLabel.textAlignment = NSTextAlignmentLeft;
    peopleLabel.font = [UIFont boldSystemFontOfSize:16.0];
    peopleLabel.backgroundColor = [UIColor clearColor];
    peopleLabel.textColor = [UIColor whiteColor];
    [self addSubview:peopleLabel];
    [peopleLabel release];
    
    Oy += KHangJianJu + peopleSize.height;
    
    CGSize peoplePhoneSize = [self getString:[NSString stringWithFormat:@"%@%@",LTXT(TKN_CAOZUOYUANDIANHUA),[ADSessionInfo sharedSessionInfo].store_mobilephone] fontNum:16.0];
    UILabel *peoplePhoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, Oy, peoplePhoneSize.width, peoplePhoneSize.height)];
    peoplePhoneLabel.numberOfLines = 0;
    NSString *phoneNumber = [ADSessionInfo sharedSessionInfo].store_mobilephone;
    if (phoneNumber == nil) {
        phoneNumber = @"无";
    }
    peoplePhoneLabel.text =[NSString stringWithFormat:@"%@%@",LTXT(TKN_CAOZUOYUANDIANHUA),phoneNumber];
    peoplePhoneLabel.textAlignment = NSTextAlignmentLeft;
    peoplePhoneLabel.font = [UIFont boldSystemFontOfSize:16.0];
    peoplePhoneLabel.backgroundColor = [UIColor clearColor];
    peoplePhoneLabel.textColor = [UIColor whiteColor];
    [self addSubview:peoplePhoneLabel];
    [peoplePhoneLabel release];
    
    Oy += KHangJianJu + peoplePhoneSize.height;
    
    
}
- (void)upQrcodeImg
{
    GImageView *image = (GImageView *)[self viewWithTag:KTagGImageView];
    if (image) {
        [image loadImage:[ADSessionInfo sharedSessionInfo].qrcode_url defalutImage:IMG(bItem_iconDefalut)];
        image.frame = CGRectMake(30, -170, 160-20, 160-20);
    }

}
- (void)animationQrcodeImg
{
    GImageView *image = (GImageView *)[self viewWithTag:KTagGImageView];
    [UIView animateWithDuration:0.2 animations:^{
    image.frame = CGRectMake(30, 30, 160-20, 160-20);

     } completion:^(BOOL finished) {
    
    }];
}

- (void)upQrcodeImgBtn
{
    GImageView *image = (GImageView *)[self viewWithTag:KTagGImageView];
    if (image) {
        [image loadImage:@"" defalutImage:IMG(bItem_iconDefalut)];
    }
}

@end
