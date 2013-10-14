//
//  FeedSearchConnection.m
//  GoogleFeedSearch
//
//  Created by Mark on 9/28/13.
//  Copyright (c) 2013 Mark Hambly. All rights reserved.
//

#import "FeedSearchConnection.h"

@interface FeedSearchConnection () <NSURLConnectionDelegate, NSURLConnectionDataDelegate>

@property (strong, nonatomic) NSURLConnection *connection;
@property (strong, nonatomic) NSMutableData *response;

@end

@implementation FeedSearchConnection


-(void)start {
	self.response = [[NSMutableData alloc] init];
	NSString *googleFeedSearchURL = @"http://ajax.googleapis.com/ajax/services/feed/find?v=1.0&q=";
	NSString *searchString = [self.searchQuery stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",googleFeedSearchURL, searchString]];
	
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
	[request setValue:@"http://fermenticus.com" forHTTPHeaderField:@"Referer"];
	
	request.timeoutInterval = 10;
	self.connection = [NSURLConnection connectionWithRequest:request
																delegate:self];
	[self.connection start];
	
	
}


-(void) connection:(NSURLConnection *)conn didReceiveData:(NSData *)data {
	[self.response appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
	NSError *error;
	NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:self.response
																	   options:0
																		 error:&error];
//	NSLog(@"%@",responseDictionary);
	[[NSNotificationCenter defaultCenter] postNotificationName:@"FeedSearchConnectionFinished"
														object:responseDictionary];
}

-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	self.response = nil;
	self.connection = nil;
	NSLog(@"Connection Failed: %@", error.localizedDescription);
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"FeedSearchConnectionFailed" object:nil];
	
}




@end
