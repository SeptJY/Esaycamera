//
//  JYSaveVideoData.h
//  SeptWeiYing
//
//  Created by Sept on 16/3/9.
//  Copyright © 2016年 九月. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JYSaveVideoData : NSObject

@property (nonatomic, strong) NSMutableArray *assetsArray;
@property (nonatomic, strong) NSMutableArray *photosArray;
@property (nonatomic, strong) NSMutableArray *thumbsArray;
@property (nonatomic, strong) NSArray *fetchResults;

@property (strong, nonatomic) UIImage *image;

+ (instancetype)sharedManager;

- (void)homeOfSetupImageWithSeletedBtn;

- (void)saveImageWithData:(NSData *)imageData;

- (void)photosArrayAndthumbsArrayValue;

- (NSString*)dataFilePath;

@end
