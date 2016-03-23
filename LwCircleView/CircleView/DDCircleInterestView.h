//
//  DDCircleInterestView.h
//  DDCircleView
//
//  Created by appleDeveloper on 15/9/10.
//  Copyright (c) 2015年 appleDeveloper. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DDCircleInterestViewDelegate ;

@interface DDCircleInterestView : UIView

@property (weak, nonatomic) id<DDCircleInterestViewDelegate>delegate;


- (instancetype)initWithData:(NSArray *)data;


@end



@protocol DDCircleInterestViewDelegate <NSObject>

@optional

- (void)circleView:(DDCircleInterestView *)circleView DidSelectItem:(NSInteger)item;

@end