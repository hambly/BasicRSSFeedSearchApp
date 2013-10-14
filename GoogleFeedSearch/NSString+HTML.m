//
//  NSString+HTML.m
//  GoogleFeedSearch
//
//  Created by Mark on 10/15/13.
//  Copyright (c) 2013 Mark Hambly. All rights reserved.
//

#import "NSString+HTML.h"

@implementation NSString (HTML)

-(NSString *) removeHTML {
	
	NSArray *components = [self componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
	NSMutableArray *componentsToKeep = [NSMutableArray array];
	for (int i = 0; i < [components count]; i = i + 2) {
		[componentsToKeep addObject:[components objectAtIndex:i]];
	}
	NSString *cleanedString = [componentsToKeep componentsJoinedByString:@""];
	
	cleanedString = [cleanedString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
	cleanedString = [cleanedString stringByReplacingOccurrencesOfString:@"\r" withString:@""];
	cleanedString = [cleanedString stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
	cleanedString = [cleanedString stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
	cleanedString = [cleanedString stringByReplacingOccurrencesOfString:@"&hellip;" withString:@"..."];
	cleanedString = [cleanedString stringByReplacingOccurrencesOfString:@"&mdash;" withString:@"—"];
	
	//	cleanedString = [cleanedString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
	// Remove leading whitespace
	int i = 0;
	while ((i < [cleanedString length]) && [[NSCharacterSet whitespaceCharacterSet] characterIsMember:[cleanedString characterAtIndex:i]]) {
        i++;
    }
	cleanedString = [cleanedString substringFromIndex:i];
	
	return cleanedString;
	
}


@end
