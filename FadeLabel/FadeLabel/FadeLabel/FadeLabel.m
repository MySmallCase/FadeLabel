//
//  FadeLabel.m
//  FadeLabel
//
//  Created by MyMac on 15/11/11.
//  Copyright © 2015年 MyMac. All rights reserved.
//

#import "FadeLabel.h"

@interface FadeLabel ()

@property (nonatomic,strong) NSMutableAttributedString *attributedString;

@property (nonatomic,strong) NSMutableArray *characterAnimationDurations;

@property (nonatomic,strong) NSMutableArray *characterAnimationDelays;

@property (nonatomic,strong) CADisplayLink *displaylink;

@property (nonatomic,assign) CFTimeInterval beginTime;

@property (nonatomic,assign) CFTimeInterval endTime;

@property (nonatomic,assign,getter = isFadedOut) BOOL fadedOut;

@property (nonatomic, copy) void (^completion)();

@end

@implementation FadeLabel


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initialize];
    }
    return self;
}


/**
 *  初始化
 */
- (void)initialize{
    self.shineDuration = 2.5;
    self.fadeOutDuration = 2.5;
    self.autoStart = NO;
    self.fadedOut = YES;
    self.textColor = [UIColor whiteColor];
    
    self.characterAnimationDurations = [NSMutableArray array];
    self.characterAnimationDelays = [NSMutableArray array];
    
    self.displaylink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateAttributedString)];
    self.displaylink.paused = YES;
    [self.displaylink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    
}

- (void)didMoveToWindow{
    if (nil != self.window && self.autoStart) {
        [self fade];
    }
}

- (void)setText:(NSString *)text
{
    self.attributedText = [[NSAttributedString alloc] initWithString:text];
}

-(void)setAttributedText:(NSAttributedString *)attributedText
{
    self.attributedString = [self initialAttributedStringFromAttributedString:attributedText];
    [super setAttributedText:self.attributedString];
    for (NSUInteger i = 0; i < attributedText.length; i++) {
        self.characterAnimationDelays[i] = @(arc4random_uniform(self.shineDuration / 2 * 100) / 100.0);
        CGFloat remain = self.shineDuration - [self.characterAnimationDelays[i] floatValue];
        self.characterAnimationDurations[i] = @(arc4random_uniform(remain * 100) / 100.0);
    }
}

- (void)fade{
    [self fadeWithCompletion:NULL];
}

- (void)fadeWithCompletion:(void (^)())completion{
    if (!self.isShining && self.isFadedOut) {
        self.completion = completion;
        self.fadedOut = NO;
        [self startAnimationWithDuration:self.shineDuration];
    }
}

- (void)fadeOut
{
    [self fadeOutWithCompletion:NULL];
}

- (void)fadeOutWithCompletion:(void (^)())completion
{
    if (!self.isShining && !self.isFadedOut) {
        self.completion = completion;
        self.fadedOut = YES;
        [self startAnimationWithDuration:self.fadeOutDuration];
    }
}

- (BOOL)isShining
{
    return !self.displaylink.isPaused;
}

- (BOOL)isVisible
{
    return NO == self.isFadedOut;
}


#pragma mark - Private methods

- (void)startAnimationWithDuration:(CFTimeInterval)duration
{
    self.beginTime = CACurrentMediaTime();
    self.endTime = self.beginTime + duration;
    self.displaylink.paused = NO;
}

- (void)updateAttributedString
{
    CFTimeInterval now = CACurrentMediaTime();
    for (NSUInteger i = 0; i < self.attributedString.length; i ++) {
        [self.attributedString enumerateAttribute:NSForegroundColorAttributeName inRange:NSMakeRange(i, 1) options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
            CGFloat currentAlpha = CGColorGetAlpha([value CGColor]);
            BOOL shouldUpdateAlpha = (self.isFadedOut && currentAlpha > 0) || (!self.isFadedOut && currentAlpha < 1) || (now - self.beginTime) >= [self.characterAnimationDelays[i] floatValue];
            if (!shouldUpdateAlpha) return;
            CGFloat percentAge = (now - self.beginTime - [self.characterAnimationDelays[i] floatValue]) / ([self.characterAnimationDurations[i] floatValue]);
            if (self.isFadedOut) {
                percentAge = 1 - percentAge;
            }
            UIColor *color = [self.textColor colorWithAlphaComponent:percentAge];
            [self.attributedString addAttribute:NSForegroundColorAttributeName value:color range:range];
        }];
    }
    
    [super setAttributedText:self.attributedString];
    if (now > self.endTime) {
        self.displaylink.paused = YES;
        if (self.completion) {
            self.completion();
        }
    }
}

- (NSMutableAttributedString *)initialAttributedStringFromAttributedString:(NSAttributedString *)attributedString
{
    NSMutableAttributedString *mutableAttributedString = [attributedString mutableCopy];
    UIColor *color = [self.textColor colorWithAlphaComponent:0];
    [mutableAttributedString addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, mutableAttributedString.length)];
    return mutableAttributedString;
}


@end
