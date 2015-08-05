//
//  Model.m
//  CastVideos
//
//  Created by PavelVPV on 05.08.15.
//  Copyright (c) 2015 Google inc. All rights reserved.
//

#import "Model.h"

@implementation Model


+ (Model *)sharedModel
{
    static dispatch_once_t pred;
    static Model *_sharedModel = nil;
    
    dispatch_once(&pred, ^{ _sharedModel = [[self alloc] init];
    });
    return _sharedModel;
}

+ (instancetype)init{
    
    Model * model = [Model new];
    
    return model;
}

@end
