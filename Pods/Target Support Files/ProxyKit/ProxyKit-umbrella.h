#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "GCDAsyncProxySocket.h"
#import "SOCKSProxy.h"
#import "SOCKSProxySocket.h"

FOUNDATION_EXPORT double ProxyKitVersionNumber;
FOUNDATION_EXPORT const unsigned char ProxyKitVersionString[];

