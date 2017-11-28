//
//  TCIFilterViewController.m
//  TestBlurAVPlayer
//
//  Created by 谢艺欣 on 2017/11/28.
//  Copyright © 2017年 谢艺欣. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import "TCIFilterViewController.h"

@interface APLPlayerView : UIView

@property (nonatomic, strong) AVPlayer *player;

@end


@implementation APLPlayerView

+ (Class)layerClass
{
    return [AVPlayerLayer class];
}

- (AVPlayer *)player
{
    return [(AVPlayerLayer *)[self layer] player];
}

- (void)setPlayer:(AVPlayer *)player
{
    [(AVPlayerLayer *)[self layer] setPlayer:player];
}

@end

@interface TCIFilterViewController ()

@property IBOutlet APLPlayerView		*playerView;

@end

@implementation TCIFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupBlurVideoLink];
}

- (void)setupBlurVideoLink {
    AVURLAsset *asset1 = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"sample_clip1" ofType:@"m4v"]]];
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    AVVideoComposition *composition = [AVVideoComposition videoCompositionWithAsset:asset1 applyingCIFiltersWithHandler:^(AVAsynchronousCIImageFilteringRequest * _Nonnull request) {
        CIImage *source = request.sourceImage.imageByClampingToExtent;
        int currentTime = request.compositionTime.value / request.compositionTime.timescale;
        if (currentTime < 3) {
            [request finishWithImage:source context:nil];
        } else {
            [filter setValue:source forKey:kCIInputImageKey];
            
            CIImage *output = [filter.outputImage imageByCroppingToRect:request.sourceImage.extent];
            [request finishWithImage:output context:nil];
        }
    }];
    
    
    AVPlayerItem *item = [[AVPlayerItem alloc] initWithAsset:asset1];
    item.videoComposition = composition;
    
    AVPlayer *player = [[AVPlayer alloc] initWithPlayerItem:item];
    [self.playerView setPlayer:player];
    [player play];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
