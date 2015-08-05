
#import "HTTPConnection.h"

@class MultipartFormDataParser;

@interface MyHTTPConnectionFile : HTTPConnection  {
    MultipartFormDataParser*        parser;
	NSFileHandle*					storeFile;
	
	NSMutableArray*					uploadedFiles;
}

@end
