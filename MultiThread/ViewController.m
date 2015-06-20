//
//  ViewController.m
//  MultiThread
//
//  Created by MAEDA HAJIME on 2014/04/28.
//  Copyright (c) 2014年 HAJIME MAEDA. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// [メインスレッド実行]ボタンを押した時
- (IBAction)proc01:(id)sender {
    
    // 時間のかかる処理
    [self doCount];
    
    // 時間のかかる処理の終了処理
    [self doEndCount];
}

// [(1)NSThread 使用]ボタンを押した時
- (IBAction)proc02:(id)sender {
    
    // サブスレッド実行
    [self performSelectorInBackground:@selector(doBackGround)
                           withObject:nil];

    
}

// [(2) NSOperation 使用]ボタンを押した時
- (IBAction)proc03:(id)sender {
    
    // オペレションキュー生成（サブスレッド）
    NSOperationQueue *que01 = [NSOperationQueue new];
    
    // オペレションキュー生成（サブスレッド）
    NSOperationQueue *que02 = [NSOperationQueue mainQueue];
    
    // オペレーション作成
    NSOperation *ope01 = [NSBlockOperation blockOperationWithBlock:^{
        
        // 時間のかかる処理
        [self doCount];
        
    }];
    
    // 終了時処理の設定
    [ope01 setCompletionBlock:^{
        
        // オペレーション作成
        NSOperation *ope02 = [NSBlockOperation blockOperationWithBlock:^{
            
            // 時間のかかる処理の終了処理
            [self doCount];
        }];
        
        // オペレーション実行
        [que02 addOperation:ope02];
    }];
    
    
    // オペレーション実行
    [que01 addOperation:ope01];
}

// [(3) GCD(Grand Central DisPatch)割り当て 使用]ボタンを押した時
- (IBAction)proc04:(id)sender {
    
    // グローバルキュー作成 PRIORITY:優先時（サブスレッド）
    dispatch_queue_t que = dispatch_get_global_queue(
                            DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    // メインキュー作成（メインスレッド）
    dispatch_queue_t que02 = dispatch_get_main_queue();
    
    // 処理実行（非同期）
    dispatch_async(que, ^{
        
        // 時間のかかる処理
        [self doCount];
        
        // 時間のかかる処理の終了処理
        dispatch_async(que02, ^{
            
            [self doEndCount];
        });
    });
}

#pragma mark - Own Method
// *時間のかかる処理
- (void)doCount {
    
    for (int i = 0 ; i < 5; i++) {
        
        NSLog(@"%d：%@", i, [NSThread currentThread]);
        
        // 処理の一時停止　１秒間待ちなさい
        [NSThread sleepForTimeInterval:1.0];
        
    }
}

// 時間のかかる処理の終了処理
- (void)doEndCount {
    
    //
    NSLog(@"End:%@", [NSThread currentThread]);
    
}
     
// バックグランド実行（NSThread用）
- (void)doBackGround {
    
    // メモリー自動解放（スレッド毎に必要）
    @autoreleasepool {
        
        // 時間のかかる処理
        [self doCount];
        
        // 時間のかかる処理の終了処理
        //[self doEndCount];
        
        // メインスレッド終了させる　メイン画面に反映できる
        [self performSelectorOnMainThread:@selector(doEndCount)
                               withObject:nil
                            waitUntilDone:NO];
    }
}


@end
