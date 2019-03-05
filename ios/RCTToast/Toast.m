#import <UIKit/UIKit.h>
#import <React/RCTLog.h>
#import <React/RCTBridgeModule.h>
#import "UIView+Toast.h"


@interface Toast : NSObject <RCTBridgeModule>
@end

@implementation Toast

RCT_EXPORT_MODULE(Toast)

static NSDictionary * POSITION_MAPING () {
    return @{
             @"top": CSToastPositionTop,
             @"center": CSToastPositionCenter,
             @"bottom": CSToastPositionBottom
             };;
}


RCT_EXPORT_METHOD(show:(NSDictionary *)options) {
    NSString *message  = [options objectForKey:@"message"];
    NSString *duration = [options objectForKey:@"duration"];
    NSString *position = [options objectForKey:@"position"];
    
    if (![position isEqual: @"top"] && ![position isEqual: @"center"] && ![position isEqual: @"bottom"]) {
        RCTLogError(@"invalid position. valid options are 'top', 'center' and 'bottom'");
        return;
    }
    
    position = POSITION_MAPING(position);
    
    NSTimeInterval durationInterval;
    if ([duration isEqual: @"short"]) {
        durationInterval = 2;
    } else if ([duration isEqual: @"long"]) {
        durationInterval = 5;
    } else {
        durationInterval = 1.5;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIView *hostView = [[[UIApplication sharedApplication]windows]firstObject];
        if(!hostView) {
            hostView = [[UIApplication sharedApplication] keyWindow];
        }
        
        [hostView makeToast:message duration:durationInterval position:position style:[[CSToastStyle alloc] initWithDefaultStyle]];
        
    });
}

RCT_EXPORT_METHOD(hide) {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIView *hostView = [[[UIApplication sharedApplication]windows]firstObject];
        if(!hostView) {
            hostView = [[UIApplication sharedApplication] keyWindow];
        }
        [hostView hideToast];
    });
}

@end
