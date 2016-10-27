#include "ACRootListController.h"

@implementation ACRootListController

-(void)viewDidLoad{
	[super viewDidLoad];
	
	settingsView = [[UIApplication sharedApplication] keyWindow];
	settingsView.tintColor = [UIColor colorWithRed:1.00 green:0.70 blue:0.01 alpha:1.0];
	
}

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"Root" target:self] retain];
	}
	return _specifiers;
}

-(void)respring{
	#pragma clang diagnostic push
	#pragma clang diagnostic ignored "-Wdeprecated-declarations"
	system("killall -9 SpringBoard");
	#pragma clang diagnostic pop
}

-(void)save{
	[self.view endEditing:true];
}
- (UIStatusBarStyle)preferredStatusBarStyle{ 
	return UIStatusBarStyleLightContent; 
}

@end
