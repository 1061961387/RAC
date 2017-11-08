//
//  KFC.m
//  ReactiveCocoaDemo
//
//  Created by 裕福 on 2017/11/6.
//  Copyright © 2017年 裕福. All rights reserved.
//

#import "KFC.h"

@implementation KFC

+ (instancetype)kfcWithDict:(NSDictionary *)dict
{
    KFC *kfc = [[KFC alloc] init];
    [kfc setValuesForKeysWithDictionary:dict];
    return kfc;
}

@end
