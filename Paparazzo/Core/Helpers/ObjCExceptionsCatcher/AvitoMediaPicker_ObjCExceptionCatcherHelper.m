#import "AvitoMediaPicker_ObjCExceptionCatcherHelper.h"

@implementation AvitoMediaPicker_ObjCExceptionCatcherHelper

+ (void)try:(NS_NOESCAPE void(^)())tryBlock catch:(void(^)(NSException *))catchBlock finally:(void(^)())finallyBlock {
    @try {
        tryBlock();
    }
    @catch (NSException *exception) {
        catchBlock(exception);
    }
    @finally {
        finallyBlock();
    }
}

@end
