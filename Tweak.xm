
#import "common.h"

#define ACServer_ArtistName [ACDataServer sharedInstance].artistName
#define ACServer_ACNAText [ACDataServer sharedInstance].ACNAText
#define ACServer_Enabled [ACDataServer sharedInstance].enabled
#define ACServer_ShouldDisplay [ACDataServer sharedInstance].shouldDisplay

//static BOOL ACEnabled = YES; // Default value

%group ZeppelinCompatibility

%hook ZPImageServer

-(BOOL)enabled{
	return !ACServer_ShouldDisplay;
}

%end

%end

%group defaulthook

%hook SBTelephonyManager

-(id)operatorName{

		NSString *operatorText = (ACServer_ArtistName ? ACServer_ArtistName : ACServer_ACNAText);

		return operatorText;
	}

	%end

	%hook SBStatusBarStateAggregator

	-(id)operatorName{
	return ([[%c(SBTelephonyManager) sharedTelephonyManager] operatorName] ? [[%c(SBTelephonyManager) sharedTelephonyManager] operatorName] : (/*ACEnabled*/true ? ACServer_ACNAText : %orig));
	}

	%end

	%hook SBMediaController

	-(void)_nowPlayingInfoChanged{

		%orig;

		void * main_q = dlsym(RTLD_DEFAULT, "_dispatch_main_q");

		void (*MRMediaRemoteGetNowPlayingInfo)(void *, void *) = (void (*)(void *, void *))dlsym(RTLD_DEFAULT, "MRMediaRemoteGetNowPlayingInfo");

		MRMediaRemoteGetNowPlayingInfo(main_q, ^(CFDictionaryRef information) {

			if(information){

				if(((__bridge NSDictionary*)information)[@"kMRMediaRemoteNowPlayingInfoArtist"]){

					ACServer_ShouldDisplay = true;
					ACServer_ArtistName = ((__bridge NSDictionary*)information)[@"kMRMediaRemoteNowPlayingInfoArtist"];

					[[%c(SBStatusBarStateAggregator) sharedInstance] _updateServiceItem];

				}

			}else{
				ACServer_ShouldDisplay = false;
			}

		});


		if(!self.isPlaying){
			
			ACServer_ShouldDisplay = false;
			ACServer_ArtistName = ACServer_ACNAText;

			[[%c(SBStatusBarStateAggregator) sharedInstance] _updateServiceItem];

		}

	}

	%end
	%end

	static void loadPrefs(){
		NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.c0ldra1n.artistcarrier9-preferences.plist"];

		if(prefs){		
		//ACEnabled =[[prefs objectForKey:@"ACEnabled"] boolValue];
			ACServer_ACNAText = (prefs[@"ACNAText"] ? prefs[@"ACNAText"] : @"ArtistCarrier");
			ACServer_ArtistName = ACServer_ACNAText;

			NSLog(@"ArtistCarrier9: Loaded Preference. %@", prefs);
		}else{
		//ACEnabled = YES;
			ACServer_ACNAText = @"ArtistCarrier";
			ACServer_ArtistName = ACServer_ACNAText;
		}

		[[%c(SBStatusBarStateAggregator) sharedInstance] _updateServiceItem];
	}

	%ctor {


		if(objc_getClass("ZPImageServer")){
			%init(ZeppelinCompatibility);
		}

		%init(defaulthook);

		CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)loadPrefs, CFSTR("com.c0ldra1n.artistcarrier9-preferences/settingschanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);
		loadPrefs();
	}
