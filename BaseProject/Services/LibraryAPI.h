//
//  LibraryAPI.h
//  BaseProject
//
//  Created by Chung BD on 6/3/15.
//  Copyright (c) 2015 Bui Chung. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkManager.h"
#import "UserDataManager.h"
#import "ModelManager.h"

@interface LibraryAPI : NSObject
@property (nonatomic, retain) NetworkManager *network;
@property (nonatomic, retain) ModelManager *model;
@property (nonatomic, retain) UserDataManager *user;

+ (LibraryAPI*) shareInstance;
@end
