//
//  JYSaveVideoData.m
//  SeptWeiYing
//
//  Created by Sept on 16/3/9.
//  Copyright © 2016年 九月. All rights reserved.
//

#import "JYSaveVideoData.h"

#import <Photos/Photos.h>

#define ICONS_WIDTH 50
#define ICONS_HEIGHT 30

@interface JYSaveVideoData() <PHPhotoLibraryChangeObserver>

@property (assign, nonatomic) BOOL isSave;

@end

@implementation JYSaveVideoData

static id _instace;

+ (id)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    
    dispatch_once (&onceToken, ^{
        
        _instace = [super allocWithZone:zone];
    });
    
    return _instace;
}

+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _instace = [[self alloc] init];
    });
    
    return _instace;
}

- (instancetype)copeWithZone:(NSZone *)zone
{
    return _instace;
}

/** 程序一启动的时候初始化图片选择按钮的图片 */
- (void)homeOfSetupImageWithSeletedBtn
{
    // 创建数组
    self.assetsArray = [NSMutableArray array];
    self.photosArray = [NSMutableArray array];
    self.thumbsArray = [NSMutableArray array];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        PHFetchOptions *allPhotosOptions = [[PHFetchOptions alloc] init];
        allPhotosOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
        PHFetchResult *allPhotos = [PHAsset fetchAssetsWithOptions:allPhotosOptions];
        self.fetchResults = @[allPhotos];
        
        PHAsset *asset = [allPhotos lastObject];
        [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
        
        // 设置图片选择按钮的图片显示
        [[PHCachingImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(ICONS_WIDTH * [UIScreen mainScreen].scale, ICONS_HEIGHT * [UIScreen mainScreen].scale) contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage *result, NSDictionary *info) {
            self.image = result;
        }];
        
        // 逆序加载相册资料
        [allPhotos enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [self.assetsArray addObject:obj];
        }];
    });
}

- (void)saveImageWithData:(NSData *)imageData
{
    [PHPhotoLibrary requestAuthorization:^( PHAuthorizationStatus status ) {
        if ( status == PHAuthorizationStatusAuthorized ) {
            // To preserve the metadata, we create an asset from the JPEG NSData representation.
            // 创建JPEG类型数据保存云数据
            // In iOS 9, we can use -[PHAssetCreationRequest addResourceWithType:data:options].
            // In iOS 8, we save the image to a temporary file and use +[PHAssetChangeRequest creationRequestForAssetFromImageAtFileURL:].
            if ( [PHAssetCreationRequest class] ) {
                [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                    [[PHAssetCreationRequest creationRequestForAsset] addResourceWithType:PHAssetResourceTypePhoto data:imageData options:nil];
                } completionHandler:^( BOOL success, NSError *error ) {
                    if ( ! success ) {
                        // 保存图像到照片库时出错
                        NSLog( @"Error occurred while saving image to photo library: %@", error );
                    }
                }];
            }
            else {
                NSString *temporaryFileName = [NSProcessInfo processInfo].globallyUniqueString;
                NSString *temporaryFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:[temporaryFileName stringByAppendingPathExtension:@"jpg"]];
                NSURL *temporaryFileURL = [NSURL fileURLWithPath:temporaryFilePath];
                
                [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                    NSError *error = nil;
                    [imageData writeToURL:temporaryFileURL options:NSDataWritingAtomic error:&error];
                    
                    if ( error ) {
                        // 将图像数据写入临时文件时出错
                        NSLog( @"Error occured while writing image data to a temporary file: %@", error );
                    }
                    else {
                        [PHAssetChangeRequest creationRequestForAssetFromImageAtFileURL:temporaryFileURL];
                    }
                } completionHandler:^( BOOL success, NSError *error ) {
                    
                    if ( ! success ) {
                        // 保存图像到照片库时出错
                        NSLog( @"Error occurred while saving image to photo library: %@", error );
                    }
                    
                    // 删除临时文件
                    [[NSFileManager defaultManager] removeItemAtURL:temporaryFileURL error:nil];
                }];
            }
        }
    }];
}

- (void)photosArrayAndthumbsArrayValue
{
    // 为了防止点击图片选择的时候重复添加最后一条数据到数组中
    PHFetchResult *fetchResult = [self.fetchResults lastObject];
    if (self.assetsArray.count != fetchResult.count) {
        [self.assetsArray addObject:[[self.fetchResults lastObject] lastObject]];
    }
    
    NSMutableArray *photos = [[NSMutableArray alloc] init];
    NSMutableArray *thumbs = [[NSMutableArray alloc] init];
    @synchronized(_assetsArray) {
        
        NSMutableArray *copy = [self.assetsArray copy];
        
        // Photos library
        UIScreen *screen = [UIScreen mainScreen];
        CGFloat scale = screen.scale;
        // Sizing is very rough... more thought required in a real implementation
        CGFloat imageSize = MAX(screen.bounds.size.width, screen.bounds.size.height) * 1.5;
        CGSize imageTargetSize = CGSizeMake(imageSize * scale, imageSize * scale);
        CGSize thumbTargetSize = CGSizeMake(imageSize / 3.0 * scale, imageSize / 3.0 * scale);
        for (PHAsset *asset in [copy reverseObjectEnumerator]) {
            [photos addObject:[MWPhoto photoWithAsset:asset targetSize:imageTargetSize]];
            [thumbs addObject:[MWPhoto photoWithAsset:asset targetSize:thumbTargetSize]];
        }
    }
    self.photosArray = photos;
    self.thumbsArray = thumbs;
}

#pragma mark - PHPhotoLibraryChangeObserver
/** 当拍照或者录像添加照片的时候回调用这代理 */
- (void)photoLibraryDidChange:(PHChange *)changeInstance
{
    /*
     Change notifications may be made on a background queue. Re-dispatch to the
     main queue before acting on the change as we'll be updating the UI.
     */
    dispatch_async(dispatch_get_main_queue(), ^{
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // Loop through the section fetch results, replacing any fetch results that have been updated.
        NSMutableArray *updatedSectionFetchResults = [self.fetchResults mutableCopy];
        __block BOOL reloadRequired = NO;
        
        [self.fetchResults enumerateObjectsUsingBlock:^(PHFetchResult *collectionsFetchResult, NSUInteger index, BOOL *stop) {
            PHFetchResultChangeDetails *changeDetails = [changeInstance changeDetailsForFetchResult:collectionsFetchResult];
            
            if (changeDetails != nil) {
                [updatedSectionFetchResults replaceObjectAtIndex:index withObject:[changeDetails fetchResultAfterChanges]];
                reloadRequired = YES;
            }
        }];
        
        if (reloadRequired) {
            self.fetchResults = updatedSectionFetchResults;
        }
    });
}

//获取文件的路径
- (NSString*)dataFilePath
{
    //1.获取文件路径数组，这个是因为考虑到为mac编写代码的原因
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);  //注意，括号里面的第一个元素是NSDocumentDirectory，而不是NSDocumentationDirectory
    
    //2.获取文件路径数组的第一个元素，因为我们只需要这一个
    NSString *documentPath = [paths objectAtIndex:0];
    
    //3.获取第2步得到的元素的字符串，并创建一个名为data.plist的.plist文件用于保存数据
    NSString *fileName = [documentPath stringByAppendingPathComponent:@"data.plist"];
    
    return fileName;
}

- (void)dealloc
{
    [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
}

@end
