//
//  MainViewController.m
//  Collections
//
//  Created by Nicolas Melo on 8/8/14.
//  Copyright (c) 2014 melo. All rights reserved.
//

#import "MainViewController.h"
#import "CollectionViewCardCell.h"

@interface MainViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *backgroundViews;

@property (assign, nonatomic) NSInteger lastIndex;

@property (strong, nonatomic) UIView *currentView;
@property (strong, nonatomic) UIView *nextView;

@property (assign, nonatomic) BOOL isScrollingDown;

@end

@implementation MainViewController

- (id)init {
    self = [self initWithNibName:nil bundle:nil];
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UIColor *red = [UIColor colorWithRed:255/255.0f green:150/255.0f blue:241/255.0f alpha:1.0f];
        UIColor *blue = [UIColor colorWithRed:90/255.0f green:150/255.0f blue:241/255.0f alpha:1.0f];
        UIColor *yellow = [UIColor colorWithRed:255/255.0f green:204/255.0f blue:0/255.0f alpha:1.0f];
        
        UIView *redView = [[UIView alloc] init];
        redView.backgroundColor = red;
        redView.frame = [UIScreen mainScreen].bounds;
        
        UIView *blueView = [[UIView alloc] init];
        blueView.backgroundColor = blue;
        blueView.frame = [UIScreen mainScreen].bounds;
        
        UIView *yellowView = [[UIView alloc] init];
        yellowView.backgroundColor = yellow;
        yellowView.frame = [UIScreen mainScreen].bounds;
        
        self.backgroundViews = @[redView, blueView, yellowView];
        self.lastIndex = -1;
        self.isScrollingDown = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.view.backgroundColor = [UIColor blackColor];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(320, 568);
    flowLayout.sectionInset = UIEdgeInsetsZero;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    self.collectionView.backgroundColor = [UIColor clearColor];

    self.collectionView.collectionViewLayout = flowLayout;
    
    UINib *nib = [UINib nibWithNibName:@"CollectionViewCardCell" bundle:nil];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:@"CardIdentifier"];
    
    self.currentView = self.backgroundViews[0];
    self.nextView = self.backgroundViews[0];
    self.currentView.alpha = 1.0f;
    [self.view addSubview:self.currentView];
    [self.view addSubview:self.collectionView];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCardCell *cardCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CardIdentifier" forIndexPath:indexPath];
    
    cardCell.backgroundColor = [UIColor clearColor];
    cardCell.layer.borderColor = [[UIColor blackColor] CGColor];
    cardCell.layer.borderWidth = 1.0f;
    
    NSLog(@"index %lu, frame (%f, %f)", indexPath.row, cardCell.frame.size.width, cardCell.frame.size.height);
    
    return cardCell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat contentOffset = scrollView.contentOffset.y;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    NSInteger index = contentOffset / screenHeight;
    
    
//    NSLog(@"contentOffset %f, screenHeight %f, index %lu, lastIndex %ld, yOffset %f, lastYOffset %f", contentOffset, screenHeight, index, (long)self.lastIndex, yOffset, self.lastYOffset);
    
    if (self.lastIndex > index) {
    
        NSLog(@"First scroll up through new cell  ++++++++++++++++++++++++++++++++++++++++");
        self.isScrollingDown = NO;
        // scrolling up, previous cell is now present
        self.currentView = self.backgroundViews[(index + 1) % 3];
        self.nextView = self.backgroundViews[index % 3];
        self.nextView.alpha = 0.0f;

        [self.view addSubview:self.nextView];
        [self.view addSubview:self.collectionView];
        
    } else if (self.lastIndex < index) {
        
        NSLog(@"First scroll down through new cell ==========================================");
        self.isScrollingDown = YES;
        // scrolling down, next cell is present
        self.currentView = self.backgroundViews[index % 3];
        self.nextView = self.backgroundViews[(index + 1) % 3];
        self.nextView.alpha = 0.0f;
        
        [self.view addSubview:self.nextView];
        [self.view addSubview:self.collectionView];
        
    } else {
        // 2 views on screen
        CGFloat yOffset = contentOffset - (screenHeight * index);
        
        CGFloat bottomViewAlpha = yOffset / screenHeight;
        CGFloat topViewAlpha = 1 - bottomViewAlpha;
        
        NSLog(@"bottomViewAlpha %f, topViewAlpha %f", bottomViewAlpha, topViewAlpha);
        
        if (self.isScrollingDown) {
        
            self.currentView.alpha = topViewAlpha;
            self.nextView.alpha = bottomViewAlpha;
        } else {
            self.currentView.alpha = bottomViewAlpha;
            self.nextView.alpha = topViewAlpha;
        }
        
    }

    self.lastIndex = index;
}

@end
