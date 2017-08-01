//
//  ViewController.m
//  html
//
//  Created by apple on 17/4/14.
//  Copyright © 2017年 apple. All rights reserved.
//
//
//  ViewController.m
//  HTML排版
//
//  Created by zhenghuadong on 17/3/26.
//  Copyright © 2017年 zhenghuadong. All rights reserved.
//

#import "ViewController.h"
#import "MYHTMLView.h"
#import "MYHTMLLabel.h"
#import "MYHTMLImageVIew.h"
#import "MYHTMLCoreTextView.h"

@interface ViewController ()<MYHTMLCoreTextViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MYHTMLView * contentView = [[MYHTMLView alloc] init];
    contentView.frame = self.view.bounds;
    [self.view addSubview:contentView];
    
    
    MYHTMLView * view = [[MYHTMLView alloc] init];
    view.backgroundColor = [UIColor redColor];
    view.positionH = PositionHCenter;
    view.positionV = PositionVCenter;
    view.width = 70;
    view.height = 40;
    
    
    MYHTMLView * view1 = [MYHTMLView viewWithStatic];
    view1.backgroundColor = [UIColor blueColor];
    view1.htmlWidth = 100;
    view1.height = 64;
    
    MYHTMLView * view2 = [MYHTMLView viewWithStatic];
    view2.backgroundColor = [UIColor grayColor];
    view2.htmlWidth = 20;
    view2.height = self.view.height - 64 - 49;
    
    MYHTMLView * view3 = [MYHTMLView viewWithStatic];
    view3.backgroundColor = [UIColor greenColor];
    view3.htmlWidth = 80;
    view3.height = view2.height;
    [view3 addTargit:self selector:@selector(clickView3:)];
    
    MYHTMLView * view4 = [MYHTMLView viewWithStatic];
    view4.backgroundColor = [UIColor purpleColor];
    view4.htmlWidth = 100;
    view4.height = 49;
    
    MYHTMLLabel * view1Label = [MYHTMLLabel viewWithRelative];
    view1Label.positionH = PositionHCenter;
    view1Label.positionV = PositionVCenter;
    view1Label.text = @"nav";
    
    MYHTMLLabel * view2Label = [MYHTMLLabel viewWithRelative];
    view2Label.positionH = PositionHCenter;
    view2Label.positionV = PositionVCenter;
    view2Label.text = @"left";
    view2Label.font = [UIFont systemFontOfSize:20];
    view2Label.color = [UIColor greenColor];
    
    
    
    MYHTMLLabel * view3Label = [MYHTMLLabel viewWithRelative];
    view3Label.positionH = PositionHCenter;
    view3Label.positionV = PositionVCenter;
    view3Label.text = @"right";
    [view3Label addTargit:self selector:@selector(clickView3Label:)];
    
    
    MYHTMLImageVIew * view4Label = [MYHTMLImageVIew viewWithRelative];
    view4Label.positionH = PositionHCenter;
    view4Label.positionV = PositionVCenter;
    view4Label.image = [UIImage imageNamed:@"tizhi"];
    view4Label.htmlWidth = 20;
    view4Label.htmlHeight = 100;
    view4Label.isGray = true;
    
    
    
    MYHTMLCoreTextView * view4Coretext = [MYHTMLCoreTextView viewWithStatic];
    
    view4Coretext.attributeJson = @[@{
                                        CONTENT:@"fad",
                                        NSLinkAttributeName:@"点击黑色文字"
                                        
                                        },
                                    @{
                                        CONTENT:[UIImage imageNamed:@"tizhi"],
                                        @"width":@30,
                                        @"height":@30,
                                        NSLinkAttributeName:@"点击图片"
                                        },
                                    @{
                                        CONTENT:@"fagasdf",
                                        NSFontAttributeName:[UIFont systemFontOfSize:20],
                                        NSForegroundColorAttributeName:[UIColor greenColor],
                                        NSLinkAttributeName:@"点击绿色文字"
                                        
                                        }];
    
    view4Coretext.width = 50;
    [view4Coretext hereSizeToFit];
    view4Coretext.delegate = self;
    view4Coretext.backgroundColor = [UIColor redColor];
    
    
    
    [contentView addSubview:view];
    [contentView addSubview:view1];
    [contentView addSubview:view2];
    [contentView addSubview:view3];
    [contentView addSubview:view4];
    [view1 addSubview:view1Label];
    [view2 addSubview:view2Label];
    [view3 addSubview:view3Label];
    [view3 addSubview:view4Coretext];
    [view4 addSubview:view4Label];
    
    
    [contentView layout];
    
    // Do any additional setup after loading the view, typically from a nib.
}

-(void) clickView3:(UIView *) view{
    NSLog(@"点击");
}

-(void) clickView3Label:(UIView *) view{
    NSLog(@"点击label");
}

-(void)coreTextView:(MYHTMLCoreTextView *)view clickURL:(NSString *)url{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"点击" message:url delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
    [alert show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

