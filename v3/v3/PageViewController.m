//
//  MyPageViewController.m
//  v3
//
//  Created by David Weissler on 8/4/15.
//  Copyright (c) 2015 John Bogil. All rights reserved.
//

#import "PageViewController.h"
#import "RepresentativesViewController.h"

@interface PageViewController ()<UIPageViewControllerDataSource, UIPageViewControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic, strong) UIViewController *firstVC;
@property (nonatomic, strong) UIViewController *secondVC;
@property (nonatomic, strong) NSArray *actualViewControllers;
@end

@implementation PageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource = self;
    self.delegate = self;
    
    RepresentativesViewController *initialViewController = [self viewControllerAtIndex:0];
    RepresentativesViewController *secondViewController = [self viewControllerAtIndex:1];
    RepresentativesViewController *thirdViewController = [self viewControllerAtIndex:2];


    NSArray *viewControllers = @[initialViewController];
    self.actualViewControllers = @[initialViewController,secondViewController,thirdViewController];

    [self setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:^(BOOL finished){}];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    RepresentativesViewController *thisViewController = (RepresentativesViewController *)viewController;
    
//    self.index = [(RepresentativesViewController *)viewController index];
    
//    if (self.index == 0) {
//        return nil;
//    }
//    if (thisViewController.index == 0) {
//        return nil;
//    }
//    
//    NSLog(@"before, %ld", thisViewController.index- 1);

    // Decrease theself.index by 1 to return
//   self.index--;
    NSInteger indexOfThisViewController = [self.actualViewControllers indexOfObject:viewController];
    if (indexOfThisViewController == 0) {
        return nil;
    }
    
    NSLog(@"before, %ld", indexOfThisViewController - 1);

    
    return self.actualViewControllers[indexOfThisViewController - 1];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
//   self.index = [(RepresentativesViewController *)viewController index];

//   self.index++;

    RepresentativesViewController *thisViewController = (RepresentativesViewController *)viewController;

//    NSLog(@"after, %ld", thisViewController.index + 1);
    
    NSInteger indexOfThisViewController = [self.actualViewControllers indexOfObject:viewController];

    if (indexOfThisViewController == 2) {
        return nil;
    }
    NSLog(@"after, %ld", indexOfThisViewController + 1);

    
    return self.actualViewControllers[indexOfThisViewController + 1];
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
    if(finished) {
        self.titleOfIncomingViewController = [[pageViewController.viewControllers firstObject] title];
        NSDictionary* userInfo = @{@"currentPage": self.titleOfIncomingViewController};
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changePage" object:userInfo];
    }
}

- (RepresentativesViewController *)viewControllerAtIndex:(NSUInteger)index {
    RepresentativesViewController *representativesViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"RepresentativesViewController"];
    representativesViewController.index = index;
    return representativesViewController;
}
@end