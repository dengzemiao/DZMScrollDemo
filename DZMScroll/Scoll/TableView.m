//
//  TableView.m
//  DZMScroll
//
//  Created by 邓泽淼 on 16/9/29.
//  Copyright © 2016年 DZM. All rights reserved.
//

#import "TableView.h"

@implementation TableView

// 该代理方法是允许执行所有识别的手势
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

@end
