//
//  FeedSearchConnection.h
//  GoogleFeedSearch
//
//  Created by Mark on 9/28/13.
//  Copyright (c) 2013 Mark Hambly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FeedSearchConnection : NSObject

@property (strong, nonatomic) NSString *searchQuery;

-(void)start;

@end
