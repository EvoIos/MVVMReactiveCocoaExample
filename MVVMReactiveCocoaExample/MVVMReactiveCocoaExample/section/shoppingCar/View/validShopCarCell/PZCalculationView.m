//
//  PZCalculationView.m
//  MVVMReactiveCocoaExample
//
//  Created by Pace.Z on 2017/8/20.
//  Copyright © 2017年 Pace.Z. All rights reserved.
//


#import "PZCalculationView.h"

NSString * const PZCalculationViewReachesTheMaximumValueNotificationName = @"PZCalculationViewReachesTheMaximumValueNotificationName";

@interface PZCalculationView()<UITextFieldDelegate>
@property (nonatomic,strong) UIButton *decreaseButton;
@property (nonatomic,strong) UIButton *increaseButton;
@property (nonatomic,strong) UITextField *amountTF;
@property (nonatomic,assign) NSInteger count;
@end

@implementation PZCalculationView

#pragma mark - life cycle
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initData];
        [self setupUI];
        [self configureNotification];
    }
    return self;
}

- (void)initData {
    self.count = 1;
}

- (void)setupUI {
    self.backgroundColor = [UIColor whiteColor];
    self.clipsToBounds = YES;
    self.layer.borderColor = [UIColor colorWithRed:213/255.0 green:213/255.0 blue:213/255.0 alpha:1].CGColor;
    self.layer.borderWidth = 0.8;
    self.layer.cornerRadius = 3.0f;
    
    self.decreaseButton = ({
        UIButton *tmpBtn = [[UIButton alloc] init];
        [tmpBtn addTarget:self action:@selector(decreaseAction:) forControlEvents:UIControlEventTouchUpInside];
        [tmpBtn setImage:[UIImage imageNamed:@"减"] forState:UIControlStateNormal];
        tmpBtn.backgroundColor = [UIColor whiteColor];
        tmpBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        tmpBtn.layer.borderColor = [UIColor colorWithRed:213/255.0 green:213/255.0 blue:213/255.0 alpha:1].CGColor;
        tmpBtn.layer.borderWidth = 0.8;
        tmpBtn;
    });
    [self addSubview:self.decreaseButton];
    [self.decreaseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.mas_equalTo(self);
        make.width.mas_equalTo(self.mas_height);
    }];
    
    self.increaseButton = ({
        UIButton *tmpBtn = [[UIButton alloc] init];
        [tmpBtn addTarget:self action:@selector(increaseAction:) forControlEvents:UIControlEventTouchUpInside];
        [tmpBtn setImage:[UIImage imageNamed:@"加"] forState:UIControlStateNormal];
        tmpBtn.backgroundColor = [UIColor whiteColor];
        tmpBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        tmpBtn.layer.borderColor = [UIColor colorWithRed:213/255.0 green:213/255.0 blue:213/255.0 alpha:1].CGColor;
        tmpBtn.layer.borderWidth = 0.8;
        tmpBtn;
    });
    [self addSubview:self.increaseButton];
    [self.increaseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.mas_equalTo(self);
        make.width.mas_equalTo(self.mas_height);
    }];
    
    self.amountTF =  ({
        UITextField *tmpTF = [[UITextField alloc] init];
        tmpTF.font = [UIFont systemFontOfSize:15];
        tmpTF.textColor = [UIColor colorWithRed:60/255.0 green:59/255.0 blue:63/255.0 alpha:1];
        tmpTF.borderStyle = UITextBorderStyleNone;
        tmpTF.text = @"1";
        tmpTF.textAlignment = NSTextAlignmentCenter;
        tmpTF.keyboardType = UIKeyboardTypeASCIICapableNumberPad;
        tmpTF.clearButtonMode = UITextFieldViewModeNever;
        tmpTF.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        tmpTF.clipsToBounds = YES;
        tmpTF;
    });
    self.amountTF.delegate = self;
    [self addSubview:self.amountTF];
    [self.amountTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.top.mas_equalTo(self);
        make.left.equalTo(self.decreaseButton.mas_right);
        make.right.equalTo(self.increaseButton.mas_left);
    }];
}

- (void)configureNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChanged:) name:UITextFieldTextDidChangeNotification object:nil];
}

#pragma mark - textfield delegate
- (void)textFieldTextDidChanged:(NSNotification *)notification {
    UITextField *tf = (UITextField *)notification.object;
    if (tf != self.amountTF) { return; }
    
    NSInteger currentCount = tf.text.integerValue;
    self.count = currentCount;
    if (self.max != 0 && currentCount > self.max) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.amountTF.text = [NSString stringWithFormat:@"%ld",self.max];
            self.count = self.max;
            if (self.changeShoppingCount) {
                self.changeShoppingCount(PZCalculationStyleChangedType, self.max);
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:PZCalculationViewReachesTheMaximumValueNotificationName object:@(YES)];
        });
    } else if (self.changeShoppingCount) {
        if (self.count == 0) {
            self.changeShoppingCount(PZCalculationStyleChangedType, 1);
        } else {
            self.changeShoppingCount(PZCalculationStyleChangedType, self.count);
        }
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if  (self.didBeginEditing) {
        self.didBeginEditing(textField);
    }
}


#pragma mark - event response
- (void)decreaseAction:(UIButton *)sender {
    [self endEditing];
    if (self.count == 1) {
        if (self.changeShoppingCount) {
            self.changeShoppingCount(PZCalculationStyleDecreaseType, 1);
            [[NSNotificationCenter defaultCenter] postNotificationName:PZCalculationViewReachesTheMaximumValueNotificationName object:@(NO)];
        }
        return;
    }
    self.count -= 1;
    if (self.changeShoppingCount) {
        self.changeShoppingCount(PZCalculationStyleDecreaseType, self.count);
    }
}

- (void)increaseAction:(UIButton *)sender {
    [self endEditing];
    if (self.max != 0 && self.count == self.max) {
        if (self.changeShoppingCount) {
            self.changeShoppingCount(PZCalculationStyleIncreaseType, self.max);
            [[NSNotificationCenter defaultCenter] postNotificationName:PZCalculationViewReachesTheMaximumValueNotificationName object:@(YES)];
        }
        return;
    }
    self.count += 1;
    if (self.changeShoppingCount) {
        self.changeShoppingCount(PZCalculationStyleIncreaseType, self.count);
    }
}

- (void)endEditing {
    [self.amountTF endEditing:YES];
}

#pragma mark - private methods

#pragma mark - getters and setters
- (void)setCount:(NSInteger)count {
    _count = count;
    self.amountTF.text = [NSString stringWithFormat:@"%ld",count];
}

- (void)setBorderColor:(UIColor *)borderColor {
    _borderColor = borderColor;
    self.layer.borderColor = _borderColor.CGColor;
    self.increaseButton.layer.borderColor = _borderColor.CGColor;
    self.decreaseButton.layer.borderColor = _borderColor.CGColor;
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    _borderWidth = borderWidth;
    self.layer.borderWidth = borderWidth;
    self.increaseButton.layer.borderWidth = borderWidth;
    self.decreaseButton.layer.borderWidth = borderWidth;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    self.layer.cornerRadius = cornerRadius;
    self.increaseButton.layer.cornerRadius = cornerRadius;
    self.decreaseButton.layer.cornerRadius = cornerRadius;
}

- (void)setCurrentCount:(NSUInteger)currentCount {
    _currentCount = currentCount;
    self.count = currentCount;
    self.amountTF.text = [NSString stringWithFormat:@"%ld",currentCount];
}
@end
