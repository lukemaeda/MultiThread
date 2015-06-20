//
//  main.m
//  MultiThread
//
//  Created by MAEDA HAJIME on 2014/04/28.
//  Copyright (c) 2014年 HAJIME MAEDA. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"

int main(int argc, char * argv[])
{
    // メインスレッド用
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
