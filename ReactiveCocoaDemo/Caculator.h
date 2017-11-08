//
//  Caculator.h
//  RAC
//
//  Created by 裕福 on 2017/6/28.
//  Copyright © 2017年 裕福. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Caculator : NSObject

@property (assign, nonatomic) BOOL isEqule;
@property (assign, nonatomic) int result;

- (Caculator *)caculator:(int (^)(int result))caculator;
- (Caculator *)equle:(BOOL (^)(int result))operation;

@end
