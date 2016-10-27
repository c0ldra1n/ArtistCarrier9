
#include "common.h"

static ACDataServer *sharedInstance;

@implementation ACDataServer

-(id)init{
	self = [super init];
	return self;
}

+(void)initialize{
	static BOOL ACArtistNameServer_init;
	if(!ACArtistNameServer_init){
		sharedInstance = [[ACDataServer alloc] init];
	}
}

+(ACDataServer *)sharedInstance{
	return sharedInstance;
}
/*
-(NSString *)artistName{
	return self.artistName;
}

-(NSString *)ACNAText{
	return self.ACNAText;
}*/


@end