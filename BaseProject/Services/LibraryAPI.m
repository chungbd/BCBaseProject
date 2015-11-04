//
//  LibraryAPI.m
//  BaseProject
//
//  Created by Chung BD on 6/3/15.
//  Copyright (c) 2015 Bui Chung. All rights reserved.
//

#import "LibraryAPI.h"
#import "NetworkManager.h"
#import "ModelManager.h"
#import "UserDataManager.h"

static LibraryAPI *_staticLibrary;

@implementation LibraryAPI
{
    
}
-(instancetype)init{
    self = [super init];
    if (self) {
        self.network = [[NetworkManager alloc] init];
        self.model = [[ModelManager alloc] init];
        self.user = [[UserDataManager alloc] init];
    }
    return self;
}
#pragma mark - singleton
+ (LibraryAPI *)shareInstance{
    static LibraryAPI *shareInstance = nil;
    
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        shareInstance = [[LibraryAPI alloc] init];
    }
                  );
    
    return shareInstance;
}

@end
