#import "FlutterEmbeddingAddonPlugin.h"
#if __has_include(<flutter_embedding_addon/flutter_embedding_addon-Swift.h>)
#import <flutter_embedding_addon/flutter_embedding_addon-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_embedding_addon-Swift.h"
#endif

@implementation FlutterEmbeddingAddonPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterEmbeddingAddonPlugin registerWithRegistrar:registrar];
}
@end
