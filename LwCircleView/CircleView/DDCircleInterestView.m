//
//  DDCircleInterestView.m
//  DDCircleView
//
//  Created by appleDeveloper on 15/9/10.
//  Copyright (c) 2015年 appleDeveloper. All rights reserved.
//

#import "DDCircleInterestView.h"

@interface DDCircleInterestView ()

@property (strong, nonatomic) NSMutableArray *dataSource;

@property (strong, nonatomic) UIView *centerView;

@property (assign, nonatomic) CGPoint centerPoint;

@property (strong, nonatomic) NSTimer *timer;

@property (strong,nonatomic) NSMutableArray *views;

@property (assign ,nonatomic) float angle;

@end

#define anglePerSecond   M_PI/(1080 * 2)

#define  CircleViewWidth    400
#define  CircleViewHeight   400

#define MainScreenSize     [[UIScreen mainScreen] bounds].size

// 2种半径 规格
#define Radius     120
#define MaxRadius  155

@implementation DDCircleInterestView

- (instancetype)initWithData:(NSArray *)data{
    self = [super initWithFrame:CGRectMake((MainScreenSize.width - CircleViewWidth)/2, (MainScreenSize.height - CircleViewHeight)/2, CircleViewWidth, CircleViewWidth)];
    if (self) {
        self.dataSource = [NSMutableArray arrayWithArray:data];
        [self setupData];
        [self initUI];
    }
    return self;
}

- (void)setupData{
    _angle = 0.f;
    _views = [NSMutableArray array];
}

- (void)initUI{
    [self initCenterView];

    [self initCircleView];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(startAnimaition) userInfo:nil repeats:YES];
}

#pragma mark -  转动的view
- (void)initCircleView{
    
    NSInteger counter = self.dataSource.count;
    for (NSInteger idx =0; idx < self.dataSource.count; idx ++) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor redColor];
        NSInteger idx = arc4random() %3;
        view.frame = CGRectMake(0, 0, idx * 15 + 60, idx * 15 + 60);
        
        CGFloat radius = 0.f;
        if (CGRectGetWidth(view.frame) == 90.f) {
            radius = Radius;
        }else{
            radius = MaxRadius ;
        }
        
        view.center = CGPointMake(_centerPoint.x + radius *
                                        cosf(2 * idx * M_PI / counter),
                                        _centerPoint.y + radius *
                                        sinf(2 * idx * M_PI / counter));
        view.layer.masksToBounds = YES;
        view.layer.cornerRadius = CGRectGetHeight(view.frame)/2;
        view.userInteractionEnabled = YES;
        view.tag = idx;
        [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cmdTap:)]];
        [self addSubview:view];
        [self.views addObject:view];
    }
}

- (void)cmdTap:(UITapGestureRecognizer *)tap{
    
    [self actionTimer];
    NSInteger tag = tap.view.tag;
    if (self.delegate && [self.delegate respondsToSelector:@selector(circleView:DidSelectItem:)]) {
        [self.delegate circleView:self DidSelectItem:tag + 1];
    }
}

- (void)actionTimer{
    if ([_timer isValid]) {
        [_timer invalidate],_timer = nil;
    }else{
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(startAnimaition) userInfo:nil repeats:YES];
    }
}

#pragma mark - 开始动画
- (void)startAnimaition{
    [UIView animateWithDuration:.2 delay:0 options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionCurveLinear animations:^{
        NSInteger counter = self.dataSource.count;
        
        for (NSInteger idx = 0; idx < counter; idx ++) {
            UIView *view = _views[idx];
            _angle += anglePerSecond;
            CGFloat radius = 0.f;
            if (CGRectGetWidth(view.frame) == 90.f) {
                radius = Radius ;
            }else{
                radius = MaxRadius;
            }
            view.center = CGPointMake(_centerPoint.x + radius *
                                      cosf(2 * idx * M_PI / counter + _angle),
                                      _centerPoint.y + radius *
                                      sinf(2 * idx * M_PI / counter + _angle));
            
        }
        
    } completion:^(BOOL finished) {
        
    }];
}


#pragma mark - 中间圆心
- (void)initCenterView{
    self.centerView = [[UIView alloc] init];
    self.centerView.frame = CGRectMake((CircleViewHeight - 110)/2, (CircleViewHeight - 110)/2, 110, 110);
    self.centerView.backgroundColor = [UIColor redColor];
    self.centerView.layer.masksToBounds = YES;
    self.centerView.layer.cornerRadius = CGRectGetHeight(self.centerView.frame)/2;
    self.centerPoint = self.centerView.center;
    self.centerView.userInteractionEnabled = YES;
    [self.centerView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cmdCenterViewTap:)]];
    [self addSubview:self.centerView];
}

- (void)cmdCenterViewTap:(UITapGestureRecognizer *)tap{
    [self actionTimer];
    if (self.delegate && [self.delegate respondsToSelector:@selector(circleView:DidSelectItem:)]) {
        [self.delegate circleView:self DidSelectItem:0];
    }
}

// 画同心圆环 // 三层 // radius 分别为 100 140 180
- (void)drawRect:(CGRect)rect{
    
    int array[3] = {100,140,180};
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetRGBStrokeColor(context,1,1,1,1.0);
    CGContextSetLineWidth(context, 2.0);
    CGContextAddArc(context, 200 , 200, array[0], 0, 2*M_PI, 0);
    CGContextDrawPath(context, kCGPathStroke);
    
    CGContextSetRGBStrokeColor(context,1,1,1,1.0);
    CGContextSetLineWidth(context, 2.0);
    
    CGContextAddArc(context, 200 , 200, array[1], 0, 2*M_PI, 0);
    CGContextDrawPath(context, kCGPathStroke);
    
    CGContextSetRGBStrokeColor(context,1,1,1,1.0);
    CGContextSetLineWidth(context, 2.0);
    CGContextAddArc(context, 200 , 200, array[2], 0, 2*M_PI, 0);
    CGContextDrawPath(context, kCGPathStroke);
}


- (void)dealloc{
    self.dataSource = nil;
    self.centerView = nil;
    [self.timer invalidate],self.timer = nil;
}

@end
