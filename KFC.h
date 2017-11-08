//
//  KFC.h
//  ReactiveCocoaDemo
//
//  Created by 裕福 on 2017/11/6.
//  Copyright © 2017年 裕福. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KFC : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *icon;

+ (instancetype)kfcWithDict:(NSDictionary *)dict;

@end
