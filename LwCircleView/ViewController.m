//
//  ViewController.m
//  LwCircleView
//
//  Created by appleDeveloper on 16/3/23.
//  Copyright © 2016年 appleDeveloper. All rights reserved.
//

#import "ViewController.h"
#import "DDCircleInterestView.h"

@interface ViewController ()<DDCircleInterestViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSMutableArray *tmpData = [NSMutableArray array];
    for (NSInteger index = 0; index < 9; index ++) {
        [tmpData addObject:@(index)];
    }
    DDCircleInterestView *circleView = [[DDCircleInterestView alloc] initWithData:tmpData];
    circleView.delegate = self;
    [self.view addSubview:circleView];
    
    // test kVC
    
    NSArray *list = @[];
    
}

#pragma mark - DDCircleInterestViewDelegate

- (void)circleView:(DDCircleInterestView *)circleView DidSelectItem:(NSInteger)item
{
    NSLog(@"====%@",@(item));
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

@end
