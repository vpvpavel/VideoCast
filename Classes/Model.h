//
//  Model.h
//  CastVideos
//
//  Created by PavelVPV on 05.08.15.
//  Copyright (c) 2015 Google inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Model : NSObject

+ (Model *)sharedModel;

//@property (strong, nonatomic) UIImage *customerImage;
//@property (nonatomic, strong) NSString *phoneNumber;
//@property (nonatomic, strong) NSString *nameFirstOperation;
//@property (nonatomic, assign) NSInteger countOperation;

+ (Model *)init;


//tableview

//-(void)getOrders;
//- (void)deleteOrder:(NSNumber*)idOrder;

@property (nonatomic, strong) NSData *              dataFile;
@property (nonatomic, strong) NSData *              thumbnailImage;


@end
