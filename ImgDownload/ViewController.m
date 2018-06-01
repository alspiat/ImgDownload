//
//  ViewController.m
//  ImgDownload
//
//  Created by Алексей on 31.05.2018.
//  Copyright © 2018 Алексей. All rights reserved.
//

#import "ViewController.h"
#import "CellView.h"

@interface ViewController () {
    int cellHeight;
    int offset;
}

@property (nonatomic, retain) NSArray<UIImageView*> *imageViewArray;
@property (nonatomic, retain) NSMutableArray<CellView*> *cellViewArray;
@property (nonatomic, retain) UIButton *refreshButton;
@property (nonatomic, retain) UILabel *loadingLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.whiteColor;
    cellHeight = self.view.bounds.size.width / 4;
    offset = self.view.bounds.size.width / 12;
    
    _refreshButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2 - cellHeight/2, self.view.bounds.size.height - cellHeight * 2, cellHeight, 30)];
    [self.refreshButton addTarget:self action:@selector(refresh) forControlEvents:UIControlEventTouchUpInside];
    [self.refreshButton setTitle:@"Refresh" forState:UIControlStateNormal];
    self.refreshButton.backgroundColor = UIColor.blackColor;
    [self.refreshButton.layer setCornerRadius:cellHeight/12];
    self.refreshButton.layer.masksToBounds = YES;
    
    [self.view addSubview:self.refreshButton];
    
    _loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2 - cellHeight/2, cellHeight * 3.5, cellHeight, 30)];
    self.loadingLabel.text = @"Loading...";
    self.loadingLabel.textAlignment = NSTextAlignmentCenter;
    [self.loadingLabel setHidden:YES];
    
    [self.view addSubview:self.loadingLabel];
    
    UIImageView *imageView4 = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2 - 3*cellHeight/2 - offset, self.view.bounds.size.height - cellHeight - offset, cellHeight, cellHeight)];
    UIImageView *imageView5 = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2 - cellHeight/2, self.view.bounds.size.height - cellHeight - offset, cellHeight, cellHeight)];
    UIImageView *imageView6 = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2 + cellHeight/2 + offset, self.view.bounds.size.height - cellHeight - offset, cellHeight, cellHeight)];
    
    _imageViewArray = [[NSArray alloc] initWithObjects:imageView4, imageView5, imageView6, nil];
    _cellViewArray = [[NSMutableArray alloc] initWithCapacity:3];
    
    for (UIImageView* imageView in self.imageViewArray) {
        [imageView.layer setCornerRadius:cellHeight/10];
        imageView.layer.masksToBounds = YES;
        [self.view addSubview:imageView];
    }
    
    [imageView4 release];
    [imageView5 release];
    [imageView6 release];
    
    [self refresh];
    
}

- (void)cleanView {
    for (UIImageView *imageView in self.imageViewArray) {
        imageView.image = nil;
    }
    
    for (CellView *cellView in self.cellViewArray) {
        [cellView removeFromSuperview];
    }
    [self.cellViewArray removeAllObjects];
}

- (void)refresh {
    
    [self cleanView];
    [self.refreshButton setEnabled:NO];
    [self.loadingLabel setHidden:NO];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self addCellViewWithDownloadedImage:@"https://www.wonderplugin.com/videos/demo-image0.jpg"];
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self addCellViewWithDownloadedImage:@"https://cdn-media.rtl.fr/cache/rQwYMu3pakcZ6yEbvK84CA/880v587-0/online/image/2017/0630/7789172554_la-voie-lactee-au-dessus-de-siding-spring-en-australie.jpg"];
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self addCellViewWithDownloadedImage:@"https://upload.wikimedia.org/wikipedia/commons/9/9a/Gull_portrait_ca_usa.jpg"];
    });
    
    [self downloadGroup];
}

- (void)safeDownloadWithURL: (NSString*) urlString andCompletion: (void (^)(UIImage*))successCompletion {
    NSURL *url = [NSURL URLWithString:urlString];
    NSData *imageDate = [NSData dataWithContentsOfURL:url];
    
    if (imageDate != nil) {
        UIImage *image = [UIImage imageWithData:imageDate];
        successCompletion(image);
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentAlertControllerWithTitle:@"Error" andMessage:@"Check your connection"];
        });
    }
}

- (void)addCellViewWithDownloadedImage: (NSString*) urlString {
    [self safeDownloadWithURL:urlString andCompletion:^(UIImage *image) {
        dispatch_async(dispatch_get_main_queue(), ^{
            CellView *cellView = [[CellView alloc] initWithFrame:CGRectMake(0, offset + cellHeight * self.cellViewArray.count, self.view.bounds.size.width, cellHeight)];
            cellView.urlLabel.text = urlString;
            cellView.imageView.image = image;
            
            [self.cellViewArray addObject:cellView];
            [self.view addSubview:cellView];
            
            [cellView release];
            
            [self checkButton];
        });
    }];
}

- (void)presentAlertControllerWithTitle: (NSString*) title andMessage: (NSString*) message {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    
    [alertController addAction:defaultAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)downloadGroup {
    NSMutableArray<UIImage*> *images = [NSMutableArray array];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_async(group, queue, ^{
        [self safeDownloadWithURL:@"https://cdn.pixabay.com/photo/2016/06/18/17/42/image-1465348_960_720.jpg" andCompletion:^(UIImage *image) {
            [images addObject:image];
        }];
        NSLog(@"1 finished");
    });
    
    dispatch_group_async(group, queue, ^{
        [self safeDownloadWithURL:@"https://www.jqueryscript.net/images/Simplest-Responsive-jQuery-Image-Lightbox-Plugin-simple-lightbox.jpg" andCompletion:^(UIImage *image) {
            [images addObject:image];
        }];
        NSLog(@"2 finished");
    });
    
    dispatch_group_async(group, queue, ^{
        [self safeDownloadWithURL:@"https://demo.phpgang.com/crop-images/demo_files/pool.jpg" andCompletion:^(UIImage *image) {
            [images addObject:image];
        }];
        NSLog(@"3 finished");
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"All finished!");
        
        [images enumerateObjectsUsingBlock:^(UIImage * _Nonnull image, NSUInteger idx, BOOL * _Nonnull stop) {
            self.imageViewArray[idx].image = image;
        }];
    });
    
    dispatch_release(group);
}

- (void)checkButton {
    if (self.cellViewArray.count == 3) {
        [self.refreshButton setEnabled:YES];
        [self.loadingLabel setHidden:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc {
    [_imageViewArray release];
    [_cellViewArray release];
    [_refreshButton release];
    [super dealloc];
}


@end
