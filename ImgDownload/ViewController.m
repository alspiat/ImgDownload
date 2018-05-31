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
    int rowsCount;
}

@property (nonatomic, retain) NSArray<UIImageView*> *imageViewArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.whiteColor;
    cellHeight = self.view.bounds.size.width / 4;
    offset = self.view.bounds.size.width / 12;
    
    UIButton *refreshButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2 - cellHeight/2, self.view.bounds.size.height - cellHeight * 2, cellHeight, 30)];
    [refreshButton addTarget:self action:@selector(refresh) forControlEvents:UIControlEventTouchUpInside];
    [refreshButton setTitle:@"Refresh" forState:UIControlStateNormal];
    refreshButton.backgroundColor = UIColor.blackColor;
    [self.view addSubview:refreshButton];
    [refreshButton release];
    
    UIImageView *imageView4 = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2 - 3*cellHeight/2 - offset, self.view.bounds.size.height - cellHeight - offset, cellHeight, cellHeight)];
    UIImageView *imageView5 = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2 - cellHeight/2, self.view.bounds.size.height - cellHeight - offset, cellHeight, cellHeight)];
    UIImageView *imageView6 = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2 + cellHeight/2 + offset, self.view.bounds.size.height - cellHeight - offset, cellHeight, cellHeight)];
    
    _imageViewArray = [[NSArray alloc] initWithObjects:imageView4, imageView5, imageView6, nil];
    for (UIImageView* imageView in self.imageViewArray) {
        [self.view addSubview:imageView];
    }
    
    [imageView4 release];
    [imageView5 release];
    [imageView6 release];
    
    [self refresh];
    
}

- (void)refresh {
    
    [self.imageViewArray enumerateObjectsUsingBlock:^(UIImageView * _Nonnull imageView, NSUInteger idx, BOOL * _Nonnull stop) {
        rowsCount = 0;
    }];
    
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

- (void)addCellViewWithDownloadedImage: (NSString*) urlString {
    NSURL *url = [NSURL URLWithString:urlString];
    NSData *imageDate = [NSData dataWithContentsOfURL:url];
    
    if (imageDate != nil) {
        UIImage *image = [UIImage imageWithData:imageDate];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            CellView *cellView = [[CellView alloc] initWithFrame:CGRectMake(0, offset + cellHeight * rowsCount, self.view.bounds.size.width, cellHeight)];
            cellView.urlLabel.text = url.absoluteString;
            cellView.imageView.image = image;
            
            rowsCount++;
            [self.view addSubview:cellView];
            
            [cellView release];
        });
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentAlertControllerWithTitle:@"Error" andMessage:@"Check your connection"];
        });
    }
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
        NSURL *imageUrl4 = [NSURL URLWithString:@"https://cdn.pixabay.com/photo/2016/06/18/17/42/image-1465348_960_720.jpg"];
        NSData *imageDate4 = [NSData dataWithContentsOfURL:imageUrl4];
        
        if (imageDate4 != nil) {
            [images addObject:[UIImage imageWithData:imageDate4]];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self presentAlertControllerWithTitle:@"Error" andMessage:@"Check your connection"];
            });
        }
        NSLog(@"1 finished");
    });
    
    dispatch_group_async(group, queue, ^{
        NSURL *imageUrl5 = [NSURL URLWithString:@"https://www.jqueryscript.net/images/Simplest-Responsive-jQuery-Image-Lightbox-Plugin-simple-lightbox.jpg"];
        NSData *imageDate5 = [NSData dataWithContentsOfURL:imageUrl5];
        
        if (imageDate5 != nil) {
            [images addObject:[UIImage imageWithData:imageDate5]];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self presentAlertControllerWithTitle:@"Error" andMessage:@"Check your connection"];
            });
        }
        NSLog(@"2 finished");
    });
    
    dispatch_group_async(group, queue, ^{
        NSURL *imageUrl6 = [NSURL URLWithString:@"https://demo.phpgang.com/crop-images/demo_files/pool.jpg"];
        NSData *imageDate6 = [NSData dataWithContentsOfURL:imageUrl6];
        
        if (imageDate6 != nil) {
            [images addObject:[UIImage imageWithData:imageDate6]];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self presentAlertControllerWithTitle:@"Error" andMessage:@"Check your connection"];
            });
        }
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc {
    [_imageViewArray release];
    [super dealloc];
}


@end
