#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^DeepBeliefCompletion)(NSDictionary * _Nonnull result);

@interface DeepBeliefBridge : NSObject

- (void)process:(UIImage * _Nonnull)image
     complition:(DeepBeliefCompletion _Nonnull)completion;

@end
