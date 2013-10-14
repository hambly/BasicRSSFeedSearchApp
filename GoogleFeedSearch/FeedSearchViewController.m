//
//  FeedSearchViewController.m
//  GoogleFeedSearch
//
//  Created by Mark on 9/28/13.
//  Copyright (c) 2013 Mark Hambly. All rights reserved.
//

#import "FeedSearchViewController.h"
#import "FeedSearchConnection.h"
#import "FeedSearchCell.h"
#import "NSString+HTML.h"

@interface FeedSearchViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *searchField;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;

@property (strong, nonatomic) NSArray *searchResults;

@property (strong, nonatomic) FeedSearchConnection *connection;
@property (strong, nonatomic) NSNumber *isSearching;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation FeedSearchViewController


- (void)viewDidLoad{
    [super viewDidLoad];
	self.isSearching = @NO;
	self.tableView.dataSource = self;
	self.tableView.delegate = self;
	self.searchField.delegate = self;
	
	self.searchResults = [[NSArray alloc] init];
	[self.tableView setContentInset:UIEdgeInsetsMake(64, 0, 0, 0)];
}

- (IBAction)searchButtonPressed:(id)sender {
	
	[self.searchField resignFirstResponder];
	self.connection = [[FeedSearchConnection alloc] init];
	self.connection.searchQuery = self.searchField.text;
	[self.connection start];
	
//	self.isSearching = @YES;
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(feedSearchConnectionFinished:)
												 name:@"FeedSearchConnectionFinished"
											   object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(feedSearchConnectionFailed:)
												 name:@"FeedSearchConnectionFailed"
											   object:nil];

	
	self.searchButton.hidden = YES;
	[self.activityIndicator startAnimating];
	
	
}

-(void)feedSearchConnectionFinished: (NSNotification*)returnedNotice{
	
	self.searchResults = returnedNotice.object[@"responseData"][@"entries"];
	
	self.searchButton.hidden = NO;
	[self.activityIndicator stopAnimating];
	[self.tableView reloadData];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)feedSearchConnectionFailed: (NSNotification*)returnedNotice{
	[[[UIAlertView alloc] initWithTitle:nil
							   message:@"Connection Failed"
							  delegate:self
					 cancelButtonTitle:@"OK"
					  otherButtonTitles:nil] show];
	
}


#pragma mark - TableView Delegate & Data Source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.searchResults.count;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 80;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	FeedSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FeedSearchCell" forIndexPath:indexPath];
	NSDictionary *searchResult = self.searchResults[indexPath.row];
	cell.cellTitleLabel.text = [searchResult[@"title"] removeHTML];
	cell.cellUrlLabel.text = searchResult[@"url"];
	cell.cellDescriptionLabel.text = [searchResult[@"contentSnippet"] removeHTML];

	return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

	UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
	pasteboard.string = self.searchResults[indexPath.row][@"url"];
	NSString *alertString = [NSString stringWithFormat:@"Feed URL: \"%@\" has been copied to the clipboard",pasteboard.string];
	[[[UIAlertView alloc] initWithTitle:nil
							   message:alertString
							  delegate:self
					 cancelButtonTitle:@"Done"
					  otherButtonTitles: nil] show];
	
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	[self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

#pragma mark - TextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
	[self searchButtonPressed:textField];
	return YES;
}

@end
