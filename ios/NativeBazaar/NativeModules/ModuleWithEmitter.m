#import "ModuleWithEmitter.h"

@implementation ModuleWithEmitter

RCT_EXPORT_MODULE();

- (NSArray<NSString *> *)supportedEvents {
  // register name, may be more...
  return @[@"onServerStarted", @"onServerStartFailed", @"onServerStopped", @"onServerStopFailed"];
}

- (void)startObserving {
  NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
  for (NSString *notificationName in [self supportedEvents]) {
    [center addObserver:self
               selector:@selector(emitEventInternal:)
                   name:notificationName
                 object:nil];
  }
}

- (void)stopObserving {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)emitEventInternal:(NSNotification *)notification {
  [self sendEventWithName:notification.name
                     body:notification.userInfo];
}

+ (void)emitEventWithName:(NSString *)name andPayload:(NSDictionary *)payload {
  [[NSNotificationCenter defaultCenter] postNotificationName:name
                                                      object:self
                                                    userInfo:payload];
}

@end
